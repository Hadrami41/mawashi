import 'package:flutter_test/flutter_test.dart';
import 'package:mawashi/providers/auth_provider.dart';
import 'package:mawashi/services/auth_service.dart';
import 'package:mawashi/services/storage_service.dart';
import 'package:mawashi/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('AuthProvider', () {
    late AuthProvider authProvider;
    late MockAuthService authService;
    late StorageService storageService;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      authService = MockAuthService();
      storageService = StorageService(prefs);
      authProvider = AuthProvider(
        authService: authService,
        storageService: storageService,
      );

      // Wait for initialization
      await Future.delayed(const Duration(milliseconds: 500));
    });

    test('should start with initial or unauthenticated status', () {
      expect(
        authProvider.status,
        anyOf(AuthStatus.initial, AuthStatus.unauthenticated),
      );
      expect(authProvider.isAuthenticated, false);
    });

    test('should register user and update state', () async {
      final success = await authProvider.register(
        fullName: 'Test User',
        city: 'Test City',
        role: UserRole.eleveur,
      );

      expect(success, true);
      expect(authProvider.isAuthenticated, true);
      expect(authProvider.currentUser, isNotNull);
      expect(authProvider.currentUser!.fullName, 'Test User');
      expect(authProvider.status, AuthStatus.authenticated);
    });

    test('should login user and update state', () async {
      final success = await authProvider.login('test@example.com', 'password');

      expect(success, true);
      expect(authProvider.isAuthenticated, true);
      expect(authProvider.currentUser, isNotNull);
    });

    test('should logout and clear state', () async {
      // First login
      await authProvider.login('test@example.com', 'password');
      expect(authProvider.isAuthenticated, true);

      // Then logout
      await authProvider.logout();

      expect(authProvider.isAuthenticated, false);
      expect(authProvider.currentUser, isNull);
      expect(authProvider.status, AuthStatus.unauthenticated);
    });

    test('should update profile', () async {
      await authProvider.register(
        fullName: 'Original Name',
        city: 'Original City',
        role: UserRole.eleveur,
      );

      final success = await authProvider.updateProfile(
        fullName: 'Updated Name',
      );

      expect(success, true);
      expect(authProvider.currentUser!.fullName, 'Updated Name');
    });

    test('should clear error message', () async {
      authProvider.clearError();
      expect(authProvider.errorMessage, isNull);
    });

    test('should notify listeners on state change', () async {
      int notifyCount = 0;
      authProvider.addListener(() => notifyCount++);

      await authProvider.register(
        fullName: 'Test',
        city: 'City',
        role: UserRole.eleveur,
      );

      expect(notifyCount, greaterThan(0));
    });

    test('should set loading status during registration', () async {
      bool wasLoading = false;

      authProvider.addListener(() {
        if (authProvider.isLoading) wasLoading = true;
      });

      await authProvider.register(
        fullName: 'Test',
        city: 'City',
        role: UserRole.transporteur,
      );

      expect(wasLoading, true);
      expect(authProvider.isLoading, false); // Should finish loading
    });
  });
}
