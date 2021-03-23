# TPSIT App Memo

Applicazione App Memo.

## Descrizione

TPSIT App Memo è un'applicazione utilizzabile come promemoria con dei memo.
Viene gestita tramite l'utilizzo di google per loggare.

Ho implementato alcune features tra cui:
- Refresh dei messaggi instantaneo tramite un bottone nella homepage;
- Bottoni di log-in e log-out google nella homepage;
- Temi dinamici in versione light e dark in base alle impostazioni del cellulare;
- Bottone cestino per cancellare tutti i memo;
- Bottone cestino per eliminare il memo corrente;
- Possibilità di modifica del memo;

## Utilizzo

NB. Necessità di un account google per poter funzionare!!
In questa applicazione per il corretto funzionamento dei Memo ho deciso di utilizzare alcune classi divise per sezioni:

- DAO
```dart
Dao_floor.dart
```

- DATABASE
```dart
Database.dart
Database.g.dart (generato automaticamente)
```

- ENTITA'
```dart
Memo.dart
```

- MAIN FILES
```dart
Main.dart
JsonApi.dart
NewMemo.dart
Generated_plugin_registrant.dart (generato automaticamente)
```


### Dar_floor


- Definisce tutti i metodi applicabili all'entità memo
```dart
  @insert
  Future<void> newMemo(Memo memo);

  @delete
  Future<void> deleteMemo(Memo memo);
  
  @Query('SELECT * from Memo')
  Stream<List<Memo>> getAllMemo();

  @update
  Future<void> updateMemo(Memo memo);

  @Query('SELECT * from Memo WHERE id=:id')
  Stream<Memo> getMemoById(int id);

  @Query('DELETE FROM Memo')
  Future<void> deleteAllMemo();
```


### Database


- File dal quale si creerà il database
```dart
@Database(version: 1, entities: [Memo]) 
abstract class AppDatabase extends FloorDatabase {
  Dao_floor get dao_floor;
}
```


### Memo


- Metodo fetchDataList() prendendo spunto dall'app Maree
```dart
Future<List<Memo>> fetchDataList() async { 
  final response = await http.get('https://2524fb95ed5e.ngrok.io');
  if (response.statusCode == 200) {
    final parsed = json.decode(response.body);
    print('body parsed ${parsed}');
    print(parsed.toString());
    return parsed.map<Memo>((json) => Memo.fromJson(json)).toList();
  } else {
    throw Exception('Errore inserimento dati!');
  }
}
```

- Entità Memo JSON generata automaticamente da un sito 
```dart
@entity
class Memo {  
  @PrimaryKey(autoGenerate: true)
  final int id;
  String title;
  String body;
  String tag;
  String status;
  Memo({this.id, this.title, this.body, this.tag, this.status});

  factory Memo.fromJson(Map<String, dynamic> json) {
    return Memo(
      id: json['id'] as int,
      title: json['title'] as String,
      body: json['body'] as String,
      tag: json['tag'] as String,
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['body'] = this.body;
    data['tag'] = this.tag;
    data['status'] = this.status;
    return data;
  }
}
```


### JsonApi


- Metodo che esegue l'upload dei memo al database
```dart
  uploadMemoOnline(String title, String memoBody, String tag) async {
    String params = '?title=' + title + '&body=' + memoBody + '&tag=' + tag;
    url = url + '/api/memo/new' + params;
    Response response = await post(url, headers: headers); 
    int statusCode = response.statusCode;
    print('statusCode--> ' + statusCode.toString());
    String body = response.body;
    print('body--> ' + body);
  }
```

- Metodo che esegue la rimozione dei memo dal database
```dart
  deleteMemo(param) async { 
    String params = '?delete=' + param;
    url = url + '/api/memo/delete' + params;

    Response response = await post(url, headers: headers); 
    int statusCode = response.statusCode;
    print('statusCode--> ' + statusCode.toString());
    String body = response.body;
    print('body--> ' + body);
  }
```


### Main


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

