import 'package:app_memo/Api.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:app_memo/dao/dao_floor.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/services.dart';
import 'entità/memo.dart';
import 'Alerts.dart';

class NewMemo extends StatefulWidget {
  NewMemo(
      {Key key,
      this.title,
      this.dao,
      this.memoTag,
      this.memoBody,
      this.memoTitle,
      this.tags})
      : super(key: key);
  final MemoDAO dao;
  final String title;
  final String memoTag, memoBody, memoTitle;
  final List<String> tags;

  @override
  _newMemoState createState() =>
      _newMemoState(title, dao, memoTag, memoBody, memoTitle, tags);
}

class _newMemoState extends State<NewMemo> {
  GlobalKey<AutoCompleteTextFieldState<String>> key = new GlobalKey();
  String currentText = "";
  TextEditingController tagController = new TextEditingController(text: " ");
  TextEditingController titleController = new TextEditingController();
  TextEditingController bodyController = new TextEditingController();
  String memoTag, memoBody, memoTitle = "";
  List<String> tags;
  List<String> clearTags(dirtyList) {
    return [];
  }

  _newMemoState(this.title, this.dao, this.memoTag, this.memoBody,
      this.memoTitle, this.tags) {
    textField = SimpleAutoCompleteTextField(
      style: TextStyle(color: FlexColor.jungleLightSecondary),
      key: key,
      suggestions: tags,
      textSubmitted: (text) => null,
      textChanged: (text) => currentText = text,
      clearOnSubmit: false,
      suggestionsAmount: 0,
      controller: tagController,
      decoration: InputDecoration(
        border: new OutlineInputBorder(
                          borderSide: new BorderSide(color: FlexColor.jungleLightSecondary)),
        labelStyle: TextStyle(color: FlexColor.jungleLightSecondary),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: FlexColor.jungleLightSecondary, width: 3.0),
          borderRadius: BorderRadius.horizontal()
        ),
        filled: true,
        labelText: 'Tag',
      ),
    );
    tagController.text = memoTag;
    bodyController.text = memoBody;
    titleController.text = memoTitle;
    print(tags);
  }

  static SimpleAutoCompleteTextField textField;

  static final c = new Alerts();
  final String title;
  final MemoDAO dao;

  static Color blue = Colors.blue;
  void _newMemo(String title, String body, String tag) async {
    Api a = new Api();
    a.uploadMemoOnline(title, body, tag);
    await widget.dao.newMemo(Memo(title: title, body: body, tag: tag));
    print("New memo still working.");
  }

  void deleteAllMemo() async {
    await widget.dao.deleteAllMemo();
    print("Tutti i memo sono stati cancellati correttamente!");
  }

  static const routeName = '/a';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
              icon: Icon(Icons.delete_sweep),
              onPressed: () {
                c.showAlertDialog(context);
              })
        ],
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
                      //borderRadius: BorderRadius.circular(25.0),
                    ),
                    labelStyle: TextStyle(color: FlexColor.jungleLightSecondary),
                    //enabledBorder: ,
                    //hintText: 'Titolo',
                    //hintStyle: TextStyle(color: Colors.blue),
                    filled: true,
                    labelText: 'Nome Memo',
                  ),
                ),
              ),
              Padding(
                  padding: EdgeInsets.all(16.0),
                  child: TextFormField(
                    controller: bodyController,
                    //showCursor: false,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    onChanged: (text) {
                      memoBody = text;
                      print(memoBody.toString());
                    },
                    obscureText: false,
                    //cursorColor: Colors.blue,
                    decoration: InputDecoration(
                      //enabledBorder: ,
                      //hintText: 'Titolo',
                      //hintStyle: TextStyle(color: Colors.red),
                      border: new OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.blue)),

                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: FlexColor.jungleLightSecondary, width: 3.0),
                        //borderRadius: BorderRadius.circular(25.0),
                      ),
                      labelStyle: TextStyle(color: FlexColor.jungleLightSecondary),
                      filled: true,
                      labelText: 'Testo',
                    ),
                    style: TextStyle(color: FlexColor.jungleLightSecondary),
                  )),
              new ListTile(
                title: textField,
                /*trailing: IconButton(
                  icon: Icon(
                    Icons.backspace,
                    color: FlexColor.barossaLightPrimary,
                  ),
                  onPressed: () {
                    tagController.text = "";
                  },
                  
                  
                ),*/
                
                onTap: () {
                  //print("Tap");
                },
              ),
            ],
          ) //col
              ) //center
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
}


