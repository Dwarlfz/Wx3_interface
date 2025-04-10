// profile_screen.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:csv/csv.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:wx3_interface/core/models/user_model.dart';
import 'package:wx3_interface/core/models/sensor_data_model.dart';
import 'package:wx3_interface/features/sensors/screens/recent_record_screen.dart';
import 'package:wx3_interface/features/sensors/screens/upload_manual_screen.dart';

class ProfileScreen extends StatelessWidget {
  final UserModel user;
  const ProfileScreen({super.key, required this.user});

  Future<void> _exportAsCSV(BuildContext context) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    final snapshot = await FirebaseFirestore.instance
        .collection('sensorData')
        .where('userId', isEqualTo: currentUser.uid)
        .orderBy('timestamp', descending: true)
        .get();

    final csvData = <List<String>>[
      ["Heart Rate", "Respiration", "Body Temp", "Env Temp", "Humidity", "Toxic Gas", "Timestamp"]
    ];

    for (var doc in snapshot.docs) {
      final data = SensorData.fromMap(doc.data());
      csvData.add([
        data.heartRate.toString(),
        data.respirationRate.toString(),
        data.bodyTemperature.toString(),
        data.environmentTemperature.toString(),
        data.humidity.toString(),
        data.toxicGasDetected ? "Yes" : "No",
        DateFormat('yyyy-MM-dd HH:mm:ss').format(data.timestamp.toDate()),
      ]);
    }

    final csvString = const ListToCsvConverter().convert(csvData);
    final directory = await getDownloadsDirectory();
    final file = File('${directory!.path}/sensor_records.csv');
    await file.writeAsString(csvString);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("CSV exported successfully.")),
    );
  }

  Future<void> _exportAsPDF(BuildContext context) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    final snapshot = await FirebaseFirestore.instance
        .collection('sensorData')
        .where('userId', isEqualTo: currentUser.uid)
        .orderBy('timestamp', descending: true)
        .get();

    final pdf = pw.Document();

    for (var doc in snapshot.docs) {
      final data = SensorData.fromMap(doc.data());
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text("Heart Rate: ${data.heartRate} bpm"),
              pw.Text("Respiration Rate: ${data.respirationRate} bpm"),
              pw.Text("Body Temp: ${data.bodyTemperature} °C"),
              pw.Text("Env Temp: ${data.environmentTemperature} °C"),
              pw.Text("Humidity: ${data.humidity} %"),
              pw.Text("Toxic Gas Detected: ${data.toxicGasDetected ? "Yes" : "No"}"),
              pw.Text("Timestamp: ${DateFormat('yyyy-MM-dd HH:mm:ss').format(data.timestamp.toDate())}"),
              pw.SizedBox(height: 10),
            ],
          ),
        ),
      );
    }

    final directory = await getDownloadsDirectory();
    final file = File('${directory!.path}/sensor_records.pdf');
    await file.writeAsBytes(await pdf.save());

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("PDF exported successfully.")),
    );
  }

  void _manualUpload(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const UploadManualScreen()),
    );
  }


  void _viewMostRecentRecord(BuildContext context) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    final snapshot = await FirebaseFirestore.instance
        .collection('sensorData')
        .where('userId', isEqualTo: currentUser.uid)
        .orderBy('timestamp', descending: true)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      final latestData = SensorData.fromMap(snapshot.docs.first.data());
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => RecentRecordScreen(data: latestData),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No records found.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text('Name: ${user.name}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('Rank: ${user.rank}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 4),
            Text('Department: ${user.squad}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _viewMostRecentRecord(context),
              child: const Text('View Most Recent Record'),
            ),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text("Export Format"),
                    content: const Text("Choose the file format to export:"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                          _exportAsCSV(context);
                        },
                        child: const Text("CSV"),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                          _exportAsPDF(context);
                        },
                        child: const Text("PDF"),
                      ),
                    ],
                  ),
                );
              },
              child: const Text("Export Past Record"),
            ),
            ElevatedButton(
              onPressed: () => _manualUpload(context),
              child: const Text("Upload Record Manually"),
            ),
          ],
        ),
      ),
    );
  }
}