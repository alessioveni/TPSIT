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
  this.classe,
  this.aula,
  this.prenotato,
  this.createDateTime,
  this.latestEditDateTime,});

  factory PrenForLinsting.fromJson(Map<String, dynamic> item){
          return PrenForLinsting(
            id: item['id'],
            classe: item['classe'],
            aula: item['aula'],
            prenotato: item['prenotato'],
            createDateTime: DateTime.parse(item['createDateTime']),
            latestEditDateTime: item['latestEditDateTime'] != null ? DateTime.parse(item['latestEditDateTime']) : null,
          );
  }
}