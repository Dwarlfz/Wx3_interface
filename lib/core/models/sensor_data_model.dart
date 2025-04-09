// lib/core/models/sensor_data_model.dart

class SensorData {
  final double bodyTemperature;
  final double environmentTemperature;
  final double humidity;
  final bool toxicGasDetected;
  final int heartRate;
  final int respirationRate;

  SensorData({
    required this.bodyTemperature,
    required this.environmentTemperature,
    required this.humidity,
    required this.toxicGasDetected,
    required this.heartRate,
    required this.respirationRate,
  });
}
