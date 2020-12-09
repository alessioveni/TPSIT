import 'package:chatroom/client/ServerSocket.dart';
import 'package:flutter/material.dart';

// import 'IpAddress.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chatroom',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Chatroom Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //nome della chatroom
  String userName = "";
  //classe client usate per connettersi al server
  ServerSocket server;
  //lista che contiene i messaggi
  List<Message> mexs;
  // controller  dell input del messaggio
  TextEditingController controllermexs; //messaggio che invii
  TextEditingController controllerUser; //username
  TextEditingController controllerIP; //ip server che inserisci

  //utente
  User utente; //creazione utente per chattare
  String ip;
  //controlla se connesso
  bool connected;
  bool settings;

  @override
  void initState() {
    //stato iniziale
    utente = User("name", "");
    server = new ServerSocket();
    connected = false;
    mexs = new List();
    controllermexs = new TextEditingController();
    controllerUser = new TextEditingController();
    controllerIP = new TextEditingController();
    super.initState();
  }

  void receive(data) {
    //controlla se ci sono errori nei messaggi

    print("Received!");
    String istruzioni =
        new String.fromCharCodes(data).trim(); //pulisce la stringa
    int istruzioniCode = int.parse(istruzioni[0]); //pulisce la stringa
    String istruzioniData = istruzioni.substring(1); //pulisce la stringa
    print(istruzioni); //stampa
    connected = true;
    switch (istruzioniCode) {
      case 0:
        {
          //splitta e prende il messaggio
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
          //crea nuovo messaggio
          mexs.add(new Message("name", "", DateTime.now(), "mexs"));
          break;
        }
    }
    setState(() {}); //apporta modifiche visuali all'interfaccia grafica
  }

  void setName(data) {
    //set dello nome
    setState(() {
      userName = data;
    });
  }

  void onerror(data) {
    setState(() {
      userName = data;
    });
  }

  bool isIpNotNull() {
    return controllerIP.text != "";
  }

  bool isIpARealIp() {
    return controllerIP.text != "" &&
        controllerIP.text.length >= 7 &&
        controllerIP.text.contains(".");
  }

  bool isUserNotNull() {
    return controllerUser.text != "";
  }

  void clearAllMessages() {
    print("All Mex Deleted!");
    setState(() {
      mexs = [];
    });
  }

  /*void backToLoginPage() {
    print("Undo");
    setState(() {
      server.Destroy();
      connected = false;
    });
  }*/

  void sendMessage() {
    if (controllermexs.text != null &&
        controllermexs.text != "") //controlla se mexs è vuoto
      server.send("2" +
          utente.nome +
          "%/" +
          utente.cognome +
          "%/" +
          DateTime.now().toString() +
          "%/" +
          controllermexs.text);
    controllermexs.text = "";
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (!connected) {
      return Scaffold(
        body: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/homescreen.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            height: 500,
            width: 250,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(35))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Chatroom",
                  style: TextStyle(
                    fontSize: 35,
                    color: Colors.black,
                  ),
                ),
                Spacer(),
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
                        visible: isIpNotNull(),
                        child: IconButton(
                          color: Colors.black,
                          onPressed: () =>
                              {controllerIP.clear(), setState(() {})},
                          icon: Icon(Icons.clear),
                        ),
                      ),
                      prefixIcon: Visibility(
                        visible: isIpARealIp(),
                        child: IconButton(
                          color: Colors.green,  
                          icon: Icon(Icons.verified),
                        ),
                      ),
                    ),
                  ),
                ),
                Column( //spacer
                  children: <Widget>[
                    SizedBox(height: 20),
                  ],
                ),
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
                        visible: isUserNotNull(),
                        child: IconButton(
                          color: Colors.black,
                          onPressed: () =>
                              {controllerUser.clear(), setState(() {})},
                          icon: Icon(Icons.clear),
                        ),
                      ),
                      prefixIcon: Visibility(
                        visible: isUserNotNull(),
                        child: IconButton(
                          color: Colors.green,
                          icon: Icon(Icons.verified),
                        ),
                      ),
                      
                    ),
                  ),
                ),
                
                Spacer(flex: 2),
                //Visibility(
                  //visible: isIpARealIp(),
                  Container(
                    // height: 50,
                    // width: 250,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.teal[100].withOpacity(0.8),
                        borderRadius: BorderRadius.all(Radius.circular(35))),
                    child: FlatButton(
                      minWidth: 250,
                      onPressed: () {
                        // setState(() {});
                        utente = new User(
                            controllerUser.text, " "); //crea nuovo user
                        ip = controllerIP.text; //prende ip e assegna a var
                        server.connect(
                            utente, receive, ip); //connette al server
                        // print("Ip:" + controllerIP.text);
                        // print(controllerIP.text == "192");
                        // setState(() {});
                      },
                      child: Text("Click to Connect!"),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    } else {
      return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              color: Colors.black,
              onPressed: () => {
                // SETTINGS,
                //backToLoginPage()
              },
              icon: Icon(Icons.account_circle),
            ),
            title: Text(controllerUser.text),
            // + " | Messages: " + mexs.length.toString()
            actions: [
              IconButton(
                color: Colors.black,
                onPressed: () => {
                  // SETTINGS,
                  clearAllMessages()
                },
                icon: Icon(Icons.delete),
              ),
              /*Text(
                  style: TextStyle(
                  fontSize: 40,
                  color: Colors.grey[300],
                ),
              ),*/

              // + " | Messages: " + mexs.length.toString()
              /*IconButton(
                color: Colors.black,
                onPressed: () => {
                  //openSettings()
                  // SETTINGS,
                  //print("Settings button clicked"),
                  //setState(() {})
                },
                icon: Icon(Icons.open_in_new),
              ),*/
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
                                  CreateMessaggio(index),
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
                                  CreateMessaggio(index),
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
                                  // cursorColor: Colors.white,
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
              )));
    }
  }

  //crea messaggio
  Widget CreateMessaggio(int pos) {
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
              '${mexs[mexs.length - pos - 1].time}',
              style: TextStyle(color: Colors.white60, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}

//classe di un messaggio contiene data ora e se madnato o ricevuto

//
