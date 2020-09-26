import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class Http {
  static Future<T> get<T>(BuildContext context, String path,
      {Map<String, dynamic> headers}) async {
    if (headers == null) {
      headers = new Map();
    }
    headers['content-Type'] = 'application/json';
    headers['accept'] = 'application/json';

    return Dio()
        .get(path, options: Options(headers: headers))
        .catchError((err) => _onError(context, err))
        .then((Response response) {
      print(path);
      if (response.statusCode != 200) {
        _onError(context, response.headers['Message']);
        return null;
      }
      return response.data;
    });
  }

  static Future<dynamic> post(BuildContext context, String path, dynamic data,
      {Map<String, dynamic> headers}) async {
    if (headers == null) {
      headers = new Map();
    }
    headers['content-Type'] = 'application/json';
    headers['accept'] = 'application/json';

    return Dio()
        .post(path, data: data, options: Options(headers: headers))
        .catchError((err) => _onError(context, err))
        .then((Response response) {
      if (response.statusCode != 200) {
        return response.headers['Message'];
      }
      return response.data;
    });
  }

  static void _onError(BuildContext context, dynamic err) {
    print(err);
    Toast.show("Network Problem", context, duration: 2);
  }
}
