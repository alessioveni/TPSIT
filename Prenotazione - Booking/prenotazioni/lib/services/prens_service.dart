import 'dart:convert';
import 'package:prenotazioni/models/api_response.dart';
import 'package:prenotazioni/models/pren.dart';
import 'package:prenotazioni/models/pren_for_listing.dart';
import 'package:http/http.dart' as http;


class PrensService{

  static const API = 'http://localhost:3000';
  //static const headers = {'apiKey': '08d771e2-7c49-1789-0eaa-32aff09f1471'};
  //var url = Uri.https('localhost:3000', '/prens', {'q': '{http}'});
  var url = 'http://localhost/prens/';
  var url1 = 'https://api.npoint.io/9bf35b0c70b938819ee3/prens/';
  
  Future<APIResponse<List<PrenForLinsting>>> getPrensList() {
    //print("error");
    //print(Uri.parse(API + '/prens'));
    //return http.get(API + '/prens', headers: headers).then((data) { 
    return http.get(Uri.parse(url1)).then((data) {
    //return http.get(Uri.parse(url)).then((data) {
      if(data.statusCode == 200) {
        final jsonData = json.decode(data.body);
        final prens = <PrenForLinsting>[];
        for (var item in jsonData) {
          prens.add(PrenForLinsting.fromJson(item));
        }
        return APIResponse<List<PrenForLinsting>>(data: prens);
      }
      return APIResponse<List<PrenForLinsting>>(error: true, errorMessage: 'errore');
    });
    //.catchError((_) => APIResponse<List<PrenForLinsting>>(error: true, errorMessage: 'errore'));
  }

  Future<APIResponse<Pren>> getPren(String id) {

    return http.get(Uri.parse(('https://api.npoint.io/9bf35b0c70b938819ee3/prens/' + id))).then((data) {
      if(data.statusCode == 200) {
        final jsonData = json.decode(data.body);


          
        
        return APIResponse<Pren>(data: Pren.fromJson(jsonData));
      }
      return APIResponse<Pren>(error: true, errorMessage: 'errore');
    })
    .catchError((_) => APIResponse<Pren>(error: true, errorMessage: 'errore'));
  }
}