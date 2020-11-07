# TPSIT Cronometro

Applicazione cronometro.

## Descrizione

TPSIT Cronometro è un'applicazione utilizzabile come cronometro, con funzione di Start,Stop,Reset e Giro.
Il formato visualizzabile è in ore:minuti:secondi.

## Utilizzo

In questa applicazione per il corretto funzionamento del cronometro ho deciso di utilizzare Stream con l'ausilio di 3 funzioni:

Dichiarazione Stream
```dart
Stream<int> stream;
```

Funzione timedCounter (funzione chiamata dalla funzione contatore per incrementare il contatore di un 1 secondo al secondo)
```dart
Stream<int> timedCounter(Duration interval, [int maxCount]) async* {
    int i = 0;
    while (true) {
      await Future.delayed(interval);
      yield i++;
      if (i == maxCount) break;
    }
}
```

Funzione contatore (funzione che chiama la funzione timedCounter per l'incrementazione)
```dart
void contatore() {
    started = true;
    if (streamStarted == false) {
      stream = timedCounter(Duration(seconds: 1));
      streamStarted = true;
    }
    stream.listen((data) => _incrementCounter());
}
```

Funzione incrementCounter (utilizzato per l'incremento del contatore del cronometro)
```dart
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
void contatore() {
    started = true;
    if (streamStarted == false) {
      stream = timedCounter(Duration(seconds: 1));
      streamStarted = true;
    }
    stream.listen((data) => _incrementCounter());
}
```

## Roadmap

## Stato del progetto


```bash
pip install foobar
```

## Usage

```python
import foobar

foobar.pluralize('word') # returns 'words'
foobar.pluralize('goose') # returns 'geese'
foobar.singularize('phenomena') # returns 'phenomenon'
```

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.