import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';

/// Authentication status
enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

/// Provider for managing authentication state
class AuthProvider extends ChangeNotifier {
  final AuthService _authService;
  final StorageService _storageService;

  User? _currentUser;
  AuthStatus _status = AuthStatus.initial;
  String? _errorMessage;

  AuthProvider({
    required AuthService authService,
    required StorageService storageService,
  }) : _authService = authService,
       _storageService = storageService {
    _init();
  }

  // Getters
  User? get currentUser => _currentUser;
  AuthStatus get status => _status;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _status == AuthStatus.authenticated;
  bool get isLoading => _status == AuthStatus.loading;

  /// Initialize auth state from storage
  Future<void> _init() async {
    _status = AuthStatus.loading;
    notifyListeners();

    try {
      // Try to get user from local storage
      final storedUser = _storageService.getUser();
      if (storedUser != null) {
        _currentUser = storedUser;
        _status = AuthStatus.authenticated;
      } else {
        _status = AuthStatus.unauthenticated;
      }
    } catch (e) {
      _status = AuthStatus.unauthenticated;
    }

    notifyListeners();
  }

  /// Register a new user
  Future<bool> register({
    required String fullName,
    required String city,
    required UserRole role,
  }) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await _authService.register(
        fullName: fullName,
        city: city,
        role: role,
      );

      _currentUser = user;
      await _storageService.saveUser(user);
      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } on AuthException catch (e) {
      _errorMessage = e.message;
      _status = AuthStatus.error;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
      _status = AuthStatus.error;
      notifyListeners();
      return false;
    }
  }

  /// Login with email and password
  Future<bool> login(String email, String password) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await _authService.login(email, password);
      _currentUser = user;
      await _storageService.saveUser(user);
      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } on AuthException catch (e) {
      _errorMessage = e.message;
      _status = AuthStatus.error;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
      _status = AuthStatus.error;
      notifyListeners();
      return false;
    }
  }

  /// Logout current user
  Future<void> logout() async {
    _status = AuthStatus.loading;
    notifyListeners();

    try {
      await _authService.logout();
      await _storageService.removeUser();
      _currentUser = null;
      _status = AuthStatus.unauthenticated;
    } catch (e) {
      // Even if logout fails, clear local state
      _currentUser = null;
      _status = AuthStatus.unauthenticated;
    }

    notifyListeners();
  }

  /// Update user profile
  Future<bool> updateProfile({
    String? fullName,
    String? city,
    String? avatarUrl,
  }) async {
    if (_currentUser == null) return false;

    try {
      final updatedUser = _currentUser!.copyWith(
        fullName: fullName,
        city: city,
        avatarUrl: avatarUrl,
      );

      _currentUser = updatedUser;
      await _storageService.saveUser(updatedUser);
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Clear any error message
  void clearError() {
    _errorMessage = null;
    if (_status == AuthStatus.error) {
      _status = _currentUser != null
          ? AuthStatus.authenticated
          : AuthStatus.unauthenticated;
    }
    notifyListeners();
  }
}
