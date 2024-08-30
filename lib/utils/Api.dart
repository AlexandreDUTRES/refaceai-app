import 'package:dio/dio.dart';
import 'package:photogenerator/Globals.dart';
import 'package:photogenerator/http_utils/provider.dart';
import 'package:photogenerator/http_utils/sub/request.dart';
import 'package:photogenerator/http_utils/sub/response.dart';
import 'package:photogenerator/models/generation.dart';
import 'package:photogenerator/models/model_category.dart';

class Api {
  static Future<List<ModelCategory>> getModelCategories() async {
    HttpResponse res = await HttpProvider.sendHttpRequest(
      method: RequestMethod.get,
      host: Globals.apiUrl,
      url: "/api/v1/generations/models",
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
    );
    return res.body["id"];
  }

  static Future<dynamic> getUser(String userId) async {
    HttpResponse res = await HttpProvider.sendHttpRequest(
      method: RequestMethod.get,
      host: Globals.apiUrl,
      url: "/api/v1/users/$userId",
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

  static Future<String> getUserGenerationStatus(String userId) async {
    HttpResponse res = await HttpProvider.sendHttpRequest(
      method: RequestMethod.get,
      host: Globals.apiUrl,
      url: "/api/v1/generations/user/$userId/status",
    );
    return res.body["status"];
  }

  static Future<String> startGeneration(
    String userId, {
    required String filePath,
    required String promptId,
    required String? advertId,
  }) async {
    HttpResponse res = await HttpProvider.sendHttpRequest(
      method: RequestMethod.post,
      host: Globals.apiUrl,
      url: "/api/v1/generations/v2",
      body: FormData.fromMap({
        "userId": userId,
        "image": await MultipartFile.fromFile(filePath),
        "promptId": promptId,
        if (advertId != null) "advertId": advertId,
      }),
    );
    return res.body["id"];
  }

  static Future<Generation> getGeneration(String generationId) async {
    HttpResponse res = await HttpProvider.sendHttpRequest(
      method: RequestMethod.get,
      host: Globals.apiUrl,
      url: "/api/v1/generations/$generationId",
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
      body: {
        "userId": userId,
        "generationId": generationId,
      },
    );
  }

  // static Future<bool> validateReceipt(Map<String, dynamic> receipt) async {
  //   HttpResponse res = await HttpProvider.sendHttpRequest(
  //     method: RequestMethod.post,
  //     host: Globals.apiUrl,
  //     url: "/api/v1/purchases",
  //     body: receipt,
  //   );
  //   return res.statusCode == 200;
  // }

  // static Future<List<Purchase>> getPurchases(String userId) async {
  //   HttpResponse res = await HttpProvider.sendHttpRequest(
  //     method: RequestMethod.get,
  //     host: Globals.apiUrl,
  //     url: "/api/v1/purchases/user/$userId",
  //   );
  //   return List<Purchase>.from(
  //     res.body["purchases"].map((e) => Purchase.fromMap(e)),
  //   );
  // }

  // static Future<Purchase> getPurchase(
  //   String orderId,
  // ) async {
  //   HttpResponse res = await HttpProvider.sendHttpRequest(
  //     method: RequestMethod.get,
  //     host: Globals.apiUrl,
  //     url: "/api/v1/purchases/$orderId",
  //   );
  //   return Purchase.fromMap(res.body);
  // }
}
