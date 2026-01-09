import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Vehicle availability status
enum VehicleStatus { available, comingSoon, busy }

/// TransportVehicle model representing a transport vehicle
class TransportVehicle extends Equatable {
  final String id;
  final String title;
  final String subtitle;
  final double price;
  final String currency;
  final double distanceKm;
  final VehicleStatus status;
  final String? imageAsset;
  final bool isUrgent;
  final Color statusColor;

  const TransportVehicle({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.price,
    this.currency = 'MAD',
    required this.distanceKm,
    required this.status,
    this.imageAsset,
    this.isUrgent = false,
    required this.statusColor,
  });

  /// Get formatted price string
  String get formattedPrice => '${price.toStringAsFixed(0)} $currency';

  /// Get formatted distance string
  String get formattedDistance => '${distanceKm.toStringAsFixed(1)} km';

  /// Get status display string
  String get statusText {
    switch (status) {
      case VehicleStatus.available:
        return 'DISPONIBLE (متاح)';
      case VehicleStatus.comingSoon:
        return 'DANS 30 MIN';
      case VehicleStatus.busy:
        return 'OCCUPÉ';
    }
  }

  /// Create a TransportVehicle from JSON map
  factory TransportVehicle.fromJson(Map<String, dynamic> json) {
    return TransportVehicle(
      id: json['id'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      price: (json['price'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'MAD',
      distanceKm: (json['distanceKm'] as num).toDouble(),
      status: VehicleStatus.values.firstWhere(
        (s) => s.name == json['status'],
        orElse: () => VehicleStatus.available,
      ),
      imageAsset: json['imageAsset'] as String?,
      isUrgent: json['isUrgent'] as bool? ?? false,
      statusColor: Color(json['statusColor'] as int),
    );
  }

  /// Convert TransportVehicle to JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'price': price,
      'currency': currency,
      'distanceKm': distanceKm,
      'status': status.name,
      'imageAsset': imageAsset,
      'isUrgent': isUrgent,
      'statusColor': statusColor.toARGB32(),
    };
  }

  /// Create a copy with updated fields
  TransportVehicle copyWith({
    String? id,
    String? title,
    String? subtitle,
    double? price,
    String? currency,
    double? distanceKm,
    VehicleStatus? status,
    String? imageAsset,
    bool? isUrgent,
    Color? statusColor,
  }) {
    return TransportVehicle(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      distanceKm: distanceKm ?? this.distanceKm,
      status: status ?? this.status,
      imageAsset: imageAsset ?? this.imageAsset,
      isUrgent: isUrgent ?? this.isUrgent,
      statusColor: statusColor ?? this.statusColor,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    subtitle,
    price,
    currency,
    distanceKm,
    status,
    imageAsset,
    isUrgent,
    statusColor,
  ];

  @override
  String toString() =>
      'TransportVehicle(id: $id, title: $title, price: $formattedPrice)';
}
