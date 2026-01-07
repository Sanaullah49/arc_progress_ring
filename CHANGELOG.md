# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.1] - 2026-01-07

### Updated

- example of arc_progress_ring

## [1.0.0] - 2026-01-06

### Added

- Initial release of `arc_progress_ring`
- `ArcProgressRing` widget with customizable circular progress arc
- Support for milestone markers positioned on the arc
- Glassmorphic effect for milestone icons with blur and transparency
- `Milestone` model for defining milestone markers
- `MilestoneStyle` model for customizing milestone appearance
- `centerBuilder` for custom center content
- `bottomWidget` slot for chips, buttons, etc.
- Smooth animations for progress and milestone size changes
- Support for progress gradient
- Responsive sizing (adapts to parent or fixed size)
- Comprehensive documentation and examples
- Full test coverage

### Features

- Circular arc with customizable gap angle
- Progress indicator from 0.0 to 1.0
- Active milestone detection (highlights next target)
- Animated milestone size transitions
- Configurable colors, stroke width, and stroke cap
- Animation duration and curve customization
- Zero external dependencies