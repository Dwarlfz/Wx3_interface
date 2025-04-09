import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class TempEnvCard extends StatelessWidget {
  final double envTemp;

  const TempEnvCard({Key? key, required this.envTemp}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.purple.shade300,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Env Temp',
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
                'lib/assets/lottie/env_temp.json',
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${envTemp.toStringAsFixed(1)} °C',
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
