import 'package:flutter/material.dart';

/// Configuration for milestone appearance and behavior.
///
/// Example:
/// ```dart
/// MilestoneStyle(
///   activeSize: 50,
///   inactiveSize: 30,
///   enableGlassEffect: true,
///   blurSigma: 4,
/// )
/// ```
class MilestoneStyle {
  /// Size of the milestone when it's the current/next target.
  ///
  /// Defaults to 50.
  final double activeSize;

  /// Size of the milestone when it's passed or upcoming.
  ///
  /// Defaults to 30.
  final double inactiveSize;

  /// Whether to apply glassmorphic blur effect.
  ///
  /// Defaults to true.
  final bool enableGlassEffect;

  /// Blur intensity for the glass effect.
  ///
  /// Only applies when [enableGlassEffect] is true.
  /// Defaults to 4.
  final double blurSigma;

  /// Background color of the milestone container.
  ///
  /// If null, a semi-transparent white gradient is used.
  final Color? backgroundColor;

  /// Border color of the milestone container.
  ///
  /// If null, a semi-transparent white is used.
  final Color? borderColor;

  /// Border width of the milestone container.
  ///
  /// Defaults to 1.5.
  final double borderWidth;

  /// Animation duration for size transitions.
  ///
  /// Defaults to 300 milliseconds.
  final Duration animationDuration;

  /// Animation curve for size transitions.
  ///
  /// Defaults to [Curves.easeOutCubic].
  final Curve animationCurve;

  /// Icon scale relative to container size.
  ///
  /// Defaults to 0.55 (55% of container size).
  final double iconScale;

  /// Creates a milestone style configuration.
  const MilestoneStyle({
    this.activeSize = 50,
    this.inactiveSize = 30,
    this.enableGlassEffect = true,
    this.blurSigma = 4,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth = 1.5,
    this.animationDuration = const Duration(milliseconds: 300),
    this.animationCurve = Curves.easeOutCubic,
    this.iconScale = 0.55,
  });

  /// Creates a copy with the given fields replaced.
  MilestoneStyle copyWith({
    double? activeSize,
    double? inactiveSize,
    bool? enableGlassEffect,
    double? blurSigma,
    Color? backgroundColor,
    Color? borderColor,
    double? borderWidth,
    Duration? animationDuration,
    Curve? animationCurve,
    double? iconScale,
  }) {
    return MilestoneStyle(
      activeSize: activeSize ?? this.activeSize,
      inactiveSize: inactiveSize ?? this.inactiveSize,
      enableGlassEffect: enableGlassEffect ?? this.enableGlassEffect,
      blurSigma: blurSigma ?? this.blurSigma,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderColor: borderColor ?? this.borderColor,
      borderWidth: borderWidth ?? this.borderWidth,
      animationDuration: animationDuration ?? this.animationDuration,
      animationCurve: animationCurve ?? this.animationCurve,
      iconScale: iconScale ?? this.iconScale,
    );
  }
}
