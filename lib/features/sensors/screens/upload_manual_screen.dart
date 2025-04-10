import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/sensor_data_service.dart';

class UploadManualScreen extends StatefulWidget {
  const UploadManualScreen({super.key});

  @override
  State<UploadManualScreen> createState() => _UploadManualScreenState();
}

class _UploadManualScreenState extends State<UploadManualScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _heartRateController = TextEditingController();
  final TextEditingController _respirationRateController = TextEditingController();
  final TextEditingController _bodyTempController = TextEditingController();
  final TextEditingController _envTempController = TextEditingController();
  final TextEditingController _humidityController = TextEditingController();

  bool _isToxicGasDetected = false;

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not logged in')),
        );
        return;
      }

      try {
        await SensorDataService.uploadManualRecord(
          userId: user.uid,
          heartRate: int.parse(_heartRateController.text),
          respirationRate: int.parse(_respirationRateController.text),
          bodyTemperature: double.parse(_bodyTempController.text),
          environmentTemperature: double.parse(_envTempController.text),
          humidity: double.parse(_humidityController.text),
          toxicGasDetected: _isToxicGasDetected,
        );

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Manual data uploaded')),
        );

        _formKey.currentState!.reset();
        _heartRateController.clear();
        _respirationRateController.clear();
        _bodyTempController.clear();
        _envTempController.clear();
        _humidityController.clear();
        setState(() {
          _isToxicGasDetected = false;
        });
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ Upload failed: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _heartRateController.dispose();
    _respirationRateController.dispose();
    _bodyTempController.dispose();
    _envTempController.dispose();
    _humidityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Upload Manual Record")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildField("Heart Rate", _heartRateController),
              _buildField("Respiration Rate", _respirationRateController),
              _buildField("Body Temperature", _bodyTempController),
              _buildField("Environment Temperature", _envTempController),
              _buildField("Humidity", _humidityController),
              SwitchListTile(
                title: const Text("Toxic Gas Detected"),
                value: _isToxicGasDetected,
                onChanged: (val) => setState(() => _isToxicGasDetected = val),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: const Text("Upload"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: label),
      validator: (value) =>
      value == null || value.isEmpty ? 'Enter $label' : null,
    );
  }
}
