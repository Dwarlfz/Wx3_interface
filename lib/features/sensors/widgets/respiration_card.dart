// lib/features/sensors/widgets/respiration_card.dart

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:wx3_interface/features/sensors/widgets/circular_meter.dart';

class RespirationCard extends StatelessWidget {
  final int respirationRate;

  const RespirationCard({super.key, required this.respirationRate});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SizedBox(
        height: 120,
        width: double.infinity,
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircularMeter(
                value: respirationRate.toDouble(),
                maxValue: 40,
                label: 'Respiration rate',
                unit: 'rmp',

              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 30,
                    width: 30,
                    child: Lottie.asset(
                      'lib/assets/lottie/respiration.json',
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Text(
                  //   "$respirationRate rpm",
                  //   style: const TextStyle(
                  //     color: Colors.white,
                  //     fontWeight: FontWeight.bold,
                  //     fontSize: 14,
                  //   ),
                  // ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
