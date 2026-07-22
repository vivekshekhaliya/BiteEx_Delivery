import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import '../repository/rider_repository.dart';
import 'location_service.dart';

class RiderLocationTracker {
  static final RiderLocationTracker _instance = RiderLocationTracker._internal();
  factory RiderLocationTracker() => _instance;
  RiderLocationTracker._internal();

  Timer? _timer;
  int? _currentOrderId;
  bool _isTracking = false;

  bool get isTracking => _isTracking;
  int? get currentOrderId => _currentOrderId;

  void startTracking(int? orderId) {
    if (_isTracking && _currentOrderId == orderId) {
      return;
    }

    _currentOrderId = orderId;
    _isTracking = true;

    debugPrint('📍 RiderLocationTracker: Tracking started for orderId: $orderId');

    // Update location immediately on start
    _sendLocationUpdate();

    // Schedule 30-second periodic updates
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 30), (_) {
      _sendLocationUpdate();
    });
  }

  void stopTracking() {
    if (!_isTracking) return;

    _timer?.cancel();
    _timer = null;
    _isTracking = false;
    _currentOrderId = null;
    debugPrint('🛑 RiderLocationTracker: Tracking stopped');
  }

  Future<void> _sendLocationUpdate() async {
    try {
      Position? position = await LocationService.getCurrentLocation();
      if (position != null) {
        await RiderRepository.updateLocation(
          latitude: position.latitude,
          longitude: position.longitude,
          orderId: _currentOrderId,
        );
        debugPrint(
          '✅ Location updated -> lat: ${position.latitude}, lng: ${position.longitude}, orderId: $_currentOrderId',
        );
      } else {
        debugPrint('⚠️ Could not retrieve current GPS position for location update');
      }
    } catch (e) {
      debugPrint('❌ Failed to update rider location: $e');
    }
  }
}
