import 'package:flutter_test/flutter_test.dart';
import 'package:mawashi/providers/transport_provider.dart';
import 'package:mawashi/services/transport_service.dart';
import 'package:mawashi/models/trip.dart';

void main() {
  group('TransportProvider', () {
    late TransportProvider transportProvider;
    late MockTransportService transportService;

    setUp(() {
      transportService = MockTransportService();
      transportProvider = TransportProvider(transportService: transportService);
    });

    test('should start with initial status', () {
      expect(
        transportProvider.transportersStatus,
        TransportLoadingStatus.initial,
      );
      expect(transportProvider.vehiclesStatus, TransportLoadingStatus.initial);
      expect(transportProvider.tripsStatus, TransportLoadingStatus.initial);
    });

    test('should load transporters successfully', () async {
      await transportProvider.loadTransporters();

      expect(transportProvider.transporters, isNotEmpty);
      expect(
        transportProvider.transportersStatus,
        TransportLoadingStatus.loaded,
      );
    });

    test('should search vehicles successfully', () async {
      await transportProvider.searchVehicles(
        departure: 'City A',
        destination: 'City B',
      );

      expect(transportProvider.vehicles, isNotEmpty);
      expect(transportProvider.vehiclesStatus, TransportLoadingStatus.loaded);
    });

    test('should load active trips', () async {
      await transportProvider.loadActiveTrips();

      expect(transportProvider.tripsStatus, TransportLoadingStatus.loaded);
      // May or may not have active trips depending on mock data
    });

    test('should get current trip', () async {
      await transportProvider.loadActiveTrips();

      if (transportProvider.activeTrips.isNotEmpty) {
        expect(transportProvider.currentTrip, isNotNull);
        expect(transportProvider.currentTrip!.status, TripStatus.inProgress);
      }
    });

    test('should create transport request', () async {
      final request = await transportProvider.createRequest(
        departure: 'Farm A',
        destination: 'Market B',
        date: DateTime.now(),
        livestockCount: 5,
        livestockType: 'Sheep',
        userId: 'user123',
      );

      expect(request, isNotNull);
      expect(request!.departure, 'Farm A');
      expect(transportProvider.userRequests, contains(request));
    });

    test('should clear all data', () async {
      await transportProvider.loadTransporters();
      await transportProvider.loadActiveTrips();

      transportProvider.clear();

      expect(transportProvider.transporters, isEmpty);
      expect(transportProvider.vehicles, isEmpty);
      expect(transportProvider.activeTrips, isEmpty);
      expect(
        transportProvider.transportersStatus,
        TransportLoadingStatus.initial,
      );
    });

    test('should refresh all data', () async {
      await transportProvider.refreshAll();

      expect(
        transportProvider.transportersStatus,
        TransportLoadingStatus.loaded,
      );
      expect(transportProvider.tripsStatus, TransportLoadingStatus.loaded);
    });

    test('should notify listeners on data change', () async {
      int notifyCount = 0;
      transportProvider.addListener(() => notifyCount++);

      await transportProvider.loadTransporters();

      expect(notifyCount, greaterThan(0));
    });

    test('should set loading status during fetch', () async {
      bool wasLoading = false;

      transportProvider.addListener(() {
        if (transportProvider.isLoadingTransporters) wasLoading = true;
      });

      await transportProvider.loadTransporters();

      expect(wasLoading, true);
      expect(transportProvider.isLoadingTransporters, false);
    });

    test('should clear error message', () {
      transportProvider.clearError();
      expect(transportProvider.errorMessage, isNull);
    });
  });
}
