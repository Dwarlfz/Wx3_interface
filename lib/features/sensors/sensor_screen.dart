import 'package:flutter/material.dart';
import 'package:wx3_interface/widgets/custom_app_bar.dart';
import 'package:wx3_interface/widgets/bottom_nav_bar.dart';
import 'package:wx3_interface/widgets/background_wallpaper.dart';
import 'package:wx3_interface/features/notification/notification_banner.dart';
import 'widgets/temp_body_card.dart';
import 'widgets/temp_env_card.dart';
import 'widgets/humidity_card.dart';
import 'widgets/toxic_card.dart';
import 'widgets/heart_card.dart';
import 'widgets/respiration_card.dart';
import 'package:wx3_interface/core/models/user_model.dart';
import 'package:wx3_interface/features/profile/profile_screen.dart';

class SensorScreen extends StatefulWidget {
  final UserModel user;
  const SensorScreen({super.key, required this.user});

  @override
  State<SensorScreen> createState() => _SensorScreenState();
}

class _SensorScreenState extends State<SensorScreen> {
  int selectedIndex = 0;

  void onItemTapped(int index) {
    if (index == 1) {
      Navigator.pushNamed(context, '/compass');
    } else {
      setState(() {
        selectedIndex = index;
      });
    }
  }

  final double bodyTemp = 33;
  final double envTemp = 36.0;
  final double humidity = 85;
  final double gasLevel = 2;
  final int heartRate = 120;
  final int respirationRate = 28;

  late final List<String> alertMessages = [
    if (gasLevel > 2.5) 'Toxic gas dangerously high!',
    if (bodyTemp > 38) 'High body temperature!',
    if (bodyTemp > 39.5) 'Critical body temperature! Seek help!',
    if (envTemp > 35) 'High environmental temperature!',
    if (envTemp < 10) 'External temperature too cold!',
    if (humidity < 20) 'Air too dry, may cause dehydration.',
    if (humidity > 80) 'High humidity can cause discomfort.',
    if (heartRate < 50) 'Heart rate dangerously low!',
    if (heartRate > 100) 'Heart rate is too high!',
    if (heartRate > 130) 'Heart rate critical! Seek help!',
    if (respirationRate < 12) 'Abnormally slow breathing!',
    if (respirationRate > 20) 'Rapid breathing detected!',
    if (respirationRate > 30) 'Dangerously high breathing rate!'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const BackgroundWallpaper(),
          Column(
            children: [
              CustomAppBar(
                title: "Sensor Dashboard",
                onSettingsTap: () {
                  Navigator.pushNamed(context, '/settings');
                },
                onProfileTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProfileScreen(user: widget.user),
                    ),
                  );
                },
                alertMessages: const [], // No duplication
              ),
              NotificationBanner(alertMessages: alertMessages),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  childAspectRatio: 0.9,
                  padding: const EdgeInsets.all(10),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  children: [
                    HeartRateCard(heartRate: heartRate),
                    RespirationCard(respirationRate: respirationRate),
                    TempBodyCard(bodyTemp: bodyTemp),
                    TempEnvCard(envTemp: envTemp),
                    HumidityCard(humidity: humidity),
                    ToxicGasCard(gasLevel: gasLevel),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: AppBottomNavBar(
        selectedIndex: selectedIndex,
        onItemTapped: onItemTapped,
      ),
    );
  }
}
