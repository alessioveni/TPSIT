import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:prenotazioni/models/api_response.dart';
import 'package:prenotazioni/models/pren_for_listing.dart';
import 'package:prenotazioni/services/prens_service.dart';
import 'package:prenotazioni/views/pren_delete.dart';
import 'package:prenotazioni/views/pren_modify.dart';

class PrenList extends StatefulWidget {

/* test per nomi prenotazioni
  String id;
  String classe;
  String aula;
  bool prenotato;
  DateTime createDateTime;
  DateTime lastEditTime;
*/

  @override
  _PrenListState createState() => _PrenListState();
}

class _PrenListState extends State<PrenList> {
  //final service = PrensService();
  PrensService get service => GetIt.I<PrensService>();


  String formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  APIResponse<List<PrenForLinsting>> _apiResponse;
  bool _isLoading = false;

  @override
  void initState() {
    _fetchPrens();
    super.initState();
  }

  _fetchPrens() async {
    setState(() {
      _isLoading = true;
    });

    _apiResponse = await service.getPrensList();

    setState(() {
      _isLoading = false;
    });
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
        body: Builder(
          builder: (_) {
            if (_isLoading) {
              return Center(child: CircularProgressIndicator());
            }

            if (_apiResponse.error) {
              return Center(child: Text(_apiResponse.errorMessage));
            }


            return ListView.separated(
          separatorBuilder: (_, __) => Divider(height:1, color: Colors.green),
            itemBuilder: (_, index) {
              return Dismissible(
                key: ValueKey(_apiResponse.data[index].id),
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
                  _apiResponse.data[index].classe,
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
                subtitle: Text("Modificato l'ultima volta li ${formatDateTime(_apiResponse.data[index].latestEditDateTime ?? _apiResponse.data[index].createDateTime )}"),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => PrenModify(id: _apiResponse.data[index].id)));
                }
              ),
              );
              
            },
            itemCount: _apiResponse.data.length,
        );
          }
        )
      );
  }
}