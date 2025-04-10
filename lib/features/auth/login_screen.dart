import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wx3_interface/features/sensors/sensor_screen.dart';
import 'package:wx3_interface/core/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController rankController = TextEditingController();
  final TextEditingController squadController = TextEditingController();

  void loginUser() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final name = nameController.text.trim();     // new
    final rank = rankController.text.trim();
    final squad = squadController.text.trim();

    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      if (user != null) {
        // Store user data in Firestore
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'name': name, // make sure you're collecting this in the login screen
          'email': user.email,
          'rank': rank,
          'squad': squad,
        }, SetOptions(merge: true)); // merge prevents overwriting if exists

        // Then navigate to SensorScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) =>
                SensorScreen(
                  user: UserModel(
                    id: user.uid,
                    name: name,
                    email: user.email ?? '',
                    rank: rank,
                    squad: squad,
                  ),
                ),
          ),
        );
      }}
      on FirebaseAuthException catch (e) {
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
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
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
