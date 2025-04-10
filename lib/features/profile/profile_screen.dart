import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:csv/csv.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

import 'package:wx3_interface/core/models/user_model.dart';
import 'package:wx3_interface/core/models/sensor_data_model.dart';
import 'package:wx3_interface/features/sensors/screens/recent_record_screen.dart';
import 'package:wx3_interface/features/sensors/screens/upload_manual_screen.dart';

class ProfileScreen extends StatelessWidget {
  final UserModel user;

  const ProfileScreen({super.key, required this.user});

  Future<void> _checkAndRequestStoragePermission() async {
    if (Platform.isAndroid) {
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        await Permission.storage.request();
      }
    }
  }

  Future<Directory?> _getDownloadDir() async {
    return await getDownloadsDirectory();
  }

  Future<void> _exportAsCSV(BuildContext context) async {
    await _checkAndRequestStoragePermission();
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
    final directory = await _getDownloadDir();
    final file = File('${directory!.path}/sensor_records.csv');
    await file.writeAsString(csvString);

    Share.shareXFiles([XFile(file.path)], text: 'Sensor Data CSV Export');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("CSV exported and ready to share.")),
    );
  }

  Future<void> _exportAsPDF(BuildContext context) async {
    await _checkAndRequestStoragePermission();
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
              pw.Text("Toxic Gas: ${data.toxicGasDetected ? "Yes" : "No"}"),
              pw.Text("Timestamp: ${DateFormat('yyyy-MM-dd HH:mm:ss').format(data.timestamp.toDate())}"),
              pw.SizedBox(height: 10),
            ],
          ),
        ),
      );
    }

    final directory = await _getDownloadDir();
    final file = File('${directory!.path}/sensor_records.pdf');
    await file.writeAsBytes(await pdf.save());

    Share.shareXFiles([XFile(file.path)], text: 'Sensor Data PDF Export');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("PDF exported and ready to share.")),
    );
  }

  void _manualUpload(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const UploadManualScreen()),
    );
  }

  // Future<void> _viewMostRecentRecord() async {
  //   final userId = user.id; // this will work only inside State class
  //
  //   try {
  //     final snapshot = await FirebaseFirestore.instance
  //         .collection('sensorData')
  //         .where('userId', isEqualTo: userId)
  //         .orderBy('timestamp', descending: true)
  //         .orderBy(FieldPath.documentId, descending: true)
  //         .limit(1)
  //         .get();
  //
  //     if (snapshot.docs.isNotEmpty) {
  //       final data = snapshot.docs.first.data();
  //       print("Most recent record: $data");
  //     } else {
  //       print("No records found for user.");
  //     }
  //   } catch (e) {
  //     print("Error fetching recent record: $e");
  //   }
  // }



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
            // ElevatedButton(
            //   onPressed: () async {
            //     final snapshot = await FirebaseFirestore.instance
            //         .collection('sensorData')
            //         .where('userId', isEqualTo: user.id)
            //         .orderBy('timestamp', descending: true)
            //         .limit(5)
            //         .get();
            //
            //     if (snapshot.docs.isNotEmpty) {
            //       final recentRecords = snapshot.docs.map((doc) {
            //         final data = doc.data();
            //         return SensorData.fromMap(data); // no need for docId here
            //       }).toList();
            //
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //           builder: (_) => RecentRecordScreen(records: recentRecords),
            //         ),
            //       );
            //     } else {
            //       ScaffoldMessenger.of(context).showSnackBar(
            //         const SnackBar(content: Text("No recent records found.")),
            //       );
            //     }
            //   },
            //   child: const Text('View Past Records'),
            // ),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text("Export Format"),
                    content: const Text("Choose the file format to export and share:"),
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
              child: const Text("Export Past Records"),
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
