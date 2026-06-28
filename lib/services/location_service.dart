import 'dart:async';
import 'dart:math';

import 'package:geolocator/geolocator.dart';

enum LocationStatus {
  serviceDisabled,
  permissionDenied,
  permissionDeniedForever,
  timeoutOrError,
  outOfRange,
  allowed,
}

class LocationService {
  static double _targetLatitude = 23.050473;
  static double _targetLongitude = 72.533682;
  static double _maxDistanceMeters = 100.0;

  static void setTargetLocation(double latitude, double longitude) {
    _targetLatitude = latitude;
    _targetLongitude = longitude;
  }

  static void setDistanceInMeters(double distanceInMeters) {
    _maxDistanceMeters = distanceInMeters;
  }

  static Future<Position?> getCurrentLocation() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return null;

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return null;
    }

    if (permission == LocationPermission.deniedForever) return null;

    try {
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 8),
        ),
      );
    } catch (_) {
      try {
        return await Geolocator.getLastKnownPosition();
      } catch (_) {
        return null;
      }
    }
  }

  /// Checks whether the user is within [_maxDistanceMeters] of the target
  /// location. Returns a [LocationCheckResult] with the outcome.
  ///
  /// [outOfRangeMessage] — optional custom message when the user is too far.
  static Future<LocationCheckResult> isWithinServiceableArea({
    String? outOfRangeMessage,
  }) async {
    // 1. Check if location services are enabled.
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return const LocationCheckResult(
        allowed: false,
        status: LocationStatus.serviceDisabled,
        message:
        'Location services are disabled. Please enable them in your device settings.',
      );
    }

    // 2. Check & request permission.
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return const LocationCheckResult(
          allowed: false,
          status: LocationStatus.permissionDenied,
          message: 'Location permission is required to place an order.',
        );
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return const LocationCheckResult(
        allowed: false,
        status: LocationStatus.permissionDeniedForever,
        message:
        'Location permissions are permanently denied. Please enable them from your device settings.',
      );
    }

    // 3. Get current position with timeout & fallback.
    Position? position;
    try {
      position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 8),
        ),
      );
    } catch (_) {
      try {
        position = await Geolocator.getLastKnownPosition();
      } catch (_) {
        position = null;
      }
    }

    if (position == null) {
      return const LocationCheckResult(
        allowed: false,
        status: LocationStatus.timeoutOrError,
        message:
        'Unable to retrieve your current location. Please ensure GPS is working and try again.',
      );
    }

    // 4. Calculate distance using the Haversine formula.
    final distance = _calculateDistance(
      position.latitude,
      position.longitude,
      _targetLatitude,
      _targetLongitude,
    );

    if (distance <= _maxDistanceMeters) {
      return LocationCheckResult(
        allowed: true,
        status: LocationStatus.allowed,
        distanceMeters: distance,
      );
    }

    return LocationCheckResult(
      allowed: false,
      status: LocationStatus.outOfRange,
      distanceMeters: distance,
      message:
      outOfRangeMessage ??
          'You are outside the serviceable area. Orders are only allowed within 50 meters of the specified location.',
    );
  }

  /// Haversine formula to calculate distance between two lat/lng points in
  /// meters.
  static double _calculateDistance(
      double lat1,
      double lon1,
      double lat2,
      double lon2,
      ) {
    const double earthRadius = 6371000; // meters
    final double dLat = _degreesToRadians(lat2 - lat1);
    final double dLon = _degreesToRadians(lon2 - lon1);

    final double a =
        sin(dLat / 2) * sin(dLat / 2) +
            cos(_degreesToRadians(lat1)) *
                cos(_degreesToRadians(lat2)) *
                sin(dLon / 2) *
                sin(dLon / 2);

    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  static double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }
}

class LocationCheckResult {
  final bool allowed;
  final LocationStatus status;
  final double? distanceMeters;
  final String? message;

  const LocationCheckResult({
    required this.allowed,
    required this.status,
    this.distanceMeters,
    this.message,
  });
}
