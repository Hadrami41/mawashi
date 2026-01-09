import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

/// Service for managing local storage operations
class StorageService {
  final SharedPreferences _prefs;

  static const String _userKey = 'current_user';
  static const String _tokenKey = 'auth_token';
  static const String _onboardingKey = 'onboarding_completed';

  StorageService(this._prefs);

  /// Save user to local storage
  Future<void> saveUser(User user) async {
    final jsonString = jsonEncode(user.toJson());
    await _prefs.setString(_userKey, jsonString);
  }

  /// Get current user from local storage
  User? getUser() {
    final jsonString = _prefs.getString(_userKey);
    if (jsonString == null) return null;

    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return User.fromJson(json);
    } catch (e) {
      return null;
    }
  }

  /// Remove user from local storage
  Future<void> removeUser() async {
    await _prefs.remove(_userKey);
  }

  /// Save authentication token
  Future<void> saveToken(String token) async {
    await _prefs.setString(_tokenKey, token);
  }

  /// Get authentication token
  String? getToken() {
    return _prefs.getString(_tokenKey);
  }

  /// Remove authentication token
  Future<void> removeToken() async {
    await _prefs.remove(_tokenKey);
  }

  /// Check if user has completed onboarding
  bool hasCompletedOnboarding() {
    return _prefs.getBool(_onboardingKey) ?? false;
  }

  /// Mark onboarding as completed
  Future<void> setOnboardingCompleted(bool completed) async {
    await _prefs.setBool(_onboardingKey, completed);
  }

  /// Clear all stored data
  Future<void> clear() async {
    await _prefs.clear();
  }
}
