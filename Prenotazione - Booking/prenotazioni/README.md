# TPSIT Prenotazioni

Applicazione Prenotazioni.

## Descrizione

TPSIT Prenotazioni è un'applicazione utilizzabile per poter usufruire di un ordine tramite richieste di prenotazione aule in un ambito scolastico.

Ho implementato alcune features tra cui:
- Refresh/Fetch delle prenotazioni non appena create;
- Bottone di aggiunta prenotazione sia in sezione Docente che Amministratore;
- Temi dinamici in versione light e dark in base alle impostazioni del cellulare;
- Design minimale ma efficace;
- Possibilità di cambiare la prenotazione;
- Possibilità di visualizzare sempre tutte le prenotazioni attive;
- Possibilità di eliminare una prenotazione tramite un comodo swipe verso destra;

## Utilizzo

In questa applicazione per il corretto funzionamento delle prenotazioni ho deciso di utilizzare alcune classi divise per sezioni:

- MODELS
```dart
Api_response.dart
Pren_for_listing.dart
Pren_insert.dart
Pren.dart
```

- SERVICES
```dart
Pren_service.dart
```

- VIEWS
```dart
Pren_delete.dart
Pren_list.dart
Pren_modify.dart
```

- MAIN FILES
```dart
Main.dart
```


### MODELS


- Definisce tutti i modelli json/object per il corretto funzionamento dell'App Prenotazioni


### SERVICES


- File dove si trovano le funzioni essenziali per il corretto funzionamento di dialogo fra App e Server Json

- Ritorna l'intera lista di prenotazioni
```dart
Future<APIResponse<List<PrenForLinsting>>> getPrensList() {
    return http.get(Uri.parse(url), headers: headers).then((data) {
      if(data.statusCode == 200) {
        final jsonData = json.decode(data.body);
        final prens = <PrenForLinsting>[];
        for (var item in jsonData) {
          prens.add(PrenForLinsting.fromJson(item));
        }
        return APIResponse<List<PrenForLinsting>>(data: prens);
      }
      return APIResponse<List<PrenForLinsting>>(error: true, errorMessage: 'errore');
    })
    .catchError((_) => APIResponse<List<PrenForLinsting>>(error: true, errorMessage: 'errore'));
  }
}
```

- Ritorna una singola prenotazione
```dart
Future<APIResponse<Pren>> getPren(String id) {
    return http.get(Uri.parse(('https://api.npoint.io/9bf35b0c70b938819ee3/prens/' + id))).then((data) {
      if(data.statusCode == 200) {
        final jsonData = json.decode(data.body);
        return APIResponse<Pren>(data: Pren.fromJson(jsonData));
      }
      return APIResponse<Pren>(error: true, errorMessage: 'errore');
    })
    .catchError((_) => APIResponse<Pren>(error: true, errorMessage: 'errore'));
  }
```

- Crea una singola prenotazione
```dart
Future<APIResponse<bool>> createPren(PrenInsert item) {
    return http.post(Uri.parse(('https://api.npoint.io/9bf35b0c70b938819ee3/prens/')), headers: headers, body: json.encode(item.toJson())).then((data) {
      if(data.statusCode == 201) {
        return APIResponse<bool>(data: true);
      }
      return APIResponse<bool>(error: true, errorMessage: 'errore');
    })
    .catchError((_) => APIResponse<bool>(error: true, errorMessage: 'errore'));
  }
}
```


### VIEWS


- Pren_delete.dart - Interfaccia Alert visualizzata quando vogliamo cancellare una prenotazione
```dart
return AlertDialog(
      title: Text('Attenzione'),
      content: Text('Sei sicuro di voler cancellare la prenotazione?'),
      actions: <Widget>[
        // ignore: deprecated_member_use
        FlatButton(
          child: Text('Si'),
          onPressed: (){
            Navigator.of(context).pop(true);
          }, 
        ),
        // ignore: deprecated_member_use
        FlatButton(
          child: Text('No'),
          onPressed: (){
            Navigator.of(context).pop(false);
          }, 
        ),
      ],
    );
```

- Pren_list.dart - Scaffold dove visualizziamo tutte le prenotazioni

```dart
@override
  void initState() {
    _fetchPrens();
    super.initState();
  }

  _fetchPrens() async {
    setState(() {
      _isLoading = true;
    });

    _apiResponse = await service.getPrensList();

    setState(() {
      _isLoading = false;
    });
  }
  ```

```dart
return Scaffold(
        appBar: AppBar(title: Text('Lista Prenotazioni')),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => PrenModify())).then((_) {
              _fetchPrens();
            });
          },
          child: Icon(Icons.add),
        ),
        body: Builder(
          builder: (_) {
            if (_isLoading) {
              return Center(child: CircularProgressIndicator());
            }

            if (_apiResponse.error) {
              return Center(child: Text(_apiResponse.errorMessage));
            }


            return ListView.separated(
          separatorBuilder: (_, __) => Divider(height:1, color: Colors.green),
            itemBuilder: (_, index) {
              return Dismissible(
                key: ValueKey(_apiResponse.data[index].id),
                direction: DismissDirection.startToEnd,
                onDismissed: (direction){
                },
                confirmDismiss: (direction) async{
                  final ris = await showDialog(context: context, builder: (_) => PrenDelete()
                  );
                  print(ris);
                  return ris;
                },
                background: Container(
                  color: Colors.red,
                  padding: EdgeInsets.only(left: 16),
                  child: Align(child: Icon(Icons.delete, color: Colors.white), alignment: Alignment.centerLeft)
                ),
                child: ListTile(
                title: Text(
                  _apiResponse.data[index].classe,
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
                subtitle: Text("Modificato l'ultima volta li ${formatDateTime(_apiResponse.data[index].latestEditDateTime ?? _apiResponse.data[index].createDateTime )}"),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => PrenModify(id: _apiResponse.data[index].id)));
                }
              ),
              );
              
            },
            itemCount: _apiResponse.data.length,
        );
          }
        )
      );
```


