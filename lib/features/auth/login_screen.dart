import 'package:flutter/material.dart';
import 'package:wx3_interface/core/models/user_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _rankController = TextEditingController();
  final TextEditingController _squadController = TextEditingController();

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final user = UserModel(
        name: _nameController.text,
        rank: _rankController.text,
        squad: _squadController.text,
      );

      // Navigate to the sensor dashboard after login
      Navigator.pushReplacementNamed(
        context,
        '/sensors',
        arguments: user,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) => value!.isEmpty ? 'Enter name' : null,
              ),
              TextFormField(
                controller: _rankController,
                decoration: const InputDecoration(labelText: 'Rank'),
                validator: (value) => value!.isEmpty ? 'Enter rank' : null,
              ),
              TextFormField(
                controller: _squadController,
                decoration: const InputDecoration(labelText: 'Squad/Department'),
                validator: (value) => value!.isEmpty ? 'Enter squad' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