- Metodi che garantiscono il corretto funzionamento del servizio di login e logout di Google
```dart
bool _isLoggedIn = false;

  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  login() async {
    try {
      await _googleSignIn.signIn();
      setState(() {
        _isLoggedIn = true;
      });
    } catch (err) {
      print(err);
    }
  }

  logout() {
    _googleSignIn.signOut();
    setState(() {
      _isLoggedIn = false;
    });
  }
```

- Parte grafica della Homepage dell'applicazione
```dart
 @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: 
        Text(widget.title),
        actions: [
          
          IconButton(
              icon: Icon(Icons.login),
              onPressed: () {
                login();
              }),
          IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                logout();
              }),
          IconButton(
              icon: Icon(Icons.delete_sweep),
              onPressed: () {
                api.deleteMemo('all');
                _deleteAllMemo();
                setState(() {});
              }),
          IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                sincronize();
              }),
        ],
      ),
      body: StreamBuilder(
        stream: widget.dao.getAllMemo(),
        builder: (context, snapshot) {
          if (snapshot.hasError)
            return Center(
              child: Text('${snapshot.error}'),
            );
          else if (snapshot.hasData) {
            var listMemo = snapshot.data as List<Memo>;
            return ListView(
                children: List.generate(listMemo.length, (index) {
              tags.add('${listMemo[index].tag}');
              return Container(
                  margin: EdgeInsets.all(15.20),
                  padding: const EdgeInsets.all(10.0),
                  decoration: new BoxDecoration(
                    border: Border.all(color: FlexColor.mandyRedDarkPrimary, width: 4.0),
                  ),
                  child: ListTile(
                    onTap: () {
                      print("Tap (${listMemo[index].title}");
                      Navigator.of(context).push(
                          MaterialPageRoute(
                        builder: (context) => NewMemo(
                            title: 'Modifica',
                            dao: widget.dao,
                            memoTag: '${listMemo[index].tag}',
                            memoBody: '${listMemo[index].body}',
                            memoTitle: '${listMemo[index].title}',
                            tags: tags),
                      ));
                    },
                    title: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Column(children: <Widget>[
                        Row(
                          children: [
                            Text(
                              '${shortTitle(listMemo[index].title)[0]}',
                              
                              style: Theme.of(context).textTheme.headline5,
                            ),
                            Visibility(
                              child: Text(
                                '${getShortTag(listMemo[index].tag)}',
                                
                                style: TextStyle(
                                    color: FlexColor.mandyRedDarkPrimary,
                                    fontSize: 20,
                                    fontStyle: FontStyle.italic),
                              ),
                              visible: aas,
                            )
                          ],
                        ),
                        Text(
                          '${shortTitle(listMemo[index].body)[0]}',
                          style: Theme.of(context).textTheme.bodyText1,
                          
                        ),
                      ]),
                    ),
                  ));
            }));
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => NewMemo(
                title: 'Crea',
                dao: widget.dao,
                memoTag: '',
                memoBody: '',
                memoTitle: '',
                tags: tags),
          ));
        },
        tooltip: 'New',
        child: Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
    );
  }
}
```


### New Memo


- Classe costruttore per la creazione di un nuovo memo 
```dart
class New_Memo extends StatefulWidget {
  NewMemo(
      {Key key,
      this.title,
      this.dao,
      this.memoTag,
      this.memoBody,
      this.memoTitle,
      this.tags})
      : super(key: key);
  final String title;
  final String memoTag, memoBody, memoTitle;
  final List<String> tags;

  @override
  _newMemoState createState() =>
      _newMemoState(title, dao, memoTag, memoBody, memoTitle, tags);
}
```


