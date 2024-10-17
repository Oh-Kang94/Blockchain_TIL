
abstract class SecureStorageDatasource {
  Future<bool> setSecure({required String key, required String value});
  Future<String?> getSecure({required String key});

  /// key 값 입력 안하면 전부 삭제
  Future<bool> delete({String key});
}
