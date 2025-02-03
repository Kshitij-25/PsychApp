import 'dart:math' as math;

import 'package:flutter/material.dart';

class MoodDonutChart extends StatelessWidget {
  final Map<String, int> moodCounts;
  final double size;
  final double strokeWidth;

  const MoodDonutChart({
    super.key,
    required this.moodCounts,
    this.size = 200,
    this.strokeWidth = 30,
  });

  @override
  Widget build(BuildContext context) {
    final total = moodCounts.values.fold(0, (sum, count) => sum + count);
    if (total == 0) return const SizedBox.shrink();

    // Calculate the dominant mood
    String dominantMood = '';
    int maxCount = 0;
    moodCounts.forEach((mood, count) {
      if (count > maxCount) {
        maxCount = count;
        dominantMood = mood;
      }
    });

    // Calculate percentage for the dominant mood
    final percentage = (maxCount / total * 100).round();

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(size, size),
            painter: DonutChartPainter(
              moodCounts: moodCounts,
              strokeWidth: strokeWidth,
              context: context,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                dominantMood[0].toUpperCase() + dominantMood.substring(1),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                '$percentage%',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DonutChartPainter extends CustomPainter {
  final Map<String, int> moodCounts;
  final double strokeWidth;
  BuildContext context;

  DonutChartPainter({
    required this.moodCounts,
    required this.strokeWidth,
    required this.context,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    final total = moodCounts.values.fold(0, (sum, count) => sum + count);
    if (total == 0) return;

    double startAngle = -math.pi / 2;

    final colors = {
      'happy': Colors.green.shade300,
      'neutral': Colors.purple.shade200,
      'sad': Theme.of(context).colorScheme.primaryContainer,
    };

    moodCounts.forEach((mood, count) {
      final sweepAngle = 2 * math.pi * count / total;

      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round
        ..color = colors[mood] ?? Colors.grey;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );

      startAngle += sweepAngle;
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
