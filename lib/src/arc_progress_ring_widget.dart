import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'arc_progress_painter.dart';
import 'milestone_icon.dart';
import 'models/milestone.dart';
import 'models/milestone_style.dart';
import 'utils/arc_math.dart';

/// A highly customizable circular progress indicator with milestone markers.
///
/// Example:
/// ```dart
/// ArcProgressRing(
///   progress: 0.65,
///   size: 300,
///   milestones: [
///     Milestone(position: 0.25, icon: Icon(Icons.fire)),
///     Milestone(position: 0.50, icon: Icon(Icons.bolt)),
///   ],
///   centerBuilder: (context, progress) {
///     return Text('${(progress * 100).toInt()}%');
///   },
/// )
/// ```
class ArcProgressRing extends StatelessWidget {
  /// Progress value from 0.0 to 1.0.
  final double progress;

  /// Size of the ring (width and height).
  ///
  /// If null, the widget will size itself based on parent constraints.
  final double? size;

  /// Width of the arc stroke.
  ///
  /// If null, defaults to 8% of the size.
  final double? strokeWidth;

  /// Gap angle at the bottom in radians.
  ///
  /// Defaults to pi * 0.3 (approximately 54 degrees).
  final double gapAngle;

  /// Background color of the arc.
  ///
  /// Defaults to a light gray (#EBE8E8).
  final Color backgroundColor;

  /// Progress color of the arc.
  ///
  /// Defaults to a green (#28CC7A).
  final Color progressColor;

  /// Optional gradient for the progress arc.
  ///
  /// If provided, [progressColor] is ignored.
  final Gradient? progressGradient;

  /// Stroke cap style for the arc ends.
  ///
  /// Defaults to [StrokeCap.round].
  final StrokeCap strokeCap;

  /// Animation duration when progress changes.
  ///
  /// Set to [Duration.zero] to disable animation.
  /// Defaults to 300 milliseconds.
  final Duration animationDuration;

  /// Animation curve for progress changes.
  ///
  /// Defaults to [Curves.easeOutCubic].
  final Curve animationCurve;

  /// List of milestones to display on the arc.
  final List<Milestone>? milestones;

  /// Style configuration for milestones.
  ///
  /// If null, default [MilestoneStyle] is used.
  final MilestoneStyle? milestoneStyle;

  /// Builder for the center content.
  ///
  /// Receives the current progress value.
  final Widget Function(BuildContext context, double progress)? centerBuilder;

  /// Optional widget to display at the bottom of the ring.
  ///
  /// Typically used for a chip or button.
  final Widget? bottomWidget;

  /// Creates an arc progress ring.
  const ArcProgressRing({
    super.key,
    required this.progress,
    this.size,
    this.strokeWidth,
    this.gapAngle = math.pi * 0.3,
    this.backgroundColor = const Color(0xFFEBE8E8),
    this.progressColor = const Color(0xFF28CC7A),
    this.progressGradient,
    this.strokeCap = StrokeCap.round,
    this.animationDuration = const Duration(milliseconds: 300),
    this.animationCurve = Curves.easeOutCubic,
    this.milestones,
    this.milestoneStyle,
    this.centerBuilder,
    this.bottomWidget,
  }) : assert(
         progress >= 0.0 && progress <= 1.0,
         'Progress must be between 0.0 and 1.0',
       );

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double diameter =
            size ?? math.min(constraints.maxWidth, constraints.maxHeight);
        final double actualStrokeWidth = strokeWidth ?? diameter * 0.08;
        final double ringRadius = (diameter - actualStrokeWidth) / 2;
        final double startAngle = ArcMath.calculateStartAngle(gapAngle);
        final double sweepAngle = ArcMath.calculateSweepAngle(gapAngle);
        final effectiveStyle = milestoneStyle ?? const MilestoneStyle();

        return SizedBox(
          width: diameter,
          height: diameter,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Progress arc
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: progress),
                duration: animationDuration,
                curve: animationCurve,
                builder: (context, animatedProgress, child) {
                  return CustomPaint(
                    size: Size.square(diameter),
                    painter: ArcProgressPainter(
                      progress: animatedProgress,
                      strokeWidth: actualStrokeWidth,
                      backgroundColor: backgroundColor,
                      progressColor: progressColor,
                      progressGradient: progressGradient,
                      gapAngle: gapAngle,
                      strokeCap: strokeCap,
                    ),
                  );
                },
              ),

              // Center content
              if (centerBuilder != null)
                Positioned.fill(
                  child: Center(child: centerBuilder!(context, progress)),
                ),

              // Milestones
              if (milestones != null)
                ..._buildMilestones(
                  diameter: diameter,
                  ringRadius: ringRadius,
                  startAngle: startAngle,
                  sweepAngle: sweepAngle,
                  style: effectiveStyle,
                ),

              // Bottom widget
              if (bottomWidget != null)
                Positioned(
                  bottom: actualStrokeWidth / 2 - 17.5,
                  left: 0,
                  right: 0,
                  child: Center(child: bottomWidget!),
                ),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildMilestones({
    required double diameter,
    required double ringRadius,
    required double startAngle,
    required double sweepAngle,
    required MilestoneStyle style,
  }) {
    if (milestones == null || milestones!.isEmpty) return [];

    return milestones!.map((milestone) {
      final isActive = _isMilestoneActive(milestone.position);

      return MilestoneIconWidget(
        key: ValueKey(milestone.position),
        milestone: milestone,
        style: style,
        diameter: diameter,
        ringRadius: ringRadius,
        startAngle: startAngle,
        sweepAngle: sweepAngle,
        progress: progress,
        isActive: isActive,
      );
    }).toList();
  }

  /// Determines if a milestone is the current active (next) target.
  ///
  /// The active milestone is the next one the progress hasn't reached yet.
  bool _isMilestoneActive(double position) {
    if (milestones == null || milestones!.isEmpty) return false;

    // Sort milestones by position
    final sorted = [...milestones!]
      ..sort((a, b) => a.position.compareTo(b.position));

    // Find the first milestone that hasn't been reached
    for (final m in sorted) {
      if (progress < m.position) {
        return m.position == position;
      }
    }

    // All milestones passed - none active
    return false;
  }
}
