# TPSIT Chatroom

Applicazione Chatroom.

## Descrizione

TPSIT Chatroom è un'applicazione utilizzabile come chat fra diversi utenti(min. 2) con un massimale non definito.
Viene gestito come fosse un gruppo: dove possono entrare più utenti contemporaneamente per chattare!

Ho implementato alcune features tra cui:
- Cestino messaggi;
- Controllo IP e User tramite criteri ben definiti per non effettuare connessioni accidentali;
- Temi colorati;
- Doppie spunte di visualizzazione;
- Vari tasti di invio e di delete inserimento dati;
- Ora e Nome del mittente del messaggio.

## Utilizzo

In questa applicazione per il corretto funzionamento della Chatroom ho deciso di utilizzare 3 classi:

```dart
Main.dart
ServerSocket.dart
ServerChatroom.dart
```


### Main


- initState() dove vengono riportate tutti gli stati iniziali
```dart
  @override
  void initState() {
    utente = User("name", "");
    server = new ServerSocket();
    connected = false;
    mexs = new List();
    controllermexs = new TextEditingController();
    controllerUser = new TextEditingController();
    controllerIP = new TextEditingController();
    super.initState();
  }
```

- receive() dove l'app controlla se ci sono errori nei messaggi e "pulisce" la stringa
```dart
  void receive(data) {
    print("Received!");
    String istruzioni =
        new String.fromCharCodes(data).trim();
    int istruzioniCode = int.parse(istruzioni[0]);
    String istruzioniData = istruzioni.substring(1);
    connected = true;
    switch (istruzioniCode) {
```
Qua possiamo notare che nel caso "0" e "1" dello switch il messaggio viene diviso e creato e aggiunto quello che sarà 
poi il messaggio visualizzato con due casistiche differenti
```dart
      case 0:
        {
          var listMessage = istruzioniData.split("|");
          listMessage.forEach((message) {
            var mex = message.split("%/");
            if (mex.length > 2) {
              mexs.add(
                  new Message(mex[0], mex[1], DateTime.parse(mex[2]), mex[3]));
            }
          });

          break;
        }
      case 1:
        {
          mexs.add(new Message("name", "", DateTime.now(), "mexs"));
          break;
        }
    }
    setState(() {});
  }
```


- Controlli aggiuntivi per verificare IP e User
```dart
  bool controlIpNull() {
    return controllerIP.text != "";
  }

  bool controlIpReal() {
    return controllerIP.text != "" && controllerIP.text.length >= 7 && controllerIP.text.contains(".");
  }

  bool controlUserNull() {
    return controllerUser.text !=  "";
  }
```

- cls() per cancellare la lista dei messaggi nella chat
```dart
  void cls() {
    print("All Mex Deleted!");
    setState(() {
      mexs = [];
    });
  }
```

- sendMessage() per verificare se il messaggio è vuoto e per garantirne la spedizione
```dart
  void sendMessage() {
    if (controllermexs.text != null && controllermexs.text != "") 
      server.send("2" +
          utente.nome +
          "%/" +
          utente.cognome +
          "%/" +
          DateTime.now().toString() +
          "%/" +
          controllermexs.text);
    controllermexs.text = "";
    setState(() {
    });
  }
```
### Main - Widget

