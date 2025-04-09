import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  final VoidCallback onSettingsTap;
  final VoidCallback onProfileTap;
  final List<String> alertMessages;

  const CustomAppBar({
    super.key,
    required this.title,
    required this.onSettingsTap,
    required this.onProfileTap,
    required this.alertMessages,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.account_circle, size: 30),
                onPressed: onProfileTap,
              ),
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              IconButton(
                icon: const Icon(Icons.settings, size: 30),
                onPressed: onSettingsTap,
              ),
            ],
          ),
        ),
        if (alertMessages.isNotEmpty)
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: alertMessages.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Chip(
                    label: Text(
                      alertMessages[index],
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.redAccent,
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
