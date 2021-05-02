import 'package:flutter/foundation.dart';

class PrenInsert {
  String classe;
  String aula;
  bool prenotato = false;

  PrenInsert({

    @required this.classe,
    @required this.aula,
    this.prenotato = false
  });

  Map<String,dynamic> toJson() {
    return{
      "classe": classe,
      "aula": aula,
      "prenotato": prenotato
    };
  }
}