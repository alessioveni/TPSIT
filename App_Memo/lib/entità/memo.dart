import 'dart:convert';
import 'package:floor/floor.dart';
import 'package:http/http.dart' as http;

Future<List<Memo>> fetchDataList() async { 
  final response = await http.get('https://2524fb95ed5e.ngrok.io');
  if (response.statusCode == 200) {
    final parsed = json.decode(response.body);
    print('body parsed ${parsed}');
    print(parsed.toString());
    return parsed.map<Memo>((json) => Memo.fromJson(json)).toList();
  } else {
    throw Exception('Errore inserimento dati!');
  }
}

@entity
class Memo {  
  @PrimaryKey(autoGenerate: true)
  final int id;

  String title;
  String body;
  String tag;
  String status;
  Memo({this.id, this.title, this.body, this.tag, this.status});

  factory Memo.fromJson(Map<String, dynamic> json) {
    return Memo(
      id: json['id'] as int,
      title: json['title'] as String,
      body: json['body'] as String,
      tag: json['tag'] as String,
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['body'] = this.body;
    data['tag'] = this.tag;
    data['status'] = this.status;
    return data;
  }
}
