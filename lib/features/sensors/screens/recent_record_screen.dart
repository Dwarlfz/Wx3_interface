import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wx3_interface/core/models/sensor_data_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // For Timestamp

class RecentRecordScreen extends StatelessWidget {
  final SensorData data;

  const RecentRecordScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    // Convert Firebase Timestamp to DateTime
    final DateTime dateTime = (data.timestamp as Timestamp).toDate();
    final formattedTime = DateFormat.yMMMd().add_jm().format(dateTime);

    return Scaffold(
      appBar: AppBar(title: const Text('🧾 Most Recent Record')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("❤️ Heart Rate: ${data.heartRate} bpm", style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                Text("💨 Respiration: ${data.respirationRate} bpm", style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                Text("🌡️ Body Temp: ${data.bodyTemperature} °C", style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                Text("🌍 Env Temp: ${data.environmentTemperature} °C", style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                Text("💧 Humidity: ${data.humidity} %", style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                Text("☠️ Toxic Gas: ${data.toxicGasDetected ? "Detected" : "Safe"}", style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 12),
                Text("🕒 Time: $formattedTime", style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
