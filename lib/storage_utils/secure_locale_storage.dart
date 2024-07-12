library secure_locale_storage;

import 'package:flutter_keychain/flutter_keychain.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureLocaleStorage {
  static FlutterSecureStorage _storage = const FlutterSecureStorage(
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock,
    ),
  );

  static void setTestStorage(FlutterSecureStorage testStorage) {
    _storage = testStorage;
  }

  static Future<void> deleteAll() async {
    await _storage.deleteAll();
    await FlutterKeychain.clear();
  }

  // static Future<String> _get(String key) async {
  //   try {
  //     String? val1 = await _storage.read(key: key);
  //     String? val2 = await FlutterKeychain.get(key: key);
  //     if (val1 == null && val2 == null) throw "Null values";
  //     String val = val1 ?? val2!;
  //     await _write(key, val);
  //     return val;
  //   } catch (e) {
  //     bool containsKey = false;
  //     try {
  //       containsKey = await _storage.containsKey(key: key);
  //     } catch (_) {}
  //     throw "Null value in secure locale storage for key: $key (contains key: $containsKey)";
  //   }
  // }

  static Future<String?> _getAllowNullValue(String key) async {
    String? val1 = await _storage.read(key: key);
    String? val2 = await FlutterKeychain.get(key: key);
    if (val1 != null) return val1;
    if (val2 != null) return val2;
    return null;
  }

  static Future<void> _write(String key, String value) async {
    await _storage.write(key: key, value: value);
    await FlutterKeychain.put(key: key, value: value);
  }

  // USER ID
  // static Future<String?> getUserId() async {
  //   return _getAllowNullValue("user_id");
  // }

  // static Future<void> storeUserId(String userId) async {
  //   await _write("user_id", userId);
  // }

  // USER ID
  static Future<String?> getDeviceId() async {
    return _getAllowNullValue("device_id");
  }

  static Future<void> storeDeviceId(String deviceId) async {
    await _write("device_id", deviceId);
  }
}
