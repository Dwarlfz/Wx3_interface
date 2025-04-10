import 'package:cloud_firestore/cloud_firestore.dart';

class SensorData {
  final String userId;
  final int heartRate;
  final int respirationRate;
  final double bodyTemperature;
  final double environmentTemperature;
  final double humidity;
  final bool toxicGasDetected;
  final Timestamp timestamp;

  SensorData({
    required this.userId,
    required this.heartRate,
    required this.respirationRate,
    required this.bodyTemperature,
    required this.environmentTemperature,
    required this.humidity,
    required this.toxicGasDetected,
    required this.timestamp,
  });

  factory SensorData.fromMap(Map<String, dynamic> map) {
    return SensorData(
      userId: map['userId'] ?? '',
      heartRate: map['heartRate'] ?? 0,
      respirationRate: map['respirationRate'] ?? 0,
      bodyTemperature: (map['bodyTemperature'] ?? 0).toDouble(),
      environmentTemperature: (map['environmentTemperature'] ?? 0).toDouble(),
      humidity: (map['humidity'] ?? 0).toDouble(),
      toxicGasDetected: map['toxicGasDetected'] ?? false,
      timestamp: map['timestamp'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'heartRate': heartRate,
      'respirationRate': respirationRate,
      'bodyTemperature': bodyTemperature,
      'environmentTemperature': environmentTemperature,
      'humidity': humidity,
      'toxicGasDetected': toxicGasDetected,
      'timestamp': timestamp,
    };
  }
}
