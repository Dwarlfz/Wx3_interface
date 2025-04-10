//recent record screen
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wx3_interface/core/models/sensor_data_model.dart';

class RecentRecordScreen extends StatelessWidget {
  final List<SensorData> records;

  const RecentRecordScreen({super.key, required this.records});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🧾 Recent Records')),
      body: records.isEmpty
          ? const Center(child: Text("No recent records found."))
          : ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: records.length,
        itemBuilder: (context, index) {
          final data = records[index];
          final DateTime dateTime = data.timestamp.toDate();
          final formattedTime = DateFormat.yMMMd().add_jm().format(dateTime);

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
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
          );
        },
      ),
    );
  }
}
