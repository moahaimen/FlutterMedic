import 'dart:convert' as json;

import 'package:http/http.dart' as http;

class Http {
  static Future<dynamic> get(String url, {Map<String, String> headers}) async {
    if (headers == null) {
      headers = new Map();
    }
    headers['content-Type'] = 'application/json';
    headers['accept'] = 'application/json';

    return http
        .get(url, headers: headers)
        .catchError(_onError)
        .then((http.Response response) {
      if (response == null) {
        return null;
      }
      if (response.statusCode != 200) {
        return null;
      }

      return json.jsonDecode(response.body);
    });
  }

  static Future<dynamic> post(String url, Map<String, dynamic> data,
      {Map<String, String> headers}) async {
    if (headers == null) {
      headers = new Map();
    }
    headers['content-Type'] = 'application/json';
    headers['accept'] = 'application/json';

    print(url);

    var requestData = json.jsonEncode(data);
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

  static Future<dynamic> put(String url, Map<String, dynamic> data,
      {Map<String, String> headers}) async {
    if (headers == null) {
      headers = new Map();
    }
    headers['content-Type'] = 'application/json';
    headers['accept'] = 'application/json';

    var requestData = json.jsonEncode(data);

    return http
        .put(url, body: requestData, headers: headers)
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
    print(err);
  }
}
