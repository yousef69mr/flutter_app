import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static const FlutterSecureStorage storage = FlutterSecureStorage();

  static Future<void> setItem(String key, dynamic value) async {
    await storage.write(key: key, value: value);
  }

  static Future<String?> getItem(String key) async {
    return await storage.read(key: key);
  }

  static Future<Map<String, String>> getAllItems(String key) async {
    return await storage.readAll();
  }

  static Future<void> removeItem(String key) async {
    await storage.delete(key: key);
  }
}
