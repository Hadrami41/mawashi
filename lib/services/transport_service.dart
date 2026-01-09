import 'dart:async';
import 'package:flutter/material.dart';
import '../models/models.dart';

/// Search criteria for finding transport
class SearchCriteria {
  final String? departure;
  final String? destination;
  final DateTime? date;
  final String? livestockType;
  final int? minCapacity;

  SearchCriteria({
    this.departure,
    this.destination,
    this.date,
    this.livestockType,
    this.minCapacity,
  });
}

/// Abstract transport service interface
abstract class TransportService {
  Future<List<Transporter>> getAvailableTransporters();
  Future<List<TransportVehicle>> searchVehicles(SearchCriteria criteria);
  Future<TransportRequest> createRequest(TransportRequest request);
  Future<List<Trip>> getActiveTrips();
  Future<List<Trip>> getSharedTransports();
  Future<List<TransportRequest>> getUserRequests(String userId);
}

/// Mock implementation of TransportService for development
class MockTransportService implements TransportService {
  // Mock data
  final List<Transporter> _mockTransporters = [
    Transporter(
      id: 't1',
      name: 'Ahmed El Mansour',
      capacity: '15 Têtes',
      rating: 4.8,
      tags: ['GRAND CAMION', 'AGRÉÉ'],
      iconColor: const Color(0xFF4ADE80),
      isAvailable: true,
      phoneNumber: '+212 6 12 34 56 78',
    ),
    Transporter(
      id: 't2',
      name: 'Transport Express Sarl',
      capacity: '8 Têtes',
      rating: 4.5,
      tags: ['CAMIONNETTE', 'RAPIDE'],
      iconColor: const Color(0xFF60A5FA),
      isAvailable: true,
      phoneNumber: '+212 6 98 76 54 32',
    ),
    Transporter(
      id: 't3',
      name: 'Mohamed Bétail Transport',
      capacity: '20 Têtes',
      rating: 4.9,
      tags: ['GRAND CAMION', 'PREMIUM'],
      iconColor: const Color(0xFFF59E0B),
      isAvailable: true,
      phoneNumber: '+212 6 55 44 33 22',
    ),
  ];

  final List<TransportVehicle> _mockVehicles = [
    TransportVehicle(
      id: 'v1',
      title: 'Camion 10t - Spécial Bétail',
      subtitle: 'Camion ventilé | Protection solaire',
      price: 1500,
      distanceKm: 5.2,
      status: VehicleStatus.available,
      statusColor: const Color(0xFF4ADE80),
      isUrgent: false,
    ),
    TransportVehicle(
      id: 'v2',
      title: 'Camion 8t - Standard',
      subtitle: 'Transport classique | Bâche',
      price: 850,
      distanceKm: 3.8,
      status: VehicleStatus.comingSoon,
      statusColor: const Color(0xFFFBBF24),
      isUrgent: false,
    ),
    TransportVehicle(
      id: 'v3',
      title: 'Transport Express - 5t',
      subtitle: 'Prêt au départ immédiat',
      price: 1900,
      distanceKm: 2.1,
      status: VehicleStatus.available,
      statusColor: const Color(0xFFEF4444),
      isUrgent: true,
    ),
  ];

  final List<Trip> _mockTrips = [
    Trip(
      id: 'trip1',
      transporterName: 'Ahmed El Mansour',
      departure: 'Marché de bétail Casablanca',
      destination: 'Lyon Slaughterhouse',
      startTime: DateTime.now().subtract(const Duration(minutes: 30)),
      progress: 0.7,
      status: TripStatus.inProgress,
      vehicleInfo: 'Camion 10t - Spécial Bétail',
      livestockCount: 12,
      livestockType: 'Cattle',
    ),
  ];

  @override
  Future<List<Transporter>> getAvailableTransporters() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_mockTransporters);
  }

  @override
  Future<List<TransportVehicle>> searchVehicles(SearchCriteria criteria) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 600));

    // In a real app, filter based on criteria
    return List.from(_mockVehicles);
  }

  @override
  Future<TransportRequest> createRequest(TransportRequest request) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Return the request with a generated ID
    return request.copyWith(id: 'req_${DateTime.now().millisecondsSinceEpoch}');
  }

  @override
  Future<List<Trip>> getActiveTrips() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 400));
    return List.from(
      _mockTrips.where((t) => t.status == TripStatus.inProgress),
    );
  }

  @override
  Future<List<Trip>> getSharedTransports() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      Trip(
        id: 'shared-1',
        transporterName: 'Dakar Express',
        departure: 'Dakar',
        destination: 'Thiès',
        startTime: DateTime.now().subtract(const Duration(hours: 2)),
        endTime: DateTime.now().add(const Duration(hours: 3)),
        progress: 0.7,
        status: TripStatus.inProgress,
        vehicleInfo: 'Camion 40 places',
        livestockCount: 28,
        livestockType: 'Moutons',
      ),
      Trip(
        id: 'shared-2',
        transporterName: 'Saint-Louis Trans',
        departure: 'Saint-Louis',
        destination: 'Louga',
        startTime: DateTime.now().subtract(const Duration(hours: 1)),
        endTime: DateTime.now().add(const Duration(hours: 4)),
        progress: 0.87,
        status: TripStatus.inProgress,
        vehicleInfo: 'Camion 40 places',
        livestockCount: 35,
        livestockType: 'Bœufs',
      ),
    ];
  }

  @override
  Future<List<TransportRequest>> getUserRequests(String userId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Return mock requests
    return [
      TransportRequest(
        id: 'req1',
        departure: 'Ferme Oued',
        destination: 'Marché Central',
        date: DateTime.now().add(const Duration(days: 2)),
        livestockCount: 5,
        livestockType: 'Moutons',
        status: RequestStatus.pending,
        userId: userId,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
    ];
  }
}
