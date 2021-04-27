import 'package:flutter/material.dart';
import 'package:prenotazioni/models/pren_for_listing.dart';
import 'package:prenotazioni/views/pren_delete.dart';
import 'package:prenotazioni/views/pren_modify.dart';

class PrenList extends StatelessWidget {

/* test per nomi prenotazioni
  String prenID;
  String classe;
  String aula;
  bool prenotato;
  DateTime createDateTime;
  DateTime lastEditTime;
*/



  final prens = [
    new PrenForLinsting(
      prenID: "1",
      classe: "5IA",
      aula: "11",
      prenotato: false,
      createDateTime: DateTime.now(),
      latestEditDateTime: DateTime.now(),
    ),

    new PrenForLinsting(
      prenID: "2",
      classe: "4IB",
      aula: "7",
      prenotato: false,
      createDateTime: DateTime.now(),
      latestEditDateTime: DateTime.now(),
    ),

    new PrenForLinsting(
      prenID: "3",
      classe: "5IC",
      aula: "3",
      prenotato: false,
      createDateTime: DateTime.now(),
      latestEditDateTime: DateTime.now(),
    ),
  ];

  String formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(title: Text('Lista Prenotazioni')),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => PrenModify()));
          },
          child: Icon(Icons.add),
        ),
        body: ListView.separated(
          separatorBuilder: (_, __) => Divider(height:1, color: Colors.green),
            itemBuilder: (_, index) {
              return Dismissible(
                key: ValueKey(prens[index].prenID),
                direction: DismissDirection.startToEnd,
                onDismissed: (direction){

                },
                confirmDismiss: (direction) async{
                  final ris = await showDialog(context: context, builder: (_) => PrenDelete()
                  );
                  print(ris);
                  return ris;
                },
                background: Container(
                  color: Colors.red,
                  padding: EdgeInsets.only(left: 16),
                  child: Align(child: Icon(Icons.delete, color: Colors.white), alignment: Alignment.centerLeft)
                ),
                child: ListTile(
                title: Text(
                  prens[index].classe,
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
                subtitle: Text("Modificato l'ultima volta li ${formatDateTime(prens[index].latestEditDateTime)}"),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => PrenModify(prenID: prens[index].prenID)));
                }
              ),
              );
              
            },
            itemCount: prens.length,
        )
        );
  }
}