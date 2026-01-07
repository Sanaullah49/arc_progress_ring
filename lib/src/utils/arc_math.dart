import 'dart:math' as math;

/// Utility class for arc-related mathematical calculations.
class ArcMath {
  ArcMath._();

  /// Calculates the X coordinate for a point on the arc.
  ///
  /// [center] - Center point of the arc.
  /// [radius] - Radius of the arc.
  /// [angle] - Angle in radians.
  static double calculateX(double center, double radius, double angle) {
    return center + radius * math.cos(angle);
  }

  /// Calculates the Y coordinate for a point on the arc.
  ///
  /// [center] - Center point of the arc.
  /// [radius] - Radius of the arc.
  /// [angle] - Angle in radians.
  static double calculateY(double center, double radius, double angle) {
    return center + radius * math.sin(angle);
  }

  /// Converts a position (0.0 to 1.0) to an angle on the arc.
  ///
  /// [position] - Position from 0.0 (start) to 1.0 (end).
  /// [startAngle] - Starting angle of the arc in radians.
  /// [sweepAngle] - Total sweep angle of the arc in radians.
  static double positionToAngle(
    double position,
    double startAngle,
    double sweepAngle,
  ) {
    return startAngle + (sweepAngle * position.clamp(0.0, 1.0));
  }

  /// Converts an angle to a position (0.0 to 1.0) on the arc.
  ///
  /// [angle] - Angle in radians.
  /// [startAngle] - Starting angle of the arc in radians.
  /// [sweepAngle] - Total sweep angle of the arc in radians.
  static double angleToPosition(
    double angle,
    double startAngle,
    double sweepAngle,
  ) {
    double normalizedAngle = angle - startAngle;
    while (normalizedAngle < 0) {
      normalizedAngle += 2 * math.pi;
    }
    while (normalizedAngle > 2 * math.pi) {
      normalizedAngle -= 2 * math.pi;
    }
    return (normalizedAngle / sweepAngle).clamp(0.0, 1.0);
  }

  /// Calculates the start angle based on gap angle.
  ///
  /// The arc starts from the bottom center, offset by half the gap.
  static double calculateStartAngle(double gapAngle) {
    return math.pi / 2 + gapAngle / 2;
  }

  /// Calculates the total sweep angle based on gap angle.
  ///
  /// The sweep angle is a full circle minus the gap.
  static double calculateSweepAngle(double gapAngle) {
    return 2 * math.pi - gapAngle;
  }
}
