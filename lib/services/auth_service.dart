import 'dart:async';
import '../models/user.dart';

/// Abstract authentication service interface
abstract class AuthService {
  Future<User?> getCurrentUser();
  Future<User> register({
    required String fullName,
    required String city,
    required UserRole role,
  });
  Future<User> login(String email, String password);
  Future<void> logout();
  bool get isAuthenticated;
}

/// Mock implementation of AuthService for development
class MockAuthService implements AuthService {
  User? _currentUser;

  @override
  bool get isAuthenticated => _currentUser != null;

  @override
  Future<User?> getCurrentUser() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    return _currentUser;
  }

  @override
  Future<User> register({
    required String fullName,
    required String city,
    required UserRole role,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Create mock user
    final user = User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      fullName: fullName,
      city: city,
      role: role,
      createdAt: DateTime.now(),
    );

    _currentUser = user;
    return user;
  }

  @override
  Future<User> login(String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Mock validation
    if (email.isEmpty || password.isEmpty) {
      throw AuthException('Email and password are required');
    }

    // Create mock user for demo
    final user = User(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      fullName: 'Jean-Pierre',
      city: 'Bamako',
      role: UserRole.eleveur,
      createdAt: DateTime.now(),
    );

    _currentUser = user;
    return user;
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _currentUser = null;
  }
}

/// Custom exception for authentication errors
class AuthException implements Exception {
  final String message;
  AuthException(this.message);

  @override
  String toString() => 'AuthException: $message';
}
