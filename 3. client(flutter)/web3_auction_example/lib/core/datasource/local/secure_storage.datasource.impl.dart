import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:web3_auction_example/core/datasource/local/secure_storage.datasource.dart';
import 'package:web3_auction_example/core/util/logger.dart';

class SecureStorageDatasourceImpl implements SecureStorageDatasource {
  final storage = const FlutterSecureStorage();
  @override
  Future<String?> getSecure({required String key}) async {
    return await storage.read(key: key);
  }

  @override
  Future<bool> setSecure({required String key, required String value}) async {
    try {
      await storage.write(key: key, value: value);
      return true;
    } catch (e) {
      CLogger.e("Error From Secure : $e");
      return false;
    }
  }

  @override
  Future<bool> delete({String key = 'all'}) async {
    try {
      if (key == 'all') {
        await storage.deleteAll();
        return true;
      }

      await storage.delete(key: key);
      return true;
    } catch (e) {
      CLogger.e("Error From Secure : $e");
      return false;
    }
  }
}
