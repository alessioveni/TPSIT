class PrenForLinsting {
  String id;
  String classe;
  String aula;
  bool prenotato;
  DateTime createDateTime;
  DateTime latestEditDateTime;

  PrenForLinsting(
  {
  this.id,
  this.aula,
  this.classe,
  this.prenotato,
  this.createDateTime,
  this.latestEditDateTime,});

  factory PrenForLinsting.fromJson(Map<String, dynamic> item){
          return PrenForLinsting(
            id: item['id'],
            aula: item['aula'],
            classe: item['classe'],
            prenotato: item['prenotato'],
            createDateTime: DateTime.parse(item['createDateTime']),
            latestEditDateTime: item['latestEditDateTime'] != null ? DateTime.parse(item['latestEditDateTime']) : null,
          );
  }
}