import 'package:flutter_test/flutter_test.dart';
import 'package:mawashi/services/auth_service.dart';
import 'package:mawashi/models/user.dart';

void main() {
  group('MockAuthService', () {
    late MockAuthService authService;

    setUp(() {
      authService = MockAuthService();
    });

    test('should start as not authenticated', () {
      expect(authService.isAuthenticated, false);
    });

    test('should register new user successfully', () async {
      final user = await authService.register(
        fullName: 'Test User',
        city: 'Test City',
        role: UserRole.eleveur,
      );

      expect(user.fullName, 'Test User');
      expect(user.city, 'Test City');
      expect(user.role, UserRole.eleveur);
      expect(user.id, isNotEmpty);
      expect(authService.isAuthenticated, true);
    });

    test('should login user successfully', () async {
      final user = await authService.login('test@example.com', 'password');

      expect(user.fullName, isNotEmpty);
      expect(authService.isAuthenticated, true);
    });

    test('should throw AuthException on empty email', () async {
      expect(
        () => authService.login('', 'password'),
        throwsA(isA<AuthException>()),
      );
    });

    test('should throw AuthException on empty password', () async {
      expect(
        () => authService.login('test@example.com', ''),
        throwsA(isA<AuthException>()),
      );
    });

    test('should logout user successfully', () async {
      // First login
      await authService.login('test@example.com', 'password');
      expect(authService.isAuthenticated, true);

      // Then logout
      await authService.logout();
      expect(authService.isAuthenticated, false);
    });

    test('should return current user after login', () async {
      await authService.login('test@example.com', 'password');

      final currentUser = await authService.getCurrentUser();

      expect(currentUser, isNotNull);
      expect(currentUser!.fullName, isNotEmpty);
    });

    test('should return null current user when not logged in', () async {
      final currentUser = await authService.getCurrentUser();
      expect(currentUser, isNull);
    });

    test('should register user with transporteur role', () async {
      final user = await authService.register(
        fullName: 'Transporter User',
        city: 'Casablanca',
        role: UserRole.transporteur,
      );

      expect(user.role, UserRole.transporteur);
    });
  });

  group('AuthException', () {
    test('should have correct message', () {
      final exception = AuthException('Test error message');
      expect(exception.message, 'Test error message');
      expect(exception.toString(), contains('Test error message'));
    });
  });
}
