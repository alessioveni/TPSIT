import 'package:prenotazioni/models/api_response.dart';
import 'package:prenotazioni/models/pren_for_listing.dart';

import 'package:prenotazioni/models/pren_for_listing.dart';
import 'package:prenotazioni/models/api_response.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PrensService{

  static const API = 'http://api.notes.programmingaddict.com';
  static const headers = {'apiKey': '08d771e2-7c49-1789-0eaa-32aff09f1471'};

  Future<APIResponse<List<PrenForLinsting>>> getPrensList() {
    return http.get(API + '/prens', headers: headers).then((data) {
      if(data.statusCode == 200) {
        final jsonData = json.decode(data.body);
        final prens = <PrenForLinsting>[];
        for (var item in jsonData) {
          final pren = PrenForLinsting(
            prenID: item['prenID'],
            classe: item['classe'],
            aula: item['aula'],
            prenotato: item['prenotato'],
            createDateTime: DateTime.parse(item['createDateTime']),
            latestEditDateTime: item['latestEditDateTime'] != null ? DateTime.parse(item['latestEditDateTime']) : null,
          );
          prens.add(pren);
        }
        return APIResponse<List<PrenForLinsting>>(data: prens);
      }
      return APIResponse<List<PrenForLinsting>>(error: true, errorMessage: 'Errore');
    })
    .catchError((_) => APIResponse<List<PrenForLinsting>>(error: true, errorMessage: 'Errore'));
  }
}