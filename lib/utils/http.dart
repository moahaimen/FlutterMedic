import 'dart:convert' as json;

import 'package:http/http.dart' as http;

class Result<T> {
  final T result;
  final dynamic error;
  final String message;
  final int statusCode;

  Result(this.result, this.error, this.message, this.statusCode)
      : assert(result != null || error != null);
}

class Http {
  static Future<Result<T>> get<T>(
      String url, Map<String, String> headers) async {
    headers['content-Type'] = 'application/json';
    headers['accept'] = 'application/json';

    final http.Response response =
        await http.get(url, headers: headers).catchError(_onError);
    if (response == null || response.statusCode != 200) {
      print(json.jsonDecode(response.body));
      return new Result(
        null,
        json.jsonDecode(response.body),
        response.headers['Message'],
        response.statusCode,
      );
    }
    return new Result(
      json.jsonDecode(response.body),
      null,
      response.headers['Message'],
      response.statusCode,
    );
  }

  static Future<Result<T>> post<T>(String url, Map<String, dynamic> data,
      Map<String, String> headers) async {
    headers['content-Type'] = 'application/json';
    headers['accept'] = 'application/json';

    var requestData = json.jsonEncode(data);

    final http.Response response = await http
        .post(url, body: requestData, headers: headers)
        .catchError(_onError);

    print(url);
    print(response.statusCode);

    if (response == null || response.statusCode != 200) {
      return new Result(
        null,
        json.jsonDecode(response.body),
        response.headers['Message'],
        response.statusCode,
      );
    }

    return new Result(
      json.jsonDecode(response.body),
      null,
      response.headers['Message'],
      response.statusCode,
    );
  }

  static Future<Result<T>> put<T>(String url, Map<String, dynamic> data,
      Map<String, String> headers) async {
    headers['content-Type'] = 'application/json';
    headers['accept'] = 'application/json';

    var requestData = json.jsonEncode(data);

    final http.Response response = await http
        .put(url, body: requestData, headers: headers)
        .catchError(_onError);

    if (response == null || response.statusCode != 200) {
      print(response.statusCode);
      print(json.jsonEncode(response.headers));
      print(response.body);
      return new Result(
        null,
        json.jsonDecode(response.body),
        response.headers['Message'],
        response.statusCode,
      );
    }

    return new Result(
      json.jsonDecode(response.body),
      null,
      response.headers['Message'],
      response.statusCode,
    );
  }

  static void _onError(dynamic err) {
    print(err);
  }
}
