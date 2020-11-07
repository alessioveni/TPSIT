import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cronometro',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.red,

        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Cronometro'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool widgetVisible = true;
  int _counter = 0;
  int _counterMin = 0;
  int _counterOre = 0;
  int minuti = 0, ore = 0, secondi = 0;
  bool started = false;
  bool streamStarted = false;
  Stream<int> stream;

  void contatore() {
    started = true;
    if (streamStarted == false) {
      stream = timedCounter(Duration(seconds: 1));
      streamStarted = true;
    }
    stream.listen((data) => _incrementCounter());
  }

  void stop() {
    started = false;
  }

  void reset() {
    _counter = 0;
    _counterMin = 0;
    _counterOre = 0;
    secondi = 0;
    minuti = 0;
    ore = 0;
    started = false;
  }

  void giro() {
    secondi = _counter;
    minuti = _counterMin;
    ore = _counterOre;
  }

  Stream<int> timedCounter(Duration interval, [int maxCount]) async* {
    int i = 0;
    while (true) {
      await Future.delayed(interval);
      yield i++;
      if (i == maxCount) break;
    }
  }

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      if (started) {
        _counter++;
        if (_counter >= 60) {
          _counter = 0;
          _counterMin++;
        }
        if (_counterMin >= 60) {
          _counterMin = 0;
          _counterOre++;
        }
        if (_counterOre >= 24) {
          _counterOre = 0;
          _counterMin = 0;
          _counter = 0;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,

          children: <Widget>[
            Text(
              'Tempo trascorso:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(_counterOre < 10 ? '0$_counterOre:' : '$_counterOre:',
                    style: Theme.of(context).textTheme.headline4),
                Text(_counterMin < 10 ? '0$_counterMin:' : '$_counterMin:',
                    style: Theme.of(context).textTheme.headline4),
                Text(_counter < 10 ? '0$_counter' : '$_counter',
                    style: Theme.of(context).textTheme.headline4),
              ],
            ),
            Column(
                  children: <Widget>[
                    SizedBox(height: 10),
                  ],
                ),
            Column(
              children: <Widget>[
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
                FlatButton(
                  color: Colors.red[300],
                  textColor: Colors.white,
                  disabledColor: Colors.grey,
                  disabledTextColor: Colors.black,
                  padding: EdgeInsets.all(8.0),
                  splashColor: Colors.blueAccent,
                  onPressed: stop,
                  child: Text(
                    "Stop",
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
                FlatButton(
                  color: Colors.grey[400],
                  textColor: Colors.white,
                  disabledColor: Colors.grey,
                  disabledTextColor: Colors.black,
                  padding: EdgeInsets.all(8.0),
                  splashColor: Colors.blueAccent,
                  onPressed: reset,
                  child: Text(
                    "Reset",
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
                FlatButton(
                  color: Colors.indigoAccent,
                  textColor: Colors.white,
                  disabledColor: Colors.grey,
                  disabledTextColor: Colors.black,
                  padding: EdgeInsets.all(8.0),
                  splashColor: Colors.blueAccent,
                  onPressed: giro,
                  child: Text(
                    "Giro",
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
                Column(
                  children: <Widget>[
                    SizedBox(height: 70),
                  ],
                ),
                Text(
                  'Ultimo Giro:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(ore < 10 ? '0$ore:' : '$ore:',
                        style: Theme.of(context).textTheme.headline4),
                    Text(minuti < 10 ? '0$minuti:' : '$minuti:',
                        style: Theme.of(context).textTheme.headline4),
                    Text(secondi < 10 ? '0$secondi' : '$secondi',
                        style: Theme.of(context).textTheme.headline4),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
