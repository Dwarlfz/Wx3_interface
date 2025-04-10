// lib/features/sensors/screens/past_records_screen.dart
import 'package:flutter/material.dart';
import 'package:wx3_interface/core/models/sensor_data_model.dart';

class PastRecordsScreen extends StatelessWidget {
  final List<SensorData> records;

  const PastRecordsScreen({super.key, required this.records});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Past Records")),
      body: records.isEmpty
          ? const Center(child: Text("No past records found"))
          : ListView.builder(
        itemCount: records.length,
        itemBuilder: (context, index) {
          final data = records[index];
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              title: Text("❤️ Heart: ${data.heartRate}, 💨 Resp: ${data.respirationRate}"),
              subtitle: Text("🕒 ${data.timestamp}"),
            ),
          );
        },
      ),
    );
  }
}
