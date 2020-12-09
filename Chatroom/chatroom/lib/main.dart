import 'package:chatroom/client/ServerSocket.dart';
import 'package:flutter/material.dart';

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
  String userName = "";
  ServerSocket server;
  List<Message> mexs;
  TextEditingController controllermexs;
  TextEditingController controllerUser;
  TextEditingController controllerIP;
  User utente;
  String ip;
  bool connected;

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

  void receive(data) {
    

    print("Received!");
    String istruzioni =
        new String.fromCharCodes(data).trim(); 
    int istruzioniCode = int.parse(istruzioni[0]); 
    String istruzioniData = istruzioni.substring(1); 
    connected = true;
    switch (istruzioniCode) {
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

  void setName(data) {
    setState(() {
      userName = data;
    });
  }

  void onerror(data) {
    setState(() {
      userName = data;
    });
  }

  void cls() {
    print("All Mex Deleted!");
    setState(() {
      mexs = [];
    });
  }

  bool controlIpNull() {
    return controllerIP.text != "";
  }

  bool controlIpReal() {
    return controllerIP.text != "" && controllerIP.text.length >= 7 && controllerIP.text.contains(".");
  }

  bool controlUserNull() {
    return controllerUser.text !=  "";
  }

  void sendMessage() {
    if (controllermexs.text != null &&
        controllermexs.text != "") 
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
                Column(
                  //spacer
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
                Spacer(flex: 2),
                Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.teal[100].withOpacity(0.8),
                      borderRadius: BorderRadius.all(Radius.circular(35))),
                  child: FlatButton(
                    minWidth: 250,
                    onPressed: () {
                      utente =
                          new User(controllerUser.text, " "); 
                      ip = controllerIP.text; 
                      server.connect(utente, receive, ip); 
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
              )));
    }
  }

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