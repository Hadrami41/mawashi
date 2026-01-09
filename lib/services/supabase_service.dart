import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user.dart' as app_models;

/// Supabase service for backend operations
class SupabaseService {
  static SupabaseClient get client => Supabase.instance.client;

  /// Initialize Supabase with the provided URL and anon key
  static Future<void> initialize({
    required String url,
    required String anonKey,
  }) async {
    await Supabase.initialize(url: url, anonKey: anonKey);
  }

  /// Check if user is authenticated
  static bool get isAuthenticated => client.auth.currentUser != null;

  /// Get current user ID
  static String? get currentUserId => client.auth.currentUser?.id;

  /// Sign up with email and password
  static Future<AuthResponse> signUp({
    required String email,
    required String password,
    Map<String, dynamic>? data,
  }) async {
    return await client.auth.signUp(
      email: email,
      password: password,
      data: data,
    );
  }

  /// Sign in with email and password
  static Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  /// Sign out
  static Future<void> signOut() async {
    await client.auth.signOut();
  }

  /// Get user profile from database
  static Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    final response = await client
        .from('profiles')
        .select()
        .eq('id', userId)
        .single();
    return response;
  }

  /// Create or update user profile
  static Future<void> upsertUserProfile({
    required String userId,
    required String fullName,
    required String city,
    required app_models.UserRole role,
    String? avatarUrl,
  }) async {
    await client.from('profiles').upsert({
      'id': userId,
      'full_name': fullName,
      'city': city,
      'role': role.name,
      'avatar_url': avatarUrl,
      'updated_at': DateTime.now().toIso8601String(),
    });
  }

  /// Get transporters from database
  static Future<List<Map<String, dynamic>>> getTransporters() async {
    final response = await client
        .from('transporters')
        .select()
        .eq('is_available', true)
        .order('rating', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  /// Get transport vehicles
  static Future<List<Map<String, dynamic>>> getVehicles({
    String? departure,
    String? destination,
  }) async {
    var query = client.from('vehicles').select();

    if (departure != null && departure.isNotEmpty) {
      query = query.ilike('departure', '%$departure%');
    }
    if (destination != null && destination.isNotEmpty) {
      query = query.ilike('destination', '%$destination%');
    }

    final response = await query.order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  /// Create transport request
  static Future<Map<String, dynamic>> createTransportRequest({
    required String userId,
    required String departure,
    required String destination,
    required DateTime date,
    required int livestockCount,
    required String livestockType,
    String? notes,
  }) async {
    final response = await client
        .from('transport_requests')
        .insert({
          'user_id': userId,
          'departure': departure,
          'destination': destination,
          'date': date.toIso8601String(),
          'livestock_count': livestockCount,
          'livestock_type': livestockType,
          'notes': notes,
          'status': 'pending',
          'created_at': DateTime.now().toIso8601String(),
        })
        .select()
        .single();

    return response;
  }

  /// Get user's transport requests
  static Future<List<Map<String, dynamic>>> getUserRequests(
    String userId,
  ) async {
    final response = await client
        .from('transport_requests')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  /// Get active trips
  static Future<List<Map<String, dynamic>>> getActiveTrips(
    String userId,
  ) async {
    final response = await client
        .from('trips')
        .select()
        .eq('user_id', userId)
        .eq('status', 'in_progress')
        .order('start_time', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }
}
