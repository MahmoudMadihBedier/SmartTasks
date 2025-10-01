import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../../../core/storage/secure_storage.dart';
import '../../models/user.dart';

abstract class AuthRepository {
  Future<User> login(String email, String password);
  Future<User> register(String email, String password, String fullName);
  Future<void> logout();
}

class AuthRepositoryImpl implements AuthRepository {
  final ApiClient apiClient;
  final SecureStorage secureStorage;

  AuthRepositoryImpl({required this.apiClient, required this.secureStorage});

  @override
  Future<User> login(String email, String password) async {
    final resp = await apiClient
        .post('/auth/login/', data: {'email': email, 'password': password});
    final data = resp.data;
    final access = data['access'] as String?;
    final refresh = data['refresh'] as String?;
    final userJson = data['user'] as Map<String, dynamic>;
    if (access != null && refresh != null) {
      await secureStorage.writeAccessToken(access);
      await secureStorage.writeRefreshToken(refresh);
    }
    return User.fromJson(userJson);
  }

  @override
  Future<User> register(String email, String password, String fullName) async {
    final resp = await apiClient.post('/auth/register/',
        data: {'email': email, 'password': password, 'full_name': fullName});
    final userJson = resp.data as Map<String, dynamic>;
    return User.fromJson(userJson);
  }

  @override
  Future<void> logout() async {
    await secureStorage.deleteAll();
  }
}
