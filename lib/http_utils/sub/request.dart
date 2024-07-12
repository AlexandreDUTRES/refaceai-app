library http_utils;

import 'package:dio/dio.dart';
import 'package:photogenerator/http_utils/sub/response.dart';

enum RequestMethod { post, get, put, delete }

class HttpRequest {
  final RequestMethod method;
  final String globalUrl;

  final dynamic body;
  final bool allowResponse401;
  final Map<String, String> headers;
  final Duration timeoutDuration;

  HttpRequest({
    required this.method,
    required this.globalUrl,
    this.body = const {},
    this.allowResponse401 = false,
    this.headers = const {},
    required this.timeoutDuration,
  });

  Dio httpClient = Dio();

  Future<HttpResponse> send() async {
    try {
      Response res;

      switch (method) {
        case RequestMethod.get:
          res = await httpClient
              .get(
                globalUrl,
                options: Options(headers: headers),
              )
              .timeout(timeoutDuration);
          break;
        case RequestMethod.post:
          res = await httpClient
              .post(
                globalUrl,
                options: Options(headers: headers),
                data: body,
              )
              .timeout(timeoutDuration);
          break;
        case RequestMethod.put:
          res = await httpClient
              .put(
                globalUrl,
                options: Options(headers: headers),
                data: body,
              )
              .timeout(timeoutDuration);
          break;
        case RequestMethod.delete:
          res = await httpClient
              .delete(
                globalUrl,
                options: Options(headers: headers),
                data: body,
              )
              .timeout(timeoutDuration);
          break;
      }

      if (allowResponse401 && res.statusCode == 401) {
        return HttpResponse.fromResponse(res);
      } else if (res.statusCode != 200) {
        throw "Error http request : $globalUrl \n ${res.statusCode} \n ${res.data}";
      } else {
        return HttpResponse.fromResponse(res);
      }
    } catch (e) {
      rethrow;
    }
  }
}
