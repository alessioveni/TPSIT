import 'package:app_memo/database/database.dart';
import 'package:app_memo/Api.dart';
import 'package:flutter/material.dart';
import 'package:app_memo/dao/dao_floor.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'entità/memo.dart';
import 'newMemo.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database =
      await $FloorAppDatabase.databaseBuilder('app_memo_db.1').build();
  final dao = database.memoDAO;
  runApp(MyApp(dao: dao));
}
//
class MyApp extends StatelessWidget {
  MyApp({this.dao});
  final MemoDAO dao;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Memo',
      //theme: buildDarkTheme(),
      theme: FlexColorScheme.light(
        colors: FlexColor.schemes[FlexScheme.mandyRed].light,
      ).toTheme,
      // The Mandy red dark theme.
      darkTheme: FlexColorScheme.dark(
        colors: FlexColor.schemes[FlexScheme.mandyRed].dark,
      ).toTheme,
      themeMode: ThemeMode.system,
      home: MyHomePage(title: 'App Memo', dao: dao),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.dao}) : super(key: key);
  final MemoDAO dao;
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Api api = new Api();
  void _deleteAllMemo() async {
    await widget.dao.deleteAllMemo();
  }

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

  Widget editMemo(int memoId) {
    print(memoId);
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Center(
          child: Text('prova'),
        ),
      ),
    );
  }

  Future<void> _newMemo(Memo memo) async {
    await widget.dao.newMemo(memo);
  }

  void sincronize() async {
    _deleteAllMemo();
    List<Memo> memos = await fetchDataList();
    print(memos.length);
    if (memos.length <= 0) {
      await _deleteAllMemo();
    } else
      for (int i = 0; i < memos.length; i++) {
        await _newMemo(memos[i]);
      }
  }

  List<String> shortTitle(String longTitle) {
    longTitle = longTitle.replaceAllMapped(
        RegExp(r".{20}"), (match) => "${match.group(0)}\n");
    if (longTitle.length > 20) {
      return [longTitle.substring(0, 20) + "...", longTitle];
    } else {
      return [longTitle, longTitle];
    }
  }

  String getShortTag(String longTag) {
    String pre = "";
    if (longTag.length > 0) pre = "  -  ";
    if (longTag.length >= 15) {
      return pre + longTag.substring(0, 15);
    } else
      return pre + longTag;
  }

  Stream<List<Memo>> a;
  @override
  void initState() {
    super.initState();
    tags = [];
  }

  void lookForMemos() async {
    a = await widget.dao.getAllMemo();
  }

  static List<String> tags = [];

  bool aas = true;
  int lenghtMemo = 1;
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

class EditMemo {
  final String title;
  final String message;
  EditMemo(this.title, this.message);
}

class ExtractArgumentsScreen extends StatelessWidget {
  static const routeName = '/extractArguments';

  @override
  Widget build(BuildContext context) {
    final EditMemo args = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(args.title),
      ),
      body: Center(
        child: Text(args.message),
      ),
    );
  }
}
