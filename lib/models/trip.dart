import 'package:equatable/equatable.dart';

/// Trip status
enum TripStatus { scheduled, inProgress, completed }

/// Trip model representing an active or completed transport trip
class Trip extends Equatable {
  final String id;
  final String transporterName;
  final String departure;
  final String destination;
  final DateTime startTime;
  final DateTime? endTime;
  final double progress; // 0.0 to 1.0
  final TripStatus status;
  final String? vehicleInfo;
  final int? livestockCount;
  final String? livestockType;

  const Trip({
    required this.id,
    required this.transporterName,
    required this.departure,
    required this.destination,
    required this.startTime,
    this.endTime,
    this.progress = 0.0,
    this.status = TripStatus.scheduled,
    this.vehicleInfo,
    this.livestockCount,
    this.livestockType,
  });

  /// Check if trip is currently active
  bool get isActive => status == TripStatus.inProgress;

  /// Check if trip is completed
  bool get isCompleted => status == TripStatus.completed;

  /// Get estimated time remaining in minutes (mock calculation)
  int get estimatedMinutesRemaining {
    if (isCompleted) return 0;
    return ((1.0 - progress) * 60).round(); // Assume 60 min total for demo
  }

  /// Get status display string in French
  String get statusTextFr {
    switch (status) {
      case TripStatus.scheduled:
        return 'Programmé';
      case TripStatus.inProgress:
        return 'En cours';
      case TripStatus.completed:
        return 'Terminé';
    }
  }

  /// Get estimated time remaining display string
  String get estimatedTimeRemaining {
    if (isCompleted) return 'Terminé';
    final mins = estimatedMinutesRemaining;
    if (mins < 60) return '$mins mins restants';
    final hours = mins ~/ 60;
    return '${hours}h restants';
  }

  /// Get formatted start time (HH:mm)
  String get formattedStartTime {
    return '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}';
  }

  /// Get formatted end time (HH:mm)
  String get formattedEndTime {
    if (endTime == null) return '--:--';
    return '${endTime!.hour.toString().padLeft(2, '0')}:${endTime!.minute.toString().padLeft(2, '0')}';
  }

  /// Create a Trip from JSON map
  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      id: json['id'] as String,
      transporterName: json['transporterName'] as String,
      departure: json['departure'] as String,
      destination: json['destination'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: json['endTime'] != null
          ? DateTime.parse(json['endTime'] as String)
          : null,
      progress: (json['progress'] as num?)?.toDouble() ?? 0.0,
      status: TripStatus.values.firstWhere(
        (s) => s.name == json['status'],
        orElse: () => TripStatus.scheduled,
      ),
      vehicleInfo: json['vehicleInfo'] as String?,
      livestockCount: json['livestockCount'] as int?,
      livestockType: json['livestockType'] as String?,
    );
  }

  /// Convert Trip to JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'transporterName': transporterName,
      'departure': departure,
      'destination': destination,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'progress': progress,
      'status': status.name,
      'vehicleInfo': vehicleInfo,
      'livestockCount': livestockCount,
      'livestockType': livestockType,
    };
  }

  /// Create a copy with updated fields
  Trip copyWith({
    String? id,
    String? transporterName,
    String? departure,
    String? destination,
    DateTime? startTime,
    DateTime? endTime,
    double? progress,
    TripStatus? status,
    String? vehicleInfo,
    int? livestockCount,
    String? livestockType,
  }) {
    return Trip(
      id: id ?? this.id,
      transporterName: transporterName ?? this.transporterName,
      departure: departure ?? this.departure,
      destination: destination ?? this.destination,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      progress: progress ?? this.progress,
      status: status ?? this.status,
      vehicleInfo: vehicleInfo ?? this.vehicleInfo,
      livestockCount: livestockCount ?? this.livestockCount,
      livestockType: livestockType ?? this.livestockType,
    );
  }

  @override
  List<Object?> get props => [
    id,
    transporterName,
    departure,
    destination,
    startTime,
    endTime,
    progress,
    status,
    vehicleInfo,
    livestockCount,
    livestockType,
  ];

  @override
  String toString() =>
      'Trip(id: $id, from: $departure, to: $destination, progress: ${(progress * 100).toInt()}%)';
}
