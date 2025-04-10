import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wx3_interface/features/sensors/sensor_screen.dart';
import 'package:wx3_interface/core/models/user_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController rankController = TextEditingController();
  final TextEditingController squadController = TextEditingController();

  void loginUser() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final rank = rankController.text.trim();
    final squad = squadController.text.trim();

    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => SensorScreen(
              user: UserModel(
                id: user.uid,
                email: user.email ?? '',
                name: user.displayName ?? 'Default Name',
                rank: rank,
                squad: squad,
              ),
            ),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Login failed: ${e.message}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            TextField(
              controller: rankController,
              decoration: const InputDecoration(labelText: 'Rank'),
            ),
            TextField(
              controller: squadController,
              decoration: const InputDecoration(labelText: 'Department / Squad'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: loginUser,
              child: const Text('🔐 Login'),
            ),
          ],
        ),
      ),
    );
  }
}
