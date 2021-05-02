import 'package:flutter/foundation.dart';

class PrenInsert {
  String aula;
  String classe;
  bool prenotato = false;

  PrenInsert({

    @required this.aula,
    @required this.classe,
    this.prenotato = false
  });

  Map<String,dynamic> toJson() {
    return{
      "aula": aula,
      "classe": classe,
      "prenotato": prenotato
    };
  }
}