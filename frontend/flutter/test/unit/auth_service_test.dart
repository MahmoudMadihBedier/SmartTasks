import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:smarttasks/features/auth/repositories/auth_repository.dart';
import 'package:smarttasks/core/network/api_client.dart';
import 'package:smarttasks/core/storage/secure_storage.dart';
import 'dart:convert';
import 'package:dio/dio.dart';

class _MockApiClient extends Mock implements ApiClient {}

class _MockStorage extends Mock implements SecureStorage {}

void main() {
  test('AuthRepository.login stores tokens on success', () async {
    final api = _MockApiClient();
    final storage = _MockStorage();
    final repo = AuthRepositoryImpl(apiClient: api, secureStorage: storage);

    final responseData = {
      'access': 'access-token',
      'refresh': 'refresh-token',
      'user': {'id': 1, 'email': 'a@b.com', 'full_name': 'A B'}
    };

    when(() => api.post('/auth/login/', data: any(named: 'data'))).thenAnswer(
      (_) async => Response(
          requestOptions: RequestOptions(path: '/auth/login/'),
          data: responseData),
    );

    await repo.login('a@b.com', 'pw');

    verify(() => storage.writeAccessToken('access-token')).called(1);
    verify(() => storage.writeRefreshToken('refresh-token')).called(1);
  });
}
