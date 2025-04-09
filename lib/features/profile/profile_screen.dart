import 'package:flutter/material.dart';
import 'package:wx3_interface/core/models/user_model.dart';

class ProfileScreen extends StatelessWidget {
  final UserModel user;

  const ProfileScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Name: ${user.name}", style: Theme.of(context).textTheme.headlineSmall),
            Text("Rank: ${user.rank}", style: Theme.of(context).textTheme.bodyLarge),
            Text("Squad: ${user.squad}", style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // TODO: Add past records navigation if needed
              },
              child: const Text("View Past Records"),
            ),
          ],
        ),
      ),
    );
  }
}
