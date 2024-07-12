import 'package:dio/dio.dart';
import 'package:photogenerator/Globals.dart';
import 'package:photogenerator/http_utils/provider.dart';
import 'package:photogenerator/http_utils/sub/request.dart';
import 'package:photogenerator/http_utils/sub/response.dart';
import 'package:photogenerator/models/generation.dart';
import 'package:photogenerator/models/model_category.dart';
import 'package:photogenerator/models/purchase.dart';

class Api {
  static late int _maxCredits;
  static late int _creditCost;
  static late int _creditGainPeriod;

  static int get maxCredits => _maxCredits;
  static int get creditCost => _creditCost;
  static int get creditGainPeriod => _creditGainPeriod;

  static Future<void> setInfo() async {
    Map<String, int> info = await _getInfo();
    _maxCredits = info["maxCredits"]!;
    _creditCost = info["creditCost"]!;
    _creditGainPeriod = info["creditGainPeriod"]!;
  }

  static Future<Map<String, int>> _getInfo() async {
    HttpResponse res = await HttpProvider.sendHttpRequest(
      method: RequestMethod.get,
      host: Globals.apiUrl,
      url: "/api/v1/info",
      timeoutDuration: Duration(seconds: 15),
    );
    return Map<String, int>.from(res.body);
  }

  static Future<bool> ping() async {
    HttpResponse res = await HttpProvider.sendHttpRequest(
      method: RequestMethod.get,
      host: Globals.apiUrl,
      url: "/api/v1/info/ping",
      timeoutDuration: Duration(seconds: 10),
    );
    return res.statusCode == 200;
  }

  static Future<List<ModelCategory>> getModelCategories() async {
    HttpResponse res = await HttpProvider.sendHttpRequest(
      method: RequestMethod.get,
      host: Globals.apiUrl,
      url: "/api/v1/generations/models",
      timeoutDuration: Duration(seconds: 15),
    );

    List<ModelCategory> result = [];
    for (dynamic category in res.body["categories"]) {
      result.add(ModelCategory.fromMap(category));
    }

    return result;
  }

  static Future<String> createUserId(String deviceId) async {
    HttpResponse res = await HttpProvider.sendHttpRequest(
      method: RequestMethod.post,
      host: Globals.apiUrl,
      url: "/api/v1/users",
      body: {
        "deviceId": deviceId,
      },
      timeoutDuration: Duration(seconds: 15),
    );
    return res.body["id"];
  }

  static Future<dynamic> getUser(String userId) async {
    HttpResponse res = await HttpProvider.sendHttpRequest(
      method: RequestMethod.get,
      host: Globals.apiUrl,
      url: "/api/v1/users/$userId",
      timeoutDuration: Duration(seconds: 15),
    );
    return res.body;
  }

  static Future<dynamic> deleteUser(String userId) async {
    HttpResponse res = await HttpProvider.sendHttpRequest(
      method: RequestMethod.delete,
      host: Globals.apiUrl,
      url: "/api/v1/users",
      body: {
        "userId": userId,
      },
      timeoutDuration: Duration(seconds: 15),
    );
    return res.body;
  }

  static Future<List<Generation>> getGenerations(String userId) async {
    HttpResponse res = await HttpProvider.sendHttpRequest(
      method: RequestMethod.get,
      host: Globals.apiUrl,
      url: "/api/v1/generations/user/$userId",
      timeoutDuration: Duration(seconds: 15),
    );
    return List<Generation>.from(
      res.body["generations"].map((e) => Generation.fromMap(e)),
    );
  }

  static Future<Generation> createGeneration(
    String userId, {
    required String filePath,
    required String promptId,
  }) async {
    HttpResponse res = await HttpProvider.sendHttpRequest(
      method: RequestMethod.post,
      host: Globals.apiUrl,
      url: "/api/v1/generations",
      timeoutDuration: Duration(seconds: 180),
      body: FormData.fromMap({
        "userId": userId,
        "image": await MultipartFile.fromFile(filePath),
        "promptId": promptId,
      }),
    );
    return Generation.fromMap(res.body);
  }

  static Future<Generation> getGeneration(String generationId) async {
    HttpResponse res = await HttpProvider.sendHttpRequest(
      method: RequestMethod.get,
      host: Globals.apiUrl,
      url: "/api/v1/generations/$generationId",
      timeoutDuration: Duration(seconds: 60),
    );
    return Generation.fromMap(res.body);
  }

  static Future<void> deleteGeneration(
    String userId, {
    required String generationId,
  }) async {
    await HttpProvider.sendHttpRequest(
      method: RequestMethod.delete,
      host: Globals.apiUrl,
      url: "/api/v1/generations",
      timeoutDuration: Duration(seconds: 60),
      body: {
        "userId": userId,
        "generationId": generationId,
      },
    );
  }

  static Future<bool> validateReceipt(Map<String, dynamic> receipt) async {
    HttpResponse res = await HttpProvider.sendHttpRequest(
      method: RequestMethod.post,
      host: Globals.apiUrl,
      url: "/api/v1/purchases",
      timeoutDuration: Duration(seconds: 60),
      body: receipt,
    );
    return res.statusCode == 200;
  }

  static Future<List<Purchase>> getPurchases(String userId) async {
    HttpResponse res = await HttpProvider.sendHttpRequest(
      method: RequestMethod.get,
      host: Globals.apiUrl,
      url: "/api/v1/purchases/user/$userId",
      timeoutDuration: Duration(seconds: 60),
    );
    return List<Purchase>.from(
      res.body["purchases"].map((e) => Purchase.fromMap(e)),
    );
  }

  static Future<Purchase> getPurchase(
    String orderId,
  ) async {
    HttpResponse res = await HttpProvider.sendHttpRequest(
      method: RequestMethod.get,
      host: Globals.apiUrl,
      url: "/api/v1/purchases/$orderId",
      timeoutDuration: Duration(seconds: 60),
    );
    return Purchase.fromMap(res.body);
  }
}
