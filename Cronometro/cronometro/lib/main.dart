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
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Cronometro'),
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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
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
