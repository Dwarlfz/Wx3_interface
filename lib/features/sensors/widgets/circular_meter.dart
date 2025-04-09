// lib/widgets/circular_meter.dart

import 'package:flutter/material.dart';
import 'dart:math' as math;

class CircularMeter extends StatelessWidget {
  final String label;
  final double value;
  final double maxValue;
  final String unit;

  const CircularMeter({
    super.key,
    required this.label,
    required this.value,
    required this.maxValue,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 100,
              width: 100,
              child: TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0, end: value / maxValue),
                duration: const Duration(seconds: 1),
                builder: (context, progress, _) {
                  return CustomPaint(
                    painter: _CircularMeterPainter(progress),
                    child: Center(
                      child: Text(
                        '${value.toInt()} $unit',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CircularMeterPainter extends CustomPainter {
  final double progress;

  _CircularMeterPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint backgroundPaint = Paint()
      ..color = Colors.grey.shade800
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke;

    final Paint foregroundPaint = Paint()
      ..color = Colors.blueAccent
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    canvas.drawCircle(center, radius, backgroundPaint);

    final sweepAngle = 2 * math.pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      sweepAngle,
      false,
      foregroundPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
