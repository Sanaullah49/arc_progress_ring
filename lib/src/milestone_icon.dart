import 'dart:ui';

import 'package:flutter/material.dart';

import 'models/milestone.dart';
import 'models/milestone_style.dart';
import 'utils/arc_math.dart';

/// A glassmorphic icon widget positioned on the arc.
class MilestoneIconWidget extends StatelessWidget {
  /// The milestone data.
  final Milestone milestone;

  /// The style configuration.
  final MilestoneStyle style;

  /// Diameter of the ring.
  final double diameter;

  /// Radius of the ring (center of stroke).
  final double ringRadius;

  /// Start angle of the arc.
  final double startAngle;

  /// Sweep angle of the arc.
  final double sweepAngle;

  /// Current progress (0.0 to 1.0).
  final double progress;

  /// Whether this milestone is currently active (next target).
  final bool isActive;

  /// Creates a milestone icon widget.
  const MilestoneIconWidget({
    super.key,
    required this.milestone,
    required this.style,
    required this.diameter,
    required this.ringRadius,
    required this.startAngle,
    required this.sweepAngle,
    required this.progress,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    final center = diameter / 2;
    final iconSize = isActive ? style.activeSize : style.inactiveSize;
    final angle = ArcMath.positionToAngle(
      milestone.position,
      startAngle,
      sweepAngle,
    );

    final double x =
        ArcMath.calculateX(center, ringRadius, angle) - iconSize / 2;
    final double y =
        ArcMath.calculateY(center, ringRadius, angle) - iconSize / 2;

    return AnimatedPositioned(
      duration: style.animationDuration,
      curve: style.animationCurve,
      left: x,
      top: y,
      child: GestureDetector(
        onTap: milestone.onTap,
        child: AnimatedContainer(
          duration: style.animationDuration,
          curve: style.animationCurve,
          height: iconSize,
          width: iconSize,
          child: style.enableGlassEffect
              ? _buildGlassIcon(iconSize)
              : _buildSimpleIcon(iconSize),
        ),
      ),
    );
  }

  Widget _buildGlassIcon(double iconSize) {
    return ClipOval(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: style.blurSigma,
          sigmaY: style.blurSigma,
        ),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: style.backgroundColor != null
                ? null
                : LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withValues(alpha: 0.4),
                      Colors.white.withValues(alpha: 0.1),
                    ],
                  ),
            color: style.backgroundColor,
            border: Border.all(
              color: style.borderColor ?? Colors.white.withValues(alpha: 0.5),
              width: style.borderWidth,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.25),
                blurRadius: 1,
                offset: const Offset(0, 1),
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: SizedBox(
              width: iconSize * style.iconScale,
              height: iconSize * style.iconScale,
              child: FittedBox(fit: BoxFit.contain, child: milestone.icon),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSimpleIcon(double iconSize) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: style.backgroundColor ?? Colors.white,
        border: Border.all(
          color: style.borderColor ?? Colors.grey.shade300,
          width: style.borderWidth,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: SizedBox(
          width: iconSize * style.iconScale,
          height: iconSize * style.iconScale,
          child: FittedBox(fit: BoxFit.contain, child: milestone.icon),
        ),
      ),
    );
  }
}
