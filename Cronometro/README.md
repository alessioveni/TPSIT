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

Funzione timedCounter (funzione chiamata dalla funzione contatore per incrementare il contatore di un 1 secondo)
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

Funzione incrementCounter (utilizzata per l'incremento del contatore del cronometro)
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