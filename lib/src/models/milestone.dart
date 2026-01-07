import 'package:flutter/material.dart';

/// Represents a milestone marker on the progress arc.
///
/// Milestones are positioned along the arc based on their [position] value,
/// which ranges from 0.0 (start) to 1.0 (end).
///
/// Example:
/// ```dart
/// Milestone(
///   position: 0.25,
///   icon: Icon(Icons.local_fire_department, color: Colors.orange),
///   label: 'Fat Burn',
/// )
/// ```
class Milestone {
  /// Position on the arc from 0.0 (start) to 1.0 (end).
  ///
  /// For example:
  /// - 0.25 = 25% around the arc
  /// - 0.50 = 50% around the arc (halfway)
  /// - 0.75 = 75% around the arc
  final double position;

  /// The widget to display at this milestone.
  ///
  /// Typically an [Icon] or [Image], but can be any widget.
  final Widget icon;

  /// Optional label for the milestone.
  final String? label;

  /// Optional callback when the milestone is tapped.
  final VoidCallback? onTap;

  /// Creates a milestone marker.
  ///
  /// [position] must be between 0.0 and 1.0.
  /// [icon] is the widget displayed at this position on the arc.
  const Milestone({
    required this.position,
    required this.icon,
    this.label,
    this.onTap,
  }) : assert(
         position >= 0.0 && position <= 1.0,
         'Position must be between 0.0 and 1.0',
       );
}
