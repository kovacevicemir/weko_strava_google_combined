import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Methods for handling incoming and outgoing data for the flutter secure storage plugin

class SecureStorage {
  final _storage = FlutterSecureStorage();

  Future writeSecureData(String key, String value) async {
    var writeData = await _storage.write(key: key, value: value);
    return writeData;
  }

  Future readSecureData(String key) async {
    var readData = await _storage.read(key: key);
    return readData!;
  }

  Future<bool> containsKey(String key) async {
    bool keyExists = await _storage.containsKey(key: key);
    return keyExists;
  }

  Future deleteSecureData(String key) async {
    var deleteData = await _storage.delete(key: key);
    return deleteData;
  }

  Future deleteAllSecureData() async {
    await _storage.deleteAll();

    print("Successfully deleted all secure storage.");
  }

  // Prints all the data currently stored within the storage
  Future readAllData() async {
    var readAll = await _storage.readAll();
    return readAll;
  }

  Future<String> readValue(String key) async {
    var getValue = await _storage.read(key: key);
    return getValue!;
  }

  Future<Map<String, dynamic>?> mapValues() async {
    var readAll = await _storage.readAll();
    return readAll;
  }
}
