import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Custom painter for drawing the arc progress indicator.
///
/// Draws a background arc and a progress arc on top of it.
class ArcProgressPainter extends CustomPainter {
  /// Current progress from 0.0 to 1.0.
  final double progress;

  /// Width of the arc stroke.
  final double strokeWidth;

  /// Background color of the arc.
  final Color backgroundColor;

  /// Progress color of the arc.
  final Color progressColor;

  /// Optional gradient for the progress arc.
  final Gradient? progressGradient;

  /// Gap angle at the bottom in radians.
  final double gapAngle;

  /// Stroke cap style for the arc ends.
  final StrokeCap strokeCap;

  /// Creates an arc progress painter.
  const ArcProgressPainter({
    required this.progress,
    required this.strokeWidth,
    required this.backgroundColor,
    required this.progressColor,
    this.progressGradient,
    required this.gapAngle,
    this.strokeCap = StrokeCap.round,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final double startAngle = math.pi / 2 + gapAngle / 2;
    final double totalSweepAngle = 2 * math.pi - gapAngle;

    // Background arc paint
    final Paint backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = strokeCap;

    // Progress arc paint
    final Paint progressPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = strokeCap;

    // Apply gradient or solid color
    if (progressGradient != null) {
      progressPaint.shader = progressGradient!.createShader(rect);
    } else {
      progressPaint.color = progressColor;
    }

    // Draw background arc
    canvas.drawArc(rect, startAngle, totalSweepAngle, false, backgroundPaint);

    // Draw progress arc
    if (progress > 0) {
      final double sweep = totalSweepAngle * progress.clamp(0.0, 1.0);
      canvas.drawArc(rect, startAngle, sweep, false, progressPaint);
    }
  }

  @override
  bool shouldRepaint(covariant ArcProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.progressColor != progressColor ||
        oldDelegate.progressGradient != progressGradient ||
        oldDelegate.gapAngle != gapAngle ||
        oldDelegate.strokeCap != strokeCap;
  }
}
