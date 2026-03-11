import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../constants/app_constants.dart';
import 'api_exceptions.dart';

final secureStorageProvider = Provider<FlutterSecureStorage>(
  (_) => const FlutterSecureStorage(),
);

final apiClientProvider = Provider<ApiClient>((ref) {
  final storage = ref.watch(secureStorageProvider);
  return ApiClient(baseUrl: AppConstants.apiBaseUrl, storage: storage);
});

class ApiClient {
  final Dio dio;
  final FlutterSecureStorage _storage;

  ApiClient({
    required String baseUrl,
    required FlutterSecureStorage storage,
  })  : _storage = storage,
        dio = Dio(
          BaseOptions(
            baseUrl: baseUrl,
            connectTimeout: const Duration(seconds: 15),
            receiveTimeout: const Duration(seconds: 15),
            headers: {'Content-Type': 'application/json'},
          ),
        ) {
    dio.interceptors.add(_authInterceptor());
  }

  InterceptorsWrapper _authInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _storage.read(key: AppConstants.tokenStorageKey);
        if (token != null) {
          options.headers['Authorization'] = 'Token $token';
        }
        handler.next(options);
      },
      onError: (error, handler) {
        handler.next(error);
      },
    );
  }

  Future<void> saveToken(String token) =>
      _storage.write(key: AppConstants.tokenStorageKey, value: token);

  Future<void> clearToken() =>
      _storage.delete(key: AppConstants.tokenStorageKey);

  Future<String?> getToken() =>
      _storage.read(key: AppConstants.tokenStorageKey);

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await dio.get<T>(path, queryParameters: queryParameters);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
  }) async {
    try {
      return await dio.post<T>(path, data: data);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
  }) async {
    try {
      return await dio.put<T>(path, data: data);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
  }) async {
    try {
      return await dio.patch<T>(path, data: data);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<Response<T>> delete<T>(String path) async {
    try {
      return await dio.delete<T>(path);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}