- TextField dove inserire l'IP del Server per connettersi
```dart
Container(
    decoration: BoxDecoration(
        color: Colors.teal[100].withOpacity(0.8),
        borderRadius: BorderRadius.all(Radius.circular(10))),
        child: TextField(
            onChanged: (text) {
                print(controllerIP.text.contains("."));
                setState(() {});
            },
            keyboardType: TextInputType.number,
            controller: controllerIP,
            cursorColor: Colors.white,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Server Ip',
                suffixIcon: Visibility(
                    visible: controlIpNull(),
                    child: IconButton(
                        color: Colors.black,
                        onPressed: () =>
                            {controllerIP.clear(), setState(() {})},
                            icon: Icon(Icons.clear),
                    ),
                ),
                prefixIcon: Visibility(
                    visible: controlIpReal(),
                    child: IconButton(
                        color: Colors.green,
                        icon: Icon(Icons.verified),
                    ),
                ),
            ),
        ),
    ),
```
- TextField dove inserire il proprio nome Utente per iniziare a chattare!
```dart
Container(
    decoration: BoxDecoration(
        color: Colors.teal[100].withOpacity(0.8),
    borderRadius: BorderRadius.all(Radius.circular(10))),
        child: TextField(
            onChanged: (text) {
                setState(() {});
            },
            controller: controllerUser,
            cursorColor: Colors.white,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Name',
                suffixIcon: Visibility(
                    visible: controlUserNull(),
                    child: IconButton(
                        color: Colors.black,
                        onPressed: () =>
                            {controllerUser.clear(), setState(() {})},
                        icon: Icon(Icons.clear),
                    ),
                ),
                prefixIcon: Visibility(
                    visible: controlUserNull(),
                    child: IconButton(
                        color: Colors.green,
                        icon: Icon(Icons.verified),
                    ),
                ),
            ),
        ),
    ),
```
- Bottone che quando cliccato permette l'invio dei dati inseriti nei due TextField e quindi di connettersi(se i dati sono correttamente inseriti)
permette inoltre la creazione di un nuovo User utilizzando il nome inserito
```dart
Container(
    alignment: Alignment.center,
    decoration: BoxDecoration(
        color: Colors.teal[100].withOpacity(0.8),
        borderRadius: BorderRadius.all(Radius.circular(35))),
        child: FlatButton(
            minWidth: 250,
            onPressed: () {
                utente = new User(controllerUser.text, " "); 
                ip = controllerIP.text;
                server.connect(utente, receive, ip);
            },
            child: Text("Click to Connect!"),
        ),
    ),
```
- Layout seconda schermata di chat, textField che permette l'invio del messaggio e possibilità di visualizzarlo
nel body
```dart
return Scaffold(
    appBar: AppBar(
        leading: IconButton(
            color: Colors.black,
            onPressed: () => {},
            icon: Icon(Icons.account_circle),
        ),
        title: Text(controllerUser.text),
        actions: [
            IconButton(
                color: Colors.black,
                onPressed: () => {cls()},
                icon: Icon(Icons.delete),
            ),
        ],
    ),
    body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/photo.jpg"),
                fit: BoxFit.cover,
            ),
        ),
        child: Column(
            children: [
                Expanded(
                    child: ListView.builder(
                        itemCount: mexs.length,
                        reverse: true,
                        itemBuilder: (context, index) {
                            if (mexs[mexs.length - index - 1].name == utente.nome) {
                                return Container(
                                    child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                            children: [
                                                Spacer(),
                                                MexMaker(index),
                                            ],
                                        ),
                                    ),
                                );
                            } else {
                                return Container(
                                    child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                            children: [
                                               MexMaker(index),
                                               Spacer(),
                                            ],
                                        ),
                                    ),
                                );
                            }
                        },
                    ),
                ),
                Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(45)),
                        child: Container(
                            color: Colors.grey[900],
                            child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 10, right: 10, top: 2, bottom: 2),
                                    child: Row(
                                        children: [
                                            Expanded(
                                                child: TextField(
                                                    controller: controllermexs,
                                                    style: TextStyle(color: Colors.black),
                                                    decoration: InputDecoration(
                                                        border: InputBorder.none,
                                                    hintText: 'Message...'),
                                                ),
                                            ),
                                            IconButton(
                                                icon: Icon(Icons.send),
                                                color: Colors.lightBlueAccent[100],
                                                onPressed: () {
                                                    sendMessage();
                                                })
                                            ],
                                        ),
                                    ),
                                ),
                            ),
                        ),
                    ],
                )
            )
        )
    )
);
```
- Creazione del messaggio che verrà poi visualizzato nella seconda schermata di chat(secondo Scaffold) 
```dart
Widget MexMaker(int pos) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.teal[900].withOpacity(0.8),
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${mexs[mexs.length - pos - 1].name}',
              style: TextStyle(color: Colors.white60, fontSize: 10),
            ),
            Text(
              '${mexs[mexs.length - pos - 1].message}',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            Text(
              '${mexs[mexs.length - pos - 1].time}' + ' ✓✓',
              style: TextStyle(color: Colors.white60, fontSize: 10, ),
            ),
          ],
        ),
      ),
    );
  }
}
```


### ServerSocket

- Gestisce il Server Socket, lo User, la funziona che riceve il messaggio e l'indirizzo IP, tutto questo in modo asincrono
```dart
class ServerSocket {
  Socket _socket;
  List<Message> chat = [];

  void connect(User _userData, Function receive, ip) async {
    await Socket.connect(ip, 8000).then((Socket sock) {
      this._socket = sock;
      _socket.listen(receive,
          onError: _errorHandler, onDone: _doneHandler, cancelOnError: false);
    }).catchError((Object e) {
      print("Unable to connect: $e");
    });

    _socket.write("1" + _userData.nome.toLowerCase() + "%/" + _userData.cognome.toLowerCase());
  }

  void _errorHandler(error, StackTrace trace) {
    print(error);
  }

  void Destroy() {
    _socket.destroy();
  }

  void _doneHandler() {
    _socket.destroy();
  }

  void send(data) {
    _socket.write(data);
  }
}
```
- Costruttore del messaggio con i seguenti paramentri: Nome, Cognome(facoltativo, utilizzato nelle prossime versioni),
data del messaggio e la parte più importante, Il messaggio
```dart
class Message { 
  String _name;
  String _surname;
  DateTime _dateTime;
  String _message;

  Message(this._name, this._surname, this._dateTime, this._message);

  String get name => this._name;
  String get surname => this._surname;
  String get time =>
      getTime(this._dateTime.hour.toString()) + ":" +
      getTime(this._dateTime.minute.toString());
  String get message => this._message;
  String getTime(String time) {
    return ( int.parse(time) < 9) ? "0" + time : time;
  }
}
```


