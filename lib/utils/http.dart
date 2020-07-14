import 'dart:convert' as json;

import 'package:http/http.dart' as http;

class Http {
  static Future<dynamic> get(String url) async {
    return http.get(url).catchError(_onError).then((http.Response response) {
      if (response.statusCode != 200) {
        return null;
      }
      return json.jsonDecode(response.body);
    });
  }

  static Future<dynamic> post(String url, dynamic data) async {
    var requestData = json.jsonEncode(data);

    print(requestData);

    final Map<String, String> headers = {
      'Host': '',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    return http
        .post(url, body: requestData, headers: headers)
        .catchError(_onError)
        .then((http.Response response) {
      if (response.statusCode != 200) {
        print(response.statusCode);
        print(json.jsonEncode(response.headers));
        print(response.body);
        return response.headers['Message'];
      }

      return json.jsonDecode(response.body);
    });
  }

  static void _onError(dynamic err) {
    print("Hello");
    print(err);
  }
}
