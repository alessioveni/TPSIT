import 'package:flutter/material.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'LoginDemo.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Prenotazione',
      theme: FlexColorScheme.light(
        colors: FlexColor.schemes[FlexScheme.mandyRed].light,
      ).toTheme,
      // The Mandy red dark theme.
      darkTheme: FlexColorScheme.dark(
        colors: FlexColor.schemes[FlexScheme.mandyRed].dark,
      ).toTheme,
      themeMode: ThemeMode.dark,
      home: MyHomePage(title: 'Prenotazione Aule'),
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
  void _try() {
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue, // background
                      onPrimary: Colors.white, // foreground
                      shape: const BeveledRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AreaDocenti()));
                    },
                    icon: Icon(Icons.add, size: 18),
                    label: Text("AREA DOCENTI"),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red, // background
                      onPrimary: Colors.white, // foreground
                      shape: const BeveledRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AreaAdmin()));
                    },
                    icon: Icon(Icons.add, size: 18),
                    label: Text("AREA ADMIN"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AreaDocenti extends StatefulWidget {
  @override
  _AreaDocentiState createState() => _AreaDocentiState();
}
class _AreaDocentiState extends State<AreaDocenti> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Area Docenti'),
          backgroundColor: Colors.blueAccent),
      body: Center(
      ),
    );
  }
}

class AreaAdmin extends StatefulWidget {
  @override
  _AreaAdminState createState() => _AreaAdminState();
}
class _AreaAdminState extends State<AreaAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Area Admin'),
          backgroundColor: Colors.redAccent),
      body: Center(
       // ignore: deprecated_member_use
       child: FlatButton(
        color: Colors.red,
        textColor: Colors.white,
        padding: EdgeInsets.all(8.0),
        splashColor: Colors.red,
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>LoginDemo()));
        },
        child: Text(
       "Login",
       style: TextStyle(fontSize: 20.0),
     ),
    )
      ),
    );
  }
}

