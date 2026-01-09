import 'package:equatable/equatable.dart';

/// Represents a user role in the application
enum UserRole { eleveur, transporteur }

/// User model representing a registered user in the system
class User extends Equatable {
  final String id;
  final String fullName;
  final String city;
  final UserRole role;
  final String? avatarUrl;
  final DateTime createdAt;

  const User({
    required this.id,
    required this.fullName,
    required this.city,
    required this.role,
    this.avatarUrl,
    required this.createdAt,
  });

  /// Create a User from JSON map
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      fullName: json['fullName'] as String,
      city: json['city'] as String,
      role: UserRole.values.firstWhere(
        (r) => r.name == json['role'],
        orElse: () => UserRole.eleveur,
      ),
      avatarUrl: json['avatarUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  /// Convert User to JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'city': city,
      'role': role.name,
      'avatarUrl': avatarUrl,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Create a copy of User with updated fields
  User copyWith({
    String? id,
    String? fullName,
    String? city,
    UserRole? role,
    String? avatarUrl,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      city: city ?? this.city,
      role: role ?? this.role,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [id, fullName, city, role, avatarUrl, createdAt];

  @override
  String toString() => 'User(id: $id, fullName: $fullName, role: ${role.name})';
}
