import 'package:equatable/equatable.dart';

/// Transport request status
enum RequestStatus { pending, confirmed, inProgress, completed, cancelled }

/// TransportRequest model representing a transport request
class TransportRequest extends Equatable {
  final String id;
  final String departure;
  final String destination;
  final DateTime date;
  final int livestockCount;
  final String livestockType;
  final RequestStatus status;
  final String? notes;
  final String? userId;
  final String? transporterId;
  final DateTime createdAt;

  const TransportRequest({
    required this.id,
    required this.departure,
    required this.destination,
    required this.date,
    required this.livestockCount,
    required this.livestockType,
    this.status = RequestStatus.pending,
    this.notes,
    this.userId,
    this.transporterId,
    required this.createdAt,
  });

  /// Get status display string in French
  String get statusTextFr {
    switch (status) {
      case RequestStatus.pending:
        return 'En attente';
      case RequestStatus.confirmed:
        return 'Confirmé';
      case RequestStatus.inProgress:
        return 'En cours';
      case RequestStatus.completed:
        return 'Terminé';
      case RequestStatus.cancelled:
        return 'Annulé';
    }
  }

  /// Get status display string in Arabic
  String get statusTextAr {
    switch (status) {
      case RequestStatus.pending:
        return 'قيد الانتظار';
      case RequestStatus.confirmed:
        return 'مؤكد';
      case RequestStatus.inProgress:
        return 'جاري';
      case RequestStatus.completed:
        return 'مكتمل';
      case RequestStatus.cancelled:
        return 'ملغى';
    }
  }

  /// Create a TransportRequest from JSON map
  factory TransportRequest.fromJson(Map<String, dynamic> json) {
    return TransportRequest(
      id: json['id'] as String,
      departure: json['departure'] as String,
      destination: json['destination'] as String,
      date: DateTime.parse(json['date'] as String),
      livestockCount: json['livestockCount'] as int,
      livestockType: json['livestockType'] as String,
      status: RequestStatus.values.firstWhere(
        (s) => s.name == json['status'],
        orElse: () => RequestStatus.pending,
      ),
      notes: json['notes'] as String?,
      userId: json['userId'] as String?,
      transporterId: json['transporterId'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  /// Convert TransportRequest to JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'departure': departure,
      'destination': destination,
      'date': date.toIso8601String(),
      'livestockCount': livestockCount,
      'livestockType': livestockType,
      'status': status.name,
      'notes': notes,
      'userId': userId,
      'transporterId': transporterId,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Create a copy with updated fields
  TransportRequest copyWith({
    String? id,
    String? departure,
    String? destination,
    DateTime? date,
    int? livestockCount,
    String? livestockType,
    RequestStatus? status,
    String? notes,
    String? userId,
    String? transporterId,
    DateTime? createdAt,
  }) {
    return TransportRequest(
      id: id ?? this.id,
      departure: departure ?? this.departure,
      destination: destination ?? this.destination,
      date: date ?? this.date,
      livestockCount: livestockCount ?? this.livestockCount,
      livestockType: livestockType ?? this.livestockType,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      userId: userId ?? this.userId,
      transporterId: transporterId ?? this.transporterId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    departure,
    destination,
    date,
    livestockCount,
    livestockType,
    status,
    notes,
    userId,
    transporterId,
    createdAt,
  ];

  @override
  String toString() =>
      'TransportRequest(id: $id, from: $departure, to: $destination, status: ${status.name})';
}
