import 'package:flutter/material.dart';

class Alerts {
  showAlertDialog(BuildContext context) { //finestra di conferma quando clicchi cestino
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Annulla"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text("Continua"),
      onPressed: () {
        Navigator.pop(context);
        Navigator.pop(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Cancella memo"),
      content: Text("Vuoi davvero cancellare questo memo?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
