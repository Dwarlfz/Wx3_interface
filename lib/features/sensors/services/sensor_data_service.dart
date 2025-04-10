import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wx3_interface/core/models/sensor_data_model.dart';

class SensorDataService {
  // Save actual sensor data
  static Future<void> saveSensorData(SensorData data) async {
    final sensorRef = FirebaseFirestore.instance.collection('sensor_data');
    await sensorRef.add(data.toMap());
  }

  // Fetch past records of a specific user
  static Future<List<SensorData>> fetchUserSensorData(String userId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('sensor_data')
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return SensorData.fromMap(data); // Your model should handle this
    }).toList();
  }
  static Future<void> uploadManualRecord({
    required String userId,
    required int heartRate,
    required int respirationRate,
    required double bodyTemperature,
    required double environmentTemperature,
    required double humidity,
    required bool toxicGasDetected,
  }) async {
    final doc = FirebaseFirestore.instance.collection('sensor_data').doc();

    await doc.set({
      'userId': userId,
      'heartRate': heartRate,
      'respirationRate': respirationRate,
      'bodyTemperature': bodyTemperature,
      'environmentTemperature': environmentTemperature,
      'humidity': humidity,
      'toxicGasDetected': toxicGasDetected,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // Fetch the most recent data of a user
  static Future<SensorData?> fetchMostRecentSensorData(String userId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('sensor_data')
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      return SensorData.fromMap(snapshot.docs.first.data());
    }
    return null;
  }

  // Upload dummy data
  static Future<void> uploadDummyRecord({
    required String userId,
    required int heartRate,
    required int respiration,
    required double bodyTemperature,
    required double environmentTemperature,
    required double humidity,
    required bool toxicGasDetected,
  }) async {
    final dummyData = SensorData(
      userId: userId,
      heartRate: heartRate,
      respirationRate: respiration,
      bodyTemperature: bodyTemperature,
      environmentTemperature: environmentTemperature,
      humidity: humidity,
      toxicGasDetected: toxicGasDetected,
      timestamp: Timestamp.now(),
    );

    try {
      final doc = await FirebaseFirestore.instance
          .collection('sensor_data')
          .add(dummyData.toMap());

      print("✅ Dummy data uploaded to: ${doc.id}");
    } catch (e) {
      print("❌ Failed to upload dummy data: $e");
    }
  }
}
