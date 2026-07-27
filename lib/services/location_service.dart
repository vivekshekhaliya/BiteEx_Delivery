import 'dart:async';
import 'dart:math';

import 'package:geolocator/geolocator.dart';

import '../repository/rider_repository.dart';

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
  static double _maxDistanceMeters = 80.0;

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

  /// Checks whether the rider is within [radiusInMeters] (default 80m) of the outlet premises.
  static Future<LocationCheckResult> checkOutletRadius({
    double radiusInMeters = 80.0,
    double? targetLat,
    double? targetLng,
  }) async {
    // 1. Check location services
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return const LocationCheckResult(
        allowed: false,
        status: LocationStatus.serviceDisabled,
        message: 'Location services are disabled. Please enable GPS to accept orders.',
      );
    }

    // 2. Check location permissions
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return const LocationCheckResult(
          allowed: false,
          status: LocationStatus.permissionDenied,
          message: 'Location permission is required to accept orders.',
        );
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return const LocationCheckResult(
        allowed: false,
        status: LocationStatus.permissionDeniedForever,
        message: 'Location permissions are permanently denied. Please enable them in app settings.',
      );
    }

    // 3. Get current rider location
    Position? position = await getCurrentLocation();
    if (position == null) {
      return const LocationCheckResult(
        allowed: false,
        status: LocationStatus.timeoutOrError,
        message: 'Unable to retrieve your current location. Please check GPS and try again.',
      );
    }

    // 4. Determine target outlet location
    double outletLat = targetLat ?? _targetLatitude;
    double outletLng = targetLng ?? _targetLongitude;

    if (targetLat == null || targetLng == null) {
      try {
        final outletData = await RiderRepository.getNearestOutlet(
          latitude: position.latitude,
          longitude: position.longitude,
        );

        final rawOutlet = outletData['data'];
        if (rawOutlet != null) {
          final parsedLat = rawOutlet['latitude'] is num ? (rawOutlet['latitude'] as num).toDouble() : null;
          final parsedLng = rawOutlet['longitude'] is num ? (rawOutlet['longitude'] as num).toDouble() : null;
          if (parsedLat != null && parsedLng != null) {
            outletLat = parsedLat;
            outletLng = parsedLng;
          }
        }
      } catch (_) {
        // Fall back to target lat/lng if API call fails
      }
    }

    // 5. Calculate distance in meters
    final distance = _calculateDistance(
      position.latitude,
      position.longitude,
      outletLat,
      outletLng,
    );

    if (distance <= radiusInMeters) {
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
      message: 'You must be within an ${radiusInMeters.toInt()}-meter radius of the outlet premises to accept orders. (Current distance: ${distance.toStringAsFixed(1)}m)',
    );
  }

  /// Checks whether the user is within [_maxDistanceMeters] of the target
  /// location. Returns a [LocationCheckResult] with the outcome.
  ///
  /// [outOfRangeMessage] — optional custom message when the user is too far.
  static Future<LocationCheckResult> isWithinServiceableArea({
    String? outOfRangeMessage,
  }) async {
    return checkOutletRadius(
      radiusInMeters: _maxDistanceMeters,
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
