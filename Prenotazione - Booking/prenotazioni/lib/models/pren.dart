class Pren {
  String id;
  String aula;
  String classe;
  bool prenotato;
  String prenContent;
  DateTime createDateTime;
  DateTime latestEditDateTime;

  Pren(
  {
  this.id,
  this.aula,
  this.classe,
  this.prenotato,
  this.prenContent,
  this.createDateTime,
  this.latestEditDateTime,});

  factory Pren.fromJson(Map<String, dynamic> item){
          return Pren(
            id: item['id'],
            aula: item['aula'],
            classe: item['classe'],
            prenotato: item['prenotato'],
            prenContent: item['prenContent'],
            createDateTime: DateTime.parse(item['createDateTime']),
            latestEditDateTime: item['latestEditDateTime'] != null ? DateTime.parse(item['latestEditDateTime']) : null,
          );
  }
}
