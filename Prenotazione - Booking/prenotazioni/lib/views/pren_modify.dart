import 'package:flutter/material.dart';

class PrenModify extends StatelessWidget {

  final String prenID;
  bool get isEditing => prenID != null;

  PrenModify({this.prenID});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Modifica Prenotazione' : 'Richiedi Prenotazione')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
        children: <Widget>[
          TextField(
            decoration: InputDecoration(
              hintText: 'Classe'
            )
          ),
          Container(height: 8),
          TextField(
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