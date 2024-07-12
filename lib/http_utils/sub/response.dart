import 'dart:convert';
import 'package:dio/dio.dart';

class HttpResponse {
  final int statusCode;
  final dynamic body;

  HttpResponse(this.statusCode, this.body);
  factory HttpResponse.fromResponse(Response res) {
    dynamic body = res.data;

    dynamic jsonBody;
    try {
      if (body.isEmpty) {
        jsonBody = {};
      } else if (body is Map<String, dynamic>) {
        jsonBody = {...body};
      } else {
        jsonBody = json.decode(body);
      }
    } catch (e) {
      rethrow;
    }
    return HttpResponse(res.statusCode!, jsonBody);
  }
}
