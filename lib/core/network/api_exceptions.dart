import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  const ApiException({
    required this.message,
    this.statusCode,
    this.data,
  });

  factory ApiException.fromDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const ApiException(message: 'Connection timed out. Check your network.');
      case DioExceptionType.connectionError:
        return const ApiException(message: 'No internet connection.');
      case DioExceptionType.badResponse:
        final status = e.response?.statusCode;
        final body = e.response?.data;
        String msg = 'Server error';
        if (body is Map && body.containsKey('detail')) {
          msg = body['detail'].toString();
        } else if (body is Map && body.containsKey('non_field_errors')) {
          final errors = body['non_field_errors'];
          msg = errors is List ? errors.join(', ') : errors.toString();
        } else if (status == 400 && body is Map) {
          // DRF validation errors: { "field_name": ["error1", "error2"], ... }
          final parts = <String>[];
          for (final entry in body.entries) {
            final key = entry.key.toString();
            final value = entry.value;
            if (value is List) {
              parts.add('$key: ${value.join(' ')}');
            } else {
              parts.add('$key: $value');
            }
          }
          msg = parts.isEmpty ? 'Validation error' : parts.join('; ');
        } else if (status == 401) {
          msg = 'Invalid credentials.';
        } else if (status == 403) {
          msg = 'Access denied.';
        } else if (status == 404) {
          msg = 'Resource not found.';
        } else if (status != null && status >= 500) {
          msg = 'Server error. Try again later.';
        }
        return ApiException(message: msg, statusCode: status, data: body);
      case DioExceptionType.cancel:
        return const ApiException(message: 'Request cancelled.');
      default:
        return ApiException(message: e.message ?? 'Unexpected error.');
    }
  }

  @override
  String toString() => 'ApiException($statusCode): $message';
}
