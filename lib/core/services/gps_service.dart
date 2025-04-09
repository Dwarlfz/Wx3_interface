// lib/core/services/gps_service.dart

import 'package:geolocator/geolocator.dart';

class GpsService {
  Future<Position> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied.');
      }
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  double calculateSpeed(Position oldPos, Position newPos) {
    final distanceInMeters = Geolocator.distanceBetween(
      oldPos.latitude,
      oldPos.longitude,
      newPos.latitude,
      newPos.longitude,
    );
    final timeInSeconds = newPos.timestamp!
        .difference(oldPos.timestamp!)
        .inMilliseconds /
        1000;

    return timeInSeconds == 0 ? 0 : distanceInMeters / timeInSeconds;
  }
}
