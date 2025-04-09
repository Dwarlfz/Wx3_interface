import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ToxicGasCard extends StatelessWidget {
  final double gasLevel;

  const ToxicGasCard({super.key, required this.gasLevel});

  @override
  Widget build(BuildContext context) {
    final bool isUnsafe = gasLevel > 2.5;

    return Card(
      color: isUnsafe ? Colors.red.shade400 : Colors.green.shade400,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Toxic Gas Level',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 70,
              width: 90,
              child: Lottie.asset(
                'lib/assets/lottie/toxic.json',
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${gasLevel.toStringAsFixed(1)} ppm',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
