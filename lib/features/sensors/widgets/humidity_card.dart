import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class HumidityCard extends StatelessWidget {
  final double humidity;

  const HumidityCard({super.key, required this.humidity});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.indigoAccent.shade100,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Humidity',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 80,
              width: 80,
              child: Lottie.asset(
                'lib/assets/lottie/humidity.json',
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${humidity.toStringAsFixed(1)} %',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
