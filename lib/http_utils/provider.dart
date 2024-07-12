library provider;

import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:photogenerator/http_utils/sub/manager.dart';
import 'package:photogenerator/http_utils/sub/request.dart';
import 'package:photogenerator/http_utils/sub/response.dart';
import 'package:photogenerator/models/hexstring.dart';
import 'package:photogenerator/utils/Common.dart';

export 'package:xml/xml.dart';

enum HttpError { noConnection }

class HttpProvider {
  static HttpManager manager = HttpManager();

  static void setTestHttpManager(HttpManager testHttpManager) {
    manager = testHttpManager;
  }

  static Future<bool> get hasConnection async => await manager.hasConnection();

  static Future<String> _buildSignature({
    required RequestMethod method,
    required String url,
    required String queryString,
    required dynamic body,
  }) async {
    String bodyPart;
    if (body is FormData) {
      bodyPart = json.encode(body.fields.map((e) => e.key).toList());
    } else {
      bodyPart = body.keys.isEmpty ? "" : json.encode(body);
    }
    String message =
        "${method.toString().replaceFirst('RequestMethod.', '').toUpperCase()}\n$url\n$queryString\n$bodyPart";
    HexString hash =
        HexString(Common.hashSHA256(message).toString().substring(5, 12));
    int p = hash.toInt();
    int res = (((log(p) / ln10) - cos(p)) * 125874).round() * 10000000 + p;
    return res.toString();
  }

  static Future<HttpResponse> sendHttpRequest({
    required RequestMethod method,
    required String host,
    String url = "",
    String queryString = "",
    dynamic body = const {},
    bool useCacheManager = false,
    bool allowResponse401 = false,
    Map<String, String> headers = const {},
    String accept = "application/json",
    String contentType = "application/json; charset=utf-8",
    Duration timeoutDuration = const Duration(seconds: 30),
  }) async {
    String globalUrl = "$host$url?$queryString";
    Map<String, String> globalHeaders = {
      'Accept': accept,
      'Content-Type': contentType,
    };
    for (String key in headers.keys) {
      globalHeaders[key] = headers[key]!;
    }

    if (!(await manager.hasConnection())) throw HttpError.noConnection;

    globalHeaders["secure-token"] = await _buildSignature(
      method: method,
      url: url,
      queryString: queryString,
      body: body,
    );

    return await HttpRequest(
      method: method,
      globalUrl: globalUrl,
      body: body,
      allowResponse401: allowResponse401,
      headers: globalHeaders,
      timeoutDuration: timeoutDuration,
    ).send();
  }
}
