// lib/core/services/sensor_service.dart

import 'dart:math';
import '../models/sensor_data_model.dart';

class SensorService {
  final Random _random = Random();

  SensorData fetchSensorData() {
    return SensorData(
      bodyTemperature: _random.nextDouble() * 2 + 36, // 36 - 38 °C
      environmentTemperature: _random.nextDouble() * 20 + 20, // 20 - 40 °C
      humidity: _random.nextDouble() * 50 + 30, // 30 - 80%
      toxicGasDetected: _random.nextBool(),
      heartRate: _random.nextInt(40) + 60, // 60 - 100 bpm
      respirationRate: _random.nextInt(10) + 15, // 15 - 25 breaths/min
    );
  }
}
