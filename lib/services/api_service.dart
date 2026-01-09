import 'dart:async';

/// Base API service for HTTP operations
/// This is a placeholder for future real API integration
abstract class ApiService {
  String get baseUrl;

  Future<Map<String, dynamic>> get(String endpoint);
  Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> body);
  Future<Map<String, dynamic>> put(String endpoint, Map<String, dynamic> body);
  Future<void> delete(String endpoint);
}

/// Mock implementation for development
class MockApiService implements ApiService {
  @override
  String get baseUrl => 'https://api.mawashi.local';

  @override
  Future<Map<String, dynamic>> get(String endpoint) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // Return mock data based on endpoint
    return {'success': true, 'data': {}};
  }

  @override
  Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return {'success': true, 'data': body};
  }

  @override
  Future<Map<String, dynamic>> put(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return {'success': true, 'data': body};
  }

  @override
  Future<void> delete(String endpoint) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }
}

/// Exception for API errors
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() => 'ApiException: $message (status: $statusCode)';
}
