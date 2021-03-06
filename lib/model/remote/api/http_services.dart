import 'dart:convert';
import 'dart:io';
import 'package:do_it_flutter/utils/log.dart';
import 'package:http/http.dart' as http;

class HttpServices {
  final String _baseUrl = "http://192.168.1.6:1337/";

  Future<void> _request(
      {required Future<http.Response> futureResponse,
      required String requestName,
      Function(String)? onSuccess,
      Function(int)? onError,
      Function()? onConnectionError}) async {
    try {
      http.Response response = await futureResponse;
      if (response.statusCode == 200) {
        Log.httpSuccess(requestName: requestName, response: response);
        if (onSuccess != null) onSuccess(response.body);
      } else {
        Log.httpError(requestName: requestName, response: response);
        if (onError != null) onError(response.statusCode);
      }
    } on SocketException catch (e) {
      Log.error("connection error");
      if (onConnectionError != null) onConnectionError();
    }
  }

  Future<void> get(
      {required String endpoint,
      required String requestName,
      Map<String, String>? headers,
      Function(String)? onSuccess,
      Function(int)? onError,
      Function()? onConnectionError}) async {
    Uri url = Uri.parse(_baseUrl + endpoint);

    await _request(
        futureResponse: http.get(url, headers: headers),
        requestName: requestName,onSuccess: onSuccess,onConnectionError: onConnectionError,onError: onError);
  }

  post(
      {required String endpoint,
      required String requestName,
      Map<String, String>? headers,
      Object? body,
      Encoding? encoding,
      Function(String)? onSuccess,
      Function(int)? onError,
      Function()? onConnectionError}) async {
    Uri url = Uri.parse(_baseUrl + endpoint);

    _request(
        futureResponse:
            http.post(url, headers: headers, body: body, encoding: encoding),
        requestName: requestName,onError: onError, onConnectionError: onConnectionError, onSuccess: onSuccess);
  }
}
