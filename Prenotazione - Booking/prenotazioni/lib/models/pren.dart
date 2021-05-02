class Pren {
  String id;
  String classe;
  String aula;
  bool prenotato;
  String prenContent;
  DateTime createDateTime;
  DateTime latestEditDateTime;

  Pren(
  {
  this.id,
  this.classe,
  this.aula,
  this.prenotato,
  this.prenContent,
  this.createDateTime,
  this.latestEditDateTime,});

  factory Pren.fromJson(Map<String, dynamic> item){
          return Pren(
            id: item['id'],
            classe: item['classe'],
            aula: item['aula'],
            prenotato: item['prenotato'],
            prenContent: item['prenContent'],
            createDateTime: DateTime.parse(item['createDateTime']),
            latestEditDateTime: item['latestEditDateTime'] != null ? DateTime.parse(item['latestEditDateTime']) : null,
          );
  }
}
