# TPSIT Cronometro

Applicazione cronometro.

## Descrizione

TPSIT Cronometro è un'applicazione utilizzabile come cronometro, con funzione di Start,Stop,Reset e Giro.
Il formato visualizzabile è in ore:minuti:secondi.

## Utilizzo

In questa applicazione ho optato per l'utilizzo di 4 semplici pulsanti "FlatButton":
>*Start*

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
void contatore() {
    started = true;
    if (streamStarted == false) {
      stream = timedCounter(Duration(seconds: 1));
      streamStarted = true;
    }
    stream.listen((data) => _incrementCounter());
}


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