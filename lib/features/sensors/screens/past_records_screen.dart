import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:csv/csv.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wx3_interface/core/models/sensor_data_model.dart';

class PastRecordsScreen extends StatelessWidget {
  final List<SensorData> records;

  const PastRecordsScreen({super.key, required this.records});

  Future<String> _getDownloadPath() async {
    final dir = await getExternalStorageDirectory();
    final downloadsDir = Directory('/storage/emulated/0/Download');
    return downloadsDir.existsSync() ? downloadsDir.path : dir!.path;
  }

  Future<void> _exportCSV(BuildContext context) async {
    if (await Permission.storage.request().isGranted) {
      final List<List<dynamic>> csvData = [
        [
          'Heart Rate',
          'Respiration Rate',
          'Body Temp',
          'Env Temp',
          'Humidity',
          'Toxic Gas',
          'Timestamp'
        ],
        ...records.map((e) => [
          e.heartRate,
          e.respirationRate,
          e.bodyTemperature,
          e.environmentTemperature,
          e.humidity,
          e.toxicGasDetected ? "Yes" : "No",
          e.timestamp.toDate().toIso8601String(),
        ])
      ];

      String csv = const ListToCsvConverter().convert(csvData);
      final path = await _getDownloadPath();
      final file = File('$path/past_records.csv');
      await file.writeAsString(csv);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("✅ CSV saved to Downloads")),
      );

      Share.shareXFiles([XFile(file.path)], text: 'Here are my sensor records in CSV format.');
    }
  }

  Future<void> _exportPDF(BuildContext context) async {
    if (await Permission.storage.request().isGranted) {
      final pdf = pw.Document();

      pdf.addPage(pw.MultiPage(
        build: (context) => [
          pw.Text('Sensor Past Records', style: pw.TextStyle(fontSize: 22)),
          pw.SizedBox(height: 20),
          ...records.map((e) => pw.Container(
            margin: const pw.EdgeInsets.only(bottom: 8),
            child: pw.Text(
              "❤️ Heart: ${e.heartRate}, 💨 Resp: ${e.respirationRate}, 🌡️ Body: ${e.bodyTemperature}, 🌍 Env: ${e.environmentTemperature}, 💧 Hum: ${e.humidity}, ☠️ Gas: ${e.toxicGasDetected ? "Yes" : "No"}, 🕒 ${e.timestamp.toDate()}",
              style: const pw.TextStyle(fontSize: 12),
            ),
          ))
        ],
      ));

      final path = await _getDownloadPath();
      final file = File('$path/past_records.pdf');
      await file.writeAsBytes(await pdf.save());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("✅ PDF saved to Downloads")),
      );

      Share.shareXFiles([XFile(file.path)], text: 'Here are my sensor records in PDF format.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Past Records"),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'csv') {
                _exportCSV(context);
              } else if (value == 'pdf') {
                _exportPDF(context);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'csv', child: Text("Export as CSV")),
              const PopupMenuItem(value: 'pdf', child: Text("Export as PDF")),
            ],
          ),
        ],
      ),
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
              subtitle: Text("🕒 ${data.timestamp.toDate()}"),
            ),
          );
        },
      ),
    );
  }
}
