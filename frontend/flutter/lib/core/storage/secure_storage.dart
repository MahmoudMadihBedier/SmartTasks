import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class SecureStorage {
  Future<void> writeAccessToken(String token);
  Future<void> writeRefreshToken(String token);
  Future<String?> readAccessToken();
  Future<String?> readRefreshToken();
  Future<void> deleteAll();
}

class SecureStorageImpl implements SecureStorage {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  static const _kAccess = 'access_token';
  static const _kRefresh = 'refresh_token';

  @override
  Future<void> deleteAll() => _storage.deleteAll();

  @override
  Future<String?> readAccessToken() => _storage.read(key: _kAccess);

  @override
  Future<String?> readRefreshToken() => _storage.read(key: _kRefresh);

  @override
  Future<void> writeAccessToken(String token) =>
      _storage.write(key: _kAccess, value: token);

  @override
  Future<void> writeRefreshToken(String token) =>
      _storage.write(key: _kRefresh, value: token);
}