### ServerChatroom

- Main dove si stabilisce la connessione con il server socket
```dart
void main() {
  Messaggi = new List();
  ServerSocket server;
  // InternetAddress.anyIPv4
  ServerSocket.bind(InternetAddress.anyIPv4, 8000).then((ServerSocket socket) {
    server = socket;
    print('Connection.. --> ' + server.address.address);
    server.listen((client) {
      handleConnection(client);
    });
  });
}

void handleConnection(Socket client) {
  print("\n");
  print("Connected:");
  clients.add(ChatClient(client));
}

void removeClient(ChatClient client) {
  clients.remove(client);
}
```

- Classe che gestisce l'invio dei messaggi e la gestione del server con la creazione degli Utenti
```dart
class ChatClient { 
  Socket _socket;
  String get address => _socket.remoteAddress.address;
  int get port => _socket.remotePort;
  User user = new User();

  ChatClient(Socket s) {
    _socket = s;
    _socket.listen(clientHandler,
        onError: errorHandler, onDone: finishedHandler);
  }

  void clientHandler(data) {
    String istruzioni = new String.fromCharCodes(data).trim();
    int istruzioniCode = int.parse(istruzioni[0]);
    String istruzioniData = istruzioni.substring(1);

    switch (istruzioniCode) {
      case 1:
        {
          //new user
          var userData = istruzioniData.split("%/");
          print("Un nuovo Utente si e' appena collegato!");
          print("\n");
          try {
            user.name = userData[0];
            user.surname = userData[1];
          } catch (e) {
            //print("$e");
          }
          if (user.isNotNull()) {
            String msg = "";
            for (int i = 0; i < Messaggi.length; i++) {
              msg += Messaggi[i] + "|";
            }
            _socket.write("0" + msg);
          }
          break;
        }
      case 2: //nuovo messaggio
        {
          print("Mex: " + istruzioniData);

          Messaggi.add(istruzioniData);
          clients.forEach((client) {
            client._socket.write("0" + istruzioniData);
          });
          break;
        }
    }
  }

  void errorHandler(error) {}

  void finishedHandler() {}
}
```

- Costruttore Utente
```dart
class User {
  String _name;
  String _surname;

  String get name => this._name;
  String get surname => this._surname;

  set name(String name) => this._name = name;
  set surname(String surname) => this._surname = surname;

  bool isNotNull() {
    return this._name != null && this._surname != null ? true : false;
  }

  String toString() {
    return this._name + "|" + this._surname + "|";
  }
}
```


## Eseguibilità e Test

Per eseguire questa applicazione necessitiamo di:
- 2 o più emulatori Android e/o Telefoni con sistema operativo nativo Android;
- un server;
- dart installato nel S.O.

1)
Iniziamo con l'aprire il cmd e digitare "ipconfig" per determinare il nostro IPv4 da utilizzare per connettersi successivamente tramite app al server.
Dopo aver messo da parte e salvato l'indirizzo IPv4 con lo stesso cmd ci dirigiamo nella cartella dove c'è il file ServerChatroom.dart e eseguiamo questa
stringa "dart ServerChatroom.dart" per far partire il server e teniamo quella finestra aperta per tutta la durata dell'app testing.

2)
Successivamente apriamo i 2 o più emulatori e/o telefoni con sistema nativo Android e runniamo le due applicazioni(che avranno lo stesso codice main.dart),
dopodichè nell'app ci verrà chiesto di inserire Indirizzo IP Server e Username, nel primo campo inseriamo l'indirizzo IPv4 salvato precedentemente e nel secondo campo
l'username da utilizzare per chattare e cliccare connettiti.
ATTENZIONE: scegliere username differenti altrimenti il collegamento verrà rifiutato! (feature voluta).

3)
Ora, finalmente connessi, si può iniziare a chattare grazie al semplice layout della pagina! 

## Roadmap

Idee per versioni future:

- Aggiungere decorazioni e animazioni
- Aggiungere una modalità di cambio Tema/Sfondo e Colori
- Aggiungere funzione visualizza profilo
- Aggiungere funzione scambio immagini
- Aggiungere funzione scambio link

## Stato del progetto

```bash
v1.0 Finished
```

## Author

Veni Alessio - 5IA - ITIS C. Zuccante