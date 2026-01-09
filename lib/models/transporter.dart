import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Transporter model representing a transport service provider
class Transporter extends Equatable {
  final String id;
  final String name;
  final String capacity;
  final double rating;
  final List<String> tags;
  final Color iconColor;
  final bool isAvailable;
  final String? phoneNumber;
  final String? description;

  const Transporter({
    required this.id,
    required this.name,
    required this.capacity,
    required this.rating,
    required this.tags,
    required this.iconColor,
    this.isAvailable = true,
    this.phoneNumber,
    this.description,
  });

  /// Create a Transporter from JSON map
  factory Transporter.fromJson(Map<String, dynamic> json) {
    return Transporter(
      id: json['id'] as String,
      name: json['name'] as String,
      capacity: json['capacity'] as String,
      rating: (json['rating'] as num).toDouble(),
      tags: List<String>.from(json['tags'] as List),
      iconColor: Color(json['iconColor'] as int),
      isAvailable: json['isAvailable'] as bool? ?? true,
      phoneNumber: json['phoneNumber'] as String?,
      description: json['description'] as String?,
    );
  }

  /// Convert Transporter to JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'capacity': capacity,
      'rating': rating,
      'tags': tags,
      'iconColor': iconColor.toARGB32(),
      'isAvailable': isAvailable,
      'phoneNumber': phoneNumber,
      'description': description,
    };
  }

  /// Create a copy of Transporter with updated fields
  Transporter copyWith({
    String? id,
    String? name,
    String? capacity,
    double? rating,
    List<String>? tags,
    Color? iconColor,
    bool? isAvailable,
    String? phoneNumber,
    String? description,
  }) {
    return Transporter(
      id: id ?? this.id,
      name: name ?? this.name,
      capacity: capacity ?? this.capacity,
      rating: rating ?? this.rating,
      tags: tags ?? this.tags,
      iconColor: iconColor ?? this.iconColor,
      isAvailable: isAvailable ?? this.isAvailable,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      description: description ?? this.description,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    capacity,
    rating,
    tags,
    iconColor,
    isAvailable,
    phoneNumber,
    description,
  ];

  @override
  String toString() => 'Transporter(id: $id, name: $name, rating: $rating)';
}