- Parte grafica della creazione dell'entità memo dell'applicazione
```dart
Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        
      ),
      body: Padding(
          padding: EdgeInsets.all(2.0),
          child: Center(
              child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: TextFormField(
                  inputFormatters: [
                    new LengthLimitingTextInputFormatter(30),
                  ],
                  style: TextStyle(color: FlexColor.jungleLightSecondary),
                  onChanged: (text) {
                  },
                  autofocus: true,
                  obscureText: false,
                  controller: titleController,
                  decoration: InputDecoration(
                    border: new OutlineInputBorder(
                          borderSide: new BorderSide(color: FlexColor.jungleLightSecondary)),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: FlexColor.jungleLightSecondary, width: 3.0),
                    ),
                    labelStyle: TextStyle(color: FlexColor.jungleLightSecondary),
                    filled: true,
                    labelText: 'Nome Memo',
                  ),
                ),
              ),
              Padding(
                  padding: EdgeInsets.all(16.0),
                  child: TextFormField(
                    controller: bodyController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    onChanged: (text) {
                      memoBody = text;
                      print(memoBody.toString());
                    },
                    obscureText: false,
                    decoration: InputDecoration(
                      border: new OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.blue)),

                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: FlexColor.jungleLightSecondary, width: 3.0),
                      ),
                      labelStyle: TextStyle(color: FlexColor.jungleLightSecondary),
                      filled: true,
                      labelText: 'Testo',
                    ),
                    style: TextStyle(color: FlexColor.jungleLightSecondary),
                  )),
              new ListTile(
                title: textField,
                onTap: () {
                },
              ),
            ],
          ) 
              ) 
          ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
          _newMemo(
              titleController.text, bodyController.text, tagController.text);
        },
        tooltip: 'Save',
        child: Icon(Icons.add_to_photos_rounded),
      ),
    );
  }
```


### Servizio Server


- Costruttore per creare un client
```dart
  const client = new Client({
    user: 'postgres',
    host: 'localhost',
    database: 'app_memo',
    password: 'admin',
    port: 5432,
});
```

- Metodo che ritorna tutti i memo presenti
```dart
function getAllMemos() {
    const query = `SELECT * FROM memo`;
    client.query(query)
        .then(res => {
            memos = res.rows;
            console.log(res.rows);
            return res.rows;
        })
        .catch(err => {
            console.error(err)
        })
}
```

- Metodo che inserisce un memo dando in input i dati necessari
```dart
function addMemo(title, body, tag) {
    const query = `insert into memo (title, body, tag) VALUES ('${title}','${body}','${tag}');`;
    client.query(query)
        .then(res => {
            memos = res.rows;
            console.log(res.rows);
            return res.rows;
        })
        .catch(err => {
            console.error(err)
        })
}
```


## Eseguibilità e Test

Per eseguire questa applicazione necessitiamo di:
- 1 emulatore Android e/o Telefoni con sistema operativo nativo Android;
- 2 cmd;
- dart installato nel S.O.
- node installato nel S.O.
- express installato nel S.O.
- ngrok installato nel S.O.
- posteSQL installato nel S.O.


1)
Iniziamo con l'aprire il primo cmd dove introduceremo il primo comando utile:
```dart
psql -h localhost -U postgres
```
continueremo inserendo la password e con il seguente comando:
```dart
\c app_memo;
```
da questo momento possiamo inserire le Query per poter avere delle risposte 'Memo' dal server.
```dart
ESEMPIO: SELECT * FROM memo;
```

2)
Successivamente apriamo il secondo cmd dove eseguiremo il server Node.
Prima cosa da fare: 
entrare nella cartella 'servizioServer' ed eseguire questo comando:
```dart
node index.js
```

4)
Dopo di chè ci resta solo l'esecuzione di ngrok.exe che avrà l'aspetto di un prompt dei comandi classico,
```dart
ngrok http 2002
```

5)
Ora possiamo proseguire copiando il link che verrà generato (simile a questo: 'https://2524fb95ed5e.ngrok.io')
Questo link dovremmo inserirlo nelle apposite variabili allocate in JsonApi.dart & entità/memo.dart

6)
Ora, finalmente connessi, si può iniziare ad utilizzare l'applicazione senza problemi!

## Roadmap

Idee per versioni future:

- Aggiungere decorazioni e animazioni
- Aggiungere funzione aggiunta immagini nel memo
- Aggiungere funzione draw nel memo

## Stato del progetto

```bash
v1.0 Finished
```

## Author

Veni Alessio - 5IA - ITIS C. Zuccante