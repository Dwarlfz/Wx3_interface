
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:wx3_interface/features/sensors/widgets/circular_meter.dart';

class HeartRateCard extends StatelessWidget {
  final int heartRate;

  const HeartRateCard({super.key, required this.heartRate});

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
                value: heartRate.toDouble(),
                maxValue: 200,
                label: 'Heart rate',
                unit: 'bpm',

              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 30,
                    width: 30,
                    child: Lottie.asset(
                      'lib/assets/lottie/heart.json',
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Text(
                  //   "$heartRate bpm",
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
