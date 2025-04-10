// lib/core/services/sensor_service.dart

import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wx3_interface/core/models/sensor_data_model.dart';

class SensorService {
  final Random _random = Random();

  SensorData fetchSensorData(String userId) {
    return SensorData(
      userId: userId,
      timestamp: Timestamp.now(),
      bodyTemperature: _random.nextDouble() * 2 + 36, // 36 - 38 °C
      environmentTemperature: _random.nextDouble() * 20 + 20, // 20 - 40 °C
      humidity: _random.nextDouble() * 50 + 30, // 30 - 80%
      toxicGasDetected: _random.nextBool(),
      heartRate: _random.nextInt(40) + 60, // 60 - 100 bpm
      respirationRate: _random.nextInt(10) + 15, // 15 - 25 breaths/min
    );
  }

  static Future<SensorData?> fetchMostRecentSensorData(String userId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('sensor_data')
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return null;

    return SensorData.fromMap(snapshot.docs.first.data());
  }
}
