import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:prenotazioni/models/pren.dart';
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

  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
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
      _titleController.text = pren.classe;
      _contentController.text = pren.aula;
    });
    
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
            controller: _titleController,
            decoration: InputDecoration(
              hintText: 'Classe'
            )
          ),
          Container(height: 8),
          TextField(
            controller: _contentController,
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
            onPressed: () {
              if(isEditing) {
                //fai upload del promemoria in api
              } else{
                //crea promemoria in api
              }
              Navigator.of(context).pop();
            },
            ),
          ),  
        ],
      ),)
    );
  }
}