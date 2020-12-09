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

- TextField dove inserire l'IP del Server dove bisogna connettersi
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



```dart
```

```dart
```


Ho optato per l'utilizzo di 4 semplici pulsanti "FlatButton":
>*Start*

Codice del pulsante FlatButton
```dart
FlatButton(
    color: Colors.lightGreen,
    textColor: Colors.white,
    disabledColor: Colors.grey,
    disabledTextColor: Colors.black,
    padding: EdgeInsets.all(8.0),
    splashColor: Colors.blueAccent,
    onPressed: contatore,
    child: Text(
      "Start",
      style: TextStyle(fontSize: 20.0),
    ),
),
```

Codice della funzione contatore che viene invocata subito dopo la pressione
```dart
contatore() --> tornare su per vedere il codice per esteso
```

>*Stop*

Codice del pulsante FlatButton
```bash
Analogo al precedente con la differenza che al momento della pressione questo pulsante
richiama la funzione stop() e che il testo del pulsante è "Stop"
```

Codice della funzione stop che viene invocata subito dopo la pressione
```dart
void stop() {
    started = false;
}
```
started è un valore booleano che sta ad indicare che il contatore è partito(se "true")
e sta ad indicare che il contatore si è fermato(se "false"). 
In questo caso è impostato a false perchè si trova nella funzione che viene invocata quando viene premuto il
pulsante adibito allo stop del contatore.

>*Reset*

Codice del pulsante FlatButton
```bash
Analogo al precedente con la differenza che al momento della pressione questo pulsante
richiama la funzione reset() e che il testo del pulsante è "Reset"
```

Codice della funzione reset che viene invocata subito dopo la pressione
```dart
 void reset() {
    _counter = 0;
    _counterMin = 0;
    _counterOre = 0;
    secondi = 0;
    minuti = 0;
    ore = 0;
    started = false;
  }
```
_counter, _counterMin e _counterOre stanno ad indicare i secondi, minuti ed ore riferiti all'orario del cronometro in tempo
reale.
secondi, minuti ed ore indicano invece quelli riferiti al tempo del Giro che vedremo a breve.

>*Giro*

Codice del pulsante FlatButton
```bash
Analogo al precedente con la differenza che al momento della pressione questo pulsante
richiama la funzione giro() e che il testo del pulsante è "Giro"
```

Codice della funzione giro che viene invocata subito dopo la pressione
```dart
void giro() {
    secondi = _counter;
    minuti = _counterMin;
    ore = _counterOre;
}
```
Questa funzione copia i secondi, minuti ed ore del cronometro e le assegna alle variabili adibite
alla visualizzazione dell'ultimo Giro.

## Visualizzazione

Per la visualizzazione di questo cronometro ho deciso di usare il Widget "Text" come possiamo
vedere di seguito
```dart
Text(_counterOre < 10 ? '0$_counterOre:' : '$_counterOre:',
    style: Theme.of(context).textTheme.headline4),
Text(_counterMin < 10 ? '0$_counterMin:' : '$_counterMin:',
    style: Theme.of(context).textTheme.headline4),
Text(_counter < 10 ? '0$_counter' : '$_counter',
    style: Theme.of(context).textTheme.headline4),
```
Usiamo degli if-else per la visualizzazione per risolvere il problema dello 0 non visualizzabile prima
del raggiungimento della decima cifra.
Quindi per esempio se _counter(secondi) è minore di 10, aggiungi uno 0 davanti al numero, altrimento(else) 
scrivi i secondi normalmente(significa che è già arrivato alla decima cifra).


## Roadmap

Idee per versioni future:

- Aggiungere decorazioni
- Aggiungere features di facilitazione come può essere che alla pressione del tasto "Start" si nascondino tutti i pulsanti tranne
  Giro & Stop, al momento della pressione sullo "Stop" si nascondano i due pulsanti visibili e rendere visibili "Start" & "Reset"
- Aggiungere una lista scrollable di Widget dove sarà possibile la visualizzazione di tutti i giri(e quindi non solo dell'ultimo)
  e visualizzando in verde il tempo migliore, in rosso i tempi peggiori.

## Stato del progetto

```bash
v1.0 Finished
```

## Author

Veni Alessio - 5IA - ITIS C. Zuccante