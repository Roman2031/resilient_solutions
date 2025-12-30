import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Progress Circle Widget
/// Circular progress indicator with percentage display
class ProgressCircle extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final double size;
  final double strokeWidth;
  final Color? progressColor;
  final Color? backgroundColor;
  final bool showPercentage;

  const ProgressCircle({
    super.key,
    required this.progress,
    this.size = 100,
    this.strokeWidth = 8,
    this.progressColor,
    this.backgroundColor,
    this.showPercentage = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveProgressColor = progressColor ?? theme.primaryColor;
    final effectiveBackgroundColor =
        backgroundColor ?? theme.primaryColor.withOpacity(0.1);

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background circle
          CustomPaint(
            size: Size(size, size),
            painter: _CirclePainter(
              progress: 1.0,
              strokeWidth: strokeWidth,
              color: effectiveBackgroundColor,
            ),
          ),
          // Progress circle
          CustomPaint(
            size: Size(size, size),
            painter: _CirclePainter(
              progress: progress,
              strokeWidth: strokeWidth,
              color: effectiveProgressColor,
            ),
          ),
          // Percentage text
          if (showPercentage)
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${(progress * 100).toInt()}%',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: effectiveProgressColor,
                  ),
                ),
                Text(
                  'complete',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _CirclePainter extends CustomPainter {
  final double progress;
  final double strokeWidth;
  final Color color;

  _CirclePainter({
    required this.progress,
    required this.strokeWidth,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Draw arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2, // Start from top
      2 * math.pi * progress, // Sweep angle based on progress
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _CirclePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.color != color;
  }
}
