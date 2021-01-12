import 'dart:convert' as json;

import 'package:http/http.dart' as http;

class Result<T> {
  final T result;
  final dynamic error;
  final String message;

  Result(this.result, this.error, this.message)
      : assert(result != null || error != null);
}

class Http {
  static Future<Result<T>> get<T>(String url, Map<String, String> headers) {
    headers['content-Type'] = 'application/json';
    headers['accept'] = 'application/json';

    return http
        .get(url, headers: headers)
        .catchError(_onError)
        .then((http.Response response) {
      if (response == null || response.statusCode != 200) {
        return new Result(
          null,
          json.jsonDecode(response.body),
          response.headers['Message'],
        );
      }
      return new Result(
        json.jsonDecode(response.body),
        null,
        response.headers['Message'],
      );
    });
  }

  static Future<Result<T>> post<T>(
    String url,
    Map<String, dynamic> data,
    Map<String, String> headers,
  ) {
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
        return new Result(
          null,
          json.jsonDecode(response.body),
          response.headers['Message'],
        );
      }

      return new Result(
        json.jsonDecode(response.body),
        null,
        response.headers['Message'],
      );
    });
  }

  static Future<Result<T>> put<T>(
    String url,
    Map<String, dynamic> data,
    Map<String, String> headers,
  ) {
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
        return new Result(
          null,
          json.jsonDecode(response.body),
          response.headers['Message'],
        );
      }

      return new Result(
        json.jsonDecode(response.body),
        null,
        response.headers['Message'],
      );
    });
  }

  static void _onError(dynamic err) {
    print(err);
  }
}
