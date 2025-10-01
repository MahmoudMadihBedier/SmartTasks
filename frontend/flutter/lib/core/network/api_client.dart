import 'dart:async';
import 'package:dio/dio.dart';
import '../storage/secure_storage.dart';

class ApiClient {
  final Dio _dio;
  final SecureStorage secureStorage;
  ApiClient({required this.secureStorage})
      : _dio = Dio(
          BaseOptions(
            baseUrl:
                'http://10.0.2.2:8000/api', // emulator local backend; adjust per platform
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
            headers: {'Content-Type': 'application/json'},
          ),
        ) {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await secureStorage.readAccessToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (err, handler) async {
        if (err.response?.statusCode == 401) {
          // Try refresh once
          final refreshed = await _refreshToken();
          if (refreshed) {
            final req = err.requestOptions;
            final opts = Options(
              method: req.method,
              headers: req.headers,
            );
            try {
              final response = await _dio.request(req.path,
                  options: opts,
                  data: req.data,
                  queryParameters: req.queryParameters);
              return handler.resolve(response);
            } on DioError catch (e) {
              return handler.reject(e);
            }
          }
        }
        return handler.next(err);
      },
    ));
  }

  Future<bool> _refreshToken() async {
    final refresh = await secureStorage.readRefreshToken();
    if (refresh == null) return false;
    try {
      final resp =
          await _dio.post('/auth/refresh/', data: {'refresh': refresh});
      final access = resp.data['access'] as String?;
      if (access != null) {
        await secureStorage.writeAccessToken(access);
        return true;
      }
    } catch (_) {}
    return false;
  }

  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) {
    return _dio.get(path, queryParameters: queryParameters);
  }

  Future<Response> post(String path, {dynamic data}) {
    return _dio.post(path, data: data);
  }

  Future<Response> put(String path, {dynamic data}) {
    return _dio.put(path, data: data);
  }

  Future<Response> delete(String path) {
    return _dio.delete(path);
  }
}
