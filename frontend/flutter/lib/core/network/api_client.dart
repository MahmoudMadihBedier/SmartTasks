import 'dart:async';
import 'package:dio/dio.dart';
import '../storage/secure_storage.dart';

class ApiClient {
  final Dio _dio;
  final SecureStorage secureStorage;
  ApiClient({required this.secureStorage})
      : _dio = Dio(
          BaseOptions(
            baseUrl: 'http://10.0.2.2:8000/api', // Android emulator default; update for device/production
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
            headers: {'Content-Type': 'application/json'},
          ),
        ) {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        try {
          final token = await secureStorage.readAccessToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
        } catch (_) {
          // ignore storage errors here; request will continue unauthenticated
        }
        return handler.next(options);
      },
      onError: (err, handler) async {
        final requestOptions = err.requestOptions;
        // Only attempt refresh once per request
        final alreadyRetried = requestOptions.extra['retried'] == true;
        if (err.response?.statusCode == 401 && !alreadyRetried) {
          final refreshed = await _refreshToken();
          if (refreshed) {
            // mark retried to avoid loops
            requestOptions.extra['retried'] = true;
            try {
              final opts = Options(
                method: requestOptions.method,
                headers: requestOptions.headers,
                responseType: requestOptions.responseType,
                contentType: requestOptions.contentType,
                followRedirects: requestOptions.followRedirects,
                validateStatus: requestOptions.validateStatus,
                receiveDataWhenStatusError: requestOptions.receiveDataWhenStatusError,
              );
              final response = await _dio.request(
                requestOptions.path,
                data: requestOptions.data,
                queryParameters: requestOptions.queryParameters,
                options: opts,
              );
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
    if (refresh == null || refresh.isEmpty) return false;
    try {
      final resp = await _dio.post('/auth/refresh/', data: {'refresh': refresh});
      final data = resp.data as Map<String, dynamic>? ?? {};
      final access = (data['access'] ?? data['access_token']) as String?;
      if (access != null && access.isNotEmpty) {
        await secureStorage.writeAccessToken(access);
        return true;
      }
    } catch (_) {
      // ignore refresh errors here; caller will handle auth failure
    }
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