- Pren_modify.dart - Scaffold dove c'è la possibilità di modificare tutte le prenotazioni

```dart
@override
  void initState() {
    super.initState();
    if(isEditing){
      setState(() {
      _isLoading = true;
    });
    prensService.getPren(widget.id).then((response) {
      setState(() {
      _isLoading = false;
    });

      if(response.error) {
        errorMessage = response.errorMessage ?? 'Errore';
      }
      pren = response.data;
      _classeController.text = pren.classe;
      _aulaController.text = pren.aula;
    });
    }
    
  }
  ```

```dart
return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Modifica Prenotazione' : 'Richiedi Prenotazione')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),

        child: _isLoading ? Center(child: CircularProgressIndicator()) : Column(
        children: <Widget>[
          TextField(
            controller: _classeController,
            decoration: InputDecoration(
              hintText: 'Classe'
            )
          ),
          Container(height: 8),
          TextField(
            controller: _aulaController,
            decoration: InputDecoration(
              hintText: 'Aula desiderata'
            )
          ),
          Container(height: 8),
          SizedBox(
            width: double.infinity,
            height: 35,
            // ignore: deprecated_member_use
            child: RaisedButton(
            child: Text('Submit', style: TextStyle(color: Colors.white),),
            color: Theme.of(context).primaryColor,
            onPressed: () async {
              if(isEditing) {
                //fai upload del promemoria in api
              } else{
                //crea promemoria in api
                setState(() {
                  _isLoading = true;
                });
                final pren = PrenInsert(classe: _classeController.text, aula: _aulaController.text);
                final result = await prensService.createPren(pren);

                setState(() {
                  _isLoading = false;
                });

                final title = 'Errore';
                final text = result.error ? (result.errorMessage ?? 'Errore!') : 'Prenotazione creata ';

                showDialog(context: context, 
                builder: (_) => AlertDialog(
                  title: Text(title),
                  content: Text(text),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Ok'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ]
                )).then((data) {
                  if(result.data) {
                    Navigator.of(context).pop();
                  }
                });
              }
              
            },
            ),
          ),  
        ],
      ),)
    );
```


### MAIN


- Main del progetto
```dart
void setupLocator() {
  GetIt.instance.registerLazySingleton(() => PrensService());
  //GetIt.instance<PrensService>();
}

void main() {
  setupLocator();
  runApp(MyApp());
}
```

- Tema dinamico Light & Dark, in base alle impostazioni tema del cellulare cambia tema nella applicazione(System)
```dart
Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Memo',
      theme: FlexColorScheme.light(
        colors: FlexColor.schemes[FlexScheme.mandyRed].light,
      ).toTheme,
      darkTheme: FlexColorScheme.dark(
        colors: FlexColor.schemes[FlexScheme.mandyRed].dark,
      ).toTheme,
      themeMode: ThemeMode.system,
      home: MyHomePage(title: 'App Memo', dao: dao),
    );
  }
```

- Area Docente
```dart
ElevatedButton.icon(
    style: ElevatedButton.styleFrom(
        primary: Colors.blue, // background
        onPrimary: Colors.white, // foreground
        shape: const BeveledRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10))),
    ),
    onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>PrenList()));
    },
    icon: Icon(Icons.add, size: 18),
    label: Text("AREA DOCENTI"),
),
```

- Area Admin
```dart
ElevatedButton.icon(
    style: ElevatedButton.styleFrom(
        primary: Colors.blue, // background
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
```

### Servizio Server Json


- Tipologia Json
```dart
"prens": [{
            "id": "0",
            "aula": "11",
            "classe": "5IA",
            "prenotato": false,
            "createDateTime": "2021-2-12T20:03:05.791472+00:00",
            "latestEditDateTime": null
        },
        {
            "id": "1",
            "aula": "7",
            "classe": "4AB",
            "prenotato": false,
            "createDateTime": "2021-3-3T20:03:05.791472+00:00",
            "latestEditDateTime": null
        },
        {
            "id": "2",
            "aula": "2",
            "classe": "5IC",
            "prenotato": false,
            "createDateTime": "2021-5-1T20:03:05.791472+00:00",
            "latestEditDateTime": null
        }
]

```


## Eseguibilità e Test

Per eseguire questa applicazione necessitiamo di:
- 1 emulatore Android e/o Telefoni con sistema operativo nativo Android;
- 1 cmd se in locale o nessun cmd se utilizziamo il sito online per hosting Json;
- dart installato nel S.O.
- server-json installato nel S.O.

Ora, finalmente connessi, si può iniziare ad utilizzare l'applicazione senza problemi!

## Roadmap

Idee per versioni future:

- Aggiungere decorazioni e animazioni

## Stato del progetto

```bash
v1.0 Finished
```

## Author

Veni Alessio - 5IA - ITIS C. Zuccante