import 'package:flutter/material.dart';
import 'package:prenotazioni/views/pren_list.dart';
import '../lib/main.dart';
import 'main.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginDemo(),
    );
  }
}

class LoginDemo extends StatefulWidget {
  @override
  _LoginDemoState createState() => _LoginDemoState();
  var password = "";
  var user = "";
}

TextEditingController _passController = TextEditingController();

class _LoginDemoState extends State<LoginDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[200],
      appBar: AppBar(
        title: Text("Pagina di login Admin"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Center(
                child: Container(
                    width: 200,
                    height: 150,
                    /*decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(50.0)),*/
                    child: Image.asset('asset/images/flutter-logo.png')),
              ),
            ),
            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'User',
                    hintText: 'Inserisci un UserName valido'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(

                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Inserisci una password valida'),
                    controller: _passController,
              ),
            ),
            SizedBox(height: 10),
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.orange[900], borderRadius: BorderRadius.circular(20)),
              child: FlatButton(
                onPressed: () {
                  var password = "";
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => (_passController.text == 'admin') ? PrenList() : AreaAdmin()));
                },
                child: Text(
                  'Login',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
            SizedBox(
              height: 130,
            ),
            Text('Problemi ad accedere?'),
            Text('Contatta la direzione')
          ],
        ),
      ),
    );
  }
}