# TPSIT App Memo

Applicazione App Memo.

## Descrizione

TPSIT App Memo è un'applicazione utilizzabile come promemoria con dei memo.
Viene gestito tramite l'utilizzo di google per loggare.

Ho implementato alcune features tra cui:
- Refresh dei messaggi instantaneo tramite un bottone nella homepage;
- Bottoni di log-in e log-out google nella homepage;
- Temi dinamici in versione light e dark in base alle impostazioni del cellulare;
- Bottone cestino per cancellare tutti i memo;
- Bottone cestino per eliminare il memo corrente;
- Possibilità di modifica del memo;

## Utilizzo

NB. Necessità di un account google per poter funzionare!!
In questa applicazione per il corretto funzionamento dei Memo ho deciso di utilizzare alcune classi divise per sezioni:

- DAO
```dart
Dao_floor.dart
```

- DATABASE
```dart
Database.dart
Database.g.dart (generato automaticamente)
```

- ENTITA'
```dart
Memo.dart
```

- MAIN FILES
```dart
Main.dart
JsonApi.dart
NewMemo.dart
Generated_plugin_registrant.dart (generato automaticamente)
```


### Dar_floor


- Definisce tutti i metodi applicabili all'entità memo
```dart
  @insert
  Future<void> newMemo(Memo memo);

  @delete
  Future<void> deleteMemo(Memo memo);
  
  @Query('SELECT * from Memo')
  Stream<List<Memo>> getAllMemo();

  @update
  Future<void> updateMemo(Memo memo);

  @Query('SELECT * from Memo WHERE id=:id')
  Stream<Memo> getMemoById(int id);

  @Query('DELETE FROM Memo')
  Future<void> deleteAllMemo();
```


### Database


- File dal quale si creerà il database
```dart
@Database(version: 1, entities: [Memo]) 
abstract class AppDatabase extends FloorDatabase {
  Dao_floor get dao_floor;
}
```


### Memo


- Metodo fetchDataList() prendendo spunto dall'app Maree
```dart
Future<List<Memo>> fetchDataList() async { 
  final response = await http.get('https://2524fb95ed5e.ngrok.io');
  if (response.statusCode == 200) {
    final parsed = json.decode(response.body);
    print('body parsed ${parsed}');
    print(parsed.toString());
    return parsed.map<Memo>((json) => Memo.fromJson(json)).toList();
  } else {
    throw Exception('Errore inserimento dati!');
  }
}
```

- Entità Memo JSON generata automaticamente da un sito 
```dart
@entity
class Memo {  
  @PrimaryKey(autoGenerate: true)
  final int id;
  String title;
  String body;
  String tag;
  String status;
  Memo({this.id, this.title, this.body, this.tag, this.status});

  factory Memo.fromJson(Map<String, dynamic> json) {
    return Memo(
      id: json['id'] as int,
      title: json['title'] as String,
      body: json['body'] as String,
      tag: json['tag'] as String,
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['body'] = this.body;
    data['tag'] = this.tag;
    data['status'] = this.status;
    return data;
  }
}
```


### JsonApi


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