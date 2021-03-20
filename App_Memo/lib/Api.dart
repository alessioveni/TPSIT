import 'package:http/http.dart';

class Api {  //metodi 
  Map<String, String> headers = {"Content-type": "application/json"};
  String url = 'https://8a16807cc160.ngrok.io';

  uploadMemoOnline(String title, String memoBody, String tag) async {
    String params = '?title=' + title + '&body=' + memoBody + '&tag=' + tag;
    url = url + '/api/memo/new' + params;
    Response response = await post(url, headers: headers); //, body: json
    int statusCode = response.statusCode;
    print('statusCode--> ' + statusCode.toString());
    String body = response.body;
    print('body--> ' + body);
  }

  deleteMemo(param) async { //param è "all" (se avessi avuto più tempo avrei inserito anche un id memo)
    String params = '?delete=' + param;
    url = url + '/api/memo/delete' + params;

    Response response = await post(url, headers: headers); //, body: json
    int statusCode = response.statusCode;
    print('statusCode--> ' + statusCode.toString());
    String body = response.body;
    print('body--> ' + body);
  }
}
