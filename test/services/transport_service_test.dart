import 'package:flutter_test/flutter_test.dart';
import 'package:mawashi/services/transport_service.dart';
import 'package:mawashi/models/transport_vehicle.dart';
import 'package:mawashi/models/transport_request.dart';
import 'package:mawashi/models/trip.dart';

void main() {
  group('MockTransportService', () {
    late MockTransportService transportService;

    setUp(() {
      transportService = MockTransportService();
    });

    test('should return available transporters', () async {
      final transporters = await transportService.getAvailableTransporters();

      expect(transporters, isNotEmpty);
      expect(transporters.first.name, isNotEmpty);
      expect(transporters.first.rating, greaterThan(0));
    });

    test('should search vehicles with criteria', () async {
      final criteria = SearchCriteria(
        departure: 'Casablanca',
        destination: 'Rabat',
      );

      final vehicles = await transportService.searchVehicles(criteria);

      expect(vehicles, isNotEmpty);
      expect(vehicles.first.title, isNotEmpty);
      expect(vehicles.first.price, greaterThan(0));
    });

    test('should return vehicles with correct status', () async {
      final vehicles = await transportService.searchVehicles(SearchCriteria());

      final availableVehicles = vehicles.where(
        (v) => v.status == VehicleStatus.available,
      );

      expect(availableVehicles, isNotEmpty);
    });

    test('should create transport request', () async {
      final request = await transportService.createRequest(
        TransportRequest(
          id: '',
          departure: 'Ferme A',
          destination: 'Marché B',
          date: DateTime.now(),
          livestockCount: 10,
          livestockType: 'Moutons',
          createdAt: DateTime.now(),
        ),
      );

      expect(request.id, isNotEmpty);
      expect(request.departure, 'Ferme A');
      expect(request.destination, 'Marché B');
    });

    test('should return active trips', () async {
      final trips = await transportService.getActiveTrips();

      expect(trips, isNotEmpty);
      for (final trip in trips) {
        expect(trip.status, TripStatus.inProgress);
      }
    });

    test('should return user requests', () async {
      final requests = await transportService.getUserRequests('user123');

      expect(requests, isNotEmpty);
      expect(requests.first.id, isNotEmpty);
    });
  });

  group('SearchCriteria', () {
    test('should create with all fields', () {
      final criteria = SearchCriteria(
        departure: 'City A',
        destination: 'City B',
        date: DateTime(2024, 6, 15),
        livestockType: 'Cattle',
        minCapacity: 10,
      );

      expect(criteria.departure, 'City A');
      expect(criteria.destination, 'City B');
      expect(criteria.date, DateTime(2024, 6, 15));
      expect(criteria.livestockType, 'Cattle');
      expect(criteria.minCapacity, 10);
    });

    test('should allow null fields', () {
      final criteria = SearchCriteria();

      expect(criteria.departure, isNull);
      expect(criteria.destination, isNull);
      expect(criteria.date, isNull);
    });
  });
}
