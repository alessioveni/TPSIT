import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:prenotazioni/models/pren.dart';
import 'package:prenotazioni/models/pren_insert.dart';
import 'package:prenotazioni/services/prens_service.dart';

class PrenModify extends StatefulWidget {

  final String id;
  PrenModify({this.id});

  @override
  _PrenModifyState createState() => _PrenModifyState();
}

class _PrenModifyState extends State<PrenModify> {
  bool get isEditing => widget.id != null;

  PrensService get prensService => GetIt.I<PrensService>();

  String errorMessage;
  Pren pren;

  TextEditingController _classeController = TextEditingController();
  TextEditingController _aulaController = TextEditingController();

  bool _isLoading = false;

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

  @override
  Widget build(BuildContext context) {
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
  }
}