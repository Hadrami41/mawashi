import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../services/transport_service.dart';

/// Loading status for transport operations
enum TransportLoadingStatus { initial, loading, loaded, error }

/// Provider for managing transport-related state
class TransportProvider extends ChangeNotifier {
  final TransportService _transportService;

  // State
  List<Transporter> _transporters = [];
  List<TransportVehicle> _vehicles = [];
  List<Trip> _activeTrips = [];
  List<Trip> _sharedTransports = [];
  List<TransportRequest> _userRequests = [];

  TransportLoadingStatus _transportersStatus = TransportLoadingStatus.initial;
  TransportLoadingStatus _vehiclesStatus = TransportLoadingStatus.initial;
  TransportLoadingStatus _tripsStatus = TransportLoadingStatus.initial;

  String? _errorMessage;

  TransportProvider({required TransportService transportService})
    : _transportService = transportService;

  // Getters
  List<Transporter> get transporters => List.unmodifiable(_transporters);
  List<TransportVehicle> get vehicles => List.unmodifiable(_vehicles);
  List<Trip> get activeTrips => List.unmodifiable(_activeTrips);
  List<Trip> get sharedTransports => List.unmodifiable(_sharedTransports);
  List<TransportRequest> get userRequests => List.unmodifiable(_userRequests);

  TransportLoadingStatus get transportersStatus => _transportersStatus;
  TransportLoadingStatus get vehiclesStatus => _vehiclesStatus;
  TransportLoadingStatus get tripsStatus => _tripsStatus;

  String? get errorMessage => _errorMessage;

  bool get isLoadingTransporters =>
      _transportersStatus == TransportLoadingStatus.loading;
  bool get isLoadingVehicles =>
      _vehiclesStatus == TransportLoadingStatus.loading;
  bool get isLoadingTrips => _tripsStatus == TransportLoadingStatus.loading;

  /// Get the current active trip (first one)
  Trip? get currentTrip => _activeTrips.isNotEmpty ? _activeTrips.first : null;

  /// Load available transporters
  Future<void> loadTransporters() async {
    _transportersStatus = TransportLoadingStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _transporters = await _transportService.getAvailableTransporters();
      _transportersStatus = TransportLoadingStatus.loaded;
    } catch (e) {
      _errorMessage = 'Failed to load transporters';
      _transportersStatus = TransportLoadingStatus.error;
    }

    notifyListeners();
  }

  /// Search for vehicles based on criteria
  Future<void> searchVehicles({
    String? departure,
    String? destination,
    DateTime? date,
    String? livestockType,
  }) async {
    _vehiclesStatus = TransportLoadingStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final criteria = SearchCriteria(
        departure: departure,
        destination: destination,
        date: date,
        livestockType: livestockType,
      );

      _vehicles = await _transportService.searchVehicles(criteria);
      _vehiclesStatus = TransportLoadingStatus.loaded;
    } catch (e) {
      _errorMessage = 'Failed to search vehicles';
      _vehiclesStatus = TransportLoadingStatus.error;
    }

    notifyListeners();
  }

  /// Load active trips
  Future<void> loadActiveTrips() async {
    _tripsStatus = TransportLoadingStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _activeTrips = await _transportService.getActiveTrips();
      _tripsStatus = TransportLoadingStatus.loaded;
    } catch (e) {
      _errorMessage = 'Failed to load trips';
      _tripsStatus = TransportLoadingStatus.error;
    }

    notifyListeners();
  }

  /// Load shared transports (Groupage)
  Future<void> loadSharedTransports() async {
    _errorMessage = null;
    notifyListeners();

    try {
      _sharedTransports = await _transportService.getSharedTransports();
    } catch (e) {
      _errorMessage = 'Failed to load shared transports';
    }

    notifyListeners();
  }

  /// Create a new transport request
  Future<TransportRequest?> createRequest({
    required String departure,
    required String destination,
    required DateTime date,
    required int livestockCount,
    required String livestockType,
    String? notes,
    String? userId,
  }) async {
    try {
      final request = TransportRequest(
        id: '', // Will be assigned by service
        departure: departure,
        destination: destination,
        date: date,
        livestockCount: livestockCount,
        livestockType: livestockType,
        notes: notes,
        userId: userId,
        createdAt: DateTime.now(),
      );

      final createdRequest = await _transportService.createRequest(request);
      _userRequests.add(createdRequest);
      notifyListeners();
      return createdRequest;
    } catch (e) {
      _errorMessage = 'Failed to create request';
      notifyListeners();
      return null;
    }
  }

  /// Load user's transport requests
  Future<void> loadUserRequests(String userId) async {
    try {
      _userRequests = await _transportService.getUserRequests(userId);
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load requests';
      notifyListeners();
    }
  }

  /// Refresh all data
  Future<void> refreshAll() async {
    await Future.wait([loadTransporters(), loadActiveTrips()]);
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Clear all data (on logout)
  void clear() {
    _transporters = [];
    _vehicles = [];
    _activeTrips = [];
    _userRequests = [];
    _transportersStatus = TransportLoadingStatus.initial;
    _vehiclesStatus = TransportLoadingStatus.initial;
    _tripsStatus = TransportLoadingStatus.initial;
    _errorMessage = null;
    notifyListeners();
  }
}
