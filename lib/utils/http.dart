import 'dart:convert' as json;

import 'package:http/http.dart' as http;

class Http {
  static Future<dynamic> get(String url) {
    return http.get(url).catchError(_onError).then((http.Response response) {
      if (response.statusCode != 200) {
        return null;
      }

      return json.jsonDecode(response.body);
    });
  }

  static Future<dynamic> post(String url, dynamic data) {
    var requestData = json.jsonEncode(data);
    return http
        .post(url, body: requestData)
        .catchError(_onError)
        .then((http.Response response) {
      if (response.statusCode != 200) {
        return null;
      }

      return json.jsonDecode(response.body);
    });
  }

  static void _onError(dynamic err) {
    print("Hello");
    print(err);
  }
}
