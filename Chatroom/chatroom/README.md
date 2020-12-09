# TPSIT Cronometro

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