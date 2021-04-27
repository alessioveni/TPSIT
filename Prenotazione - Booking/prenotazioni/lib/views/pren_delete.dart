import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PrenDelete extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Attenzione'),
      content: Text('Sei sicuro di voler cancellare la prenotazione?'),
      actions: <Widget>[
        FlatButton(
          child: Text('Si'),
          onPressed: (){
            Navigator.of(context).pop(true);
          }, 
        ),
        FlatButton(
          child: Text('No'),
          onPressed: (){
            Navigator.of(context).pop(false);
          }, 
        ),
      ],
    );
  }
}