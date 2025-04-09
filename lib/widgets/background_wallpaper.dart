// lib/widgets/background_wallpaper.dart

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class BackgroundWallpaper extends StatelessWidget {
  const BackgroundWallpaper({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Lottie.asset(
        'lib/assets/lottie/wallpaper.json',
        fit: BoxFit.cover,
        repeat: true,
      ),
    );
  }
}
