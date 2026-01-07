import 'package:arc_progress_ring/arc_progress_ring.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Arc Progress Ring Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    BasicExample(),
    MilestonesExample(),
    CustomizedExample(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.circle_outlined),
            label: 'Basic',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.flag), label: 'Milestones'),
          BottomNavigationBarItem(
            icon: Icon(Icons.palette),
            label: 'Customized',
          ),
        ],
      ),
    );
  }
}

/// Basic usage example
class BasicExample extends StatefulWidget {
  const BasicExample({super.key});

  @override
  State<BasicExample> createState() => _BasicExampleState();
}

class _BasicExampleState extends State<BasicExample> {
  double _progress = 0.35;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Basic Example'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Spacer(),

            // Basic ring
            Center(
              child: ArcProgressRing(
                progress: _progress,
                size: 280,
                centerBuilder: (context, progress) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${(progress * 100).toInt()}%',
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        'Progress',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  );
                },
              ),
            ),

            const Spacer(),

            // Controls
            _buildControls(),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildControls() {
    return Column(
      children: [
        Text(
          'Progress: ${(_progress * 100).toInt()}%',
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 10),
        Slider(
          value: _progress,
          onChanged: (value) => setState(() => _progress = value),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildQuickButton('0%', 0.0),
            _buildQuickButton('25%', 0.25),
            _buildQuickButton('50%', 0.50),
            _buildQuickButton('75%', 0.75),
            _buildQuickButton('100%', 1.0),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickButton(String label, double value) {
    final isActive = (_progress - value).abs() < 0.01;
    return ElevatedButton(
      onPressed: () => setState(() => _progress = value),
      style: ElevatedButton.styleFrom(
        backgroundColor: isActive ? Colors.green : null,
        foregroundColor: isActive ? Colors.white : null,
      ),
      child: Text(label),
    );
  }
}

/// Milestones example
class MilestonesExample extends StatefulWidget {
  const MilestonesExample({super.key});

  @override
  State<MilestonesExample> createState() => _MilestonesExampleState();
}

class _MilestonesExampleState extends State<MilestonesExample> {
  double _progress = 0.0;
  bool _isRunning = false;

  void _startProgress() {
    if (_isRunning) return;

    setState(() {
      _isRunning = true;
      _progress = 0.0;
    });

    _animateProgress();
  }

  void _animateProgress() async {
    for (int i = 0; i <= 100; i++) {
      if (!mounted || !_isRunning) break;

      await Future.delayed(const Duration(milliseconds: 50));

      if (mounted) {
        setState(() => _progress = i / 100);
      }
    }

    if (mounted) {
      setState(() => _isRunning = false);
    }
  }

  void _reset() {
    setState(() {
      _isRunning = false;
      _progress = 0.0;
    });
  }

  String _getStageText() {
    if (_progress < 0.25) return 'Starting...';
    if (_progress < 0.50) return '🔥 Fat Burning';
    if (_progress < 0.75) return '⚡ Ketosis';
    if (_progress < 1.0) return '✨ Autophagy';
    return '🎉 Complete!';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Milestones Example'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Spacer(),

            // Ring with milestones
            Center(
              child: ArcProgressRing(
                progress: _progress,
                size: 300,
                strokeWidth: 28,
                progressColor: const Color(0xFF28CC7A),
                backgroundColor: const Color(0xFFEBE8E8),
                milestones: [
                  Milestone(
                    position: 0.25,
                    icon: Image.asset(
                      'assets/fire.png',
                      errorBuilder: (_, _, _) => const Icon(
                        Icons.local_fire_department,
                        color: Colors.orange,
                        size: 24,
                      ),
                    ),
                    label: 'Fat Burn',
                  ),
                  Milestone(
                    position: 0.50,
                    icon: Image.asset(
                      'assets/flash.png',
                      errorBuilder: (_, _, _) =>
                          const Icon(Icons.bolt, color: Colors.amber, size: 24),
                    ),
                    label: 'Ketosis',
                  ),
                  Milestone(
                    position: 0.75,
                    icon: Image.asset(
                      'assets/blood.png',
                      errorBuilder: (_, _, _) => const Icon(
                        Icons.auto_awesome,
                        color: Colors.purple,
                        size: 24,
                      ),
                    ),
                    label: 'Autophagy',
                  ),
                ],
                milestoneStyle: const MilestoneStyle(
                  activeSize: 55,
                  inactiveSize: 35,
                  enableGlassEffect: true,
                  blurSigma: 4,
                ),
                centerBuilder: (context, progress) {
                  final hours = (progress * 16).toInt();
                  final minutes = ((progress * 16 - hours) * 60).toInt();

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'FASTING',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:00',
                        style: const TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        _getStageText(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  );
                },
                bottomWidget: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '16:8',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.edit, size: 16),
                    ],
                  ),
                ),
              ),
            ),

            const Spacer(),

            // Controls
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _isRunning ? null : _startProgress,
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Start'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: _reset,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reset'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Progress slider
            Slider(
              value: _progress,
              onChanged: _isRunning
                  ? null
                  : (value) => setState(() => _progress = value),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

/// Customized example
class CustomizedExample extends StatefulWidget {
  const CustomizedExample({super.key});

  @override
  State<CustomizedExample> createState() => _CustomizedExampleState();
}

class _CustomizedExampleState extends State<CustomizedExample> {
  double _progress = 0.65;
  Color _progressColor = Colors.blue;
  double _strokeWidth = 24;
  double _gapAngle = 0.3;
  bool _enableGlassEffect = true;

  final List<Color> _colors = [
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.red,
    Colors.teal,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customized Example'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Ring
            Center(
              child: ArcProgressRing(
                progress: _progress,
                size: 260,
                strokeWidth: _strokeWidth,
                gapAngle: _gapAngle * 3.14159,
                progressColor: _progressColor,
                backgroundColor: _progressColor.withValues(alpha: 0.2),
                milestones: [
                  Milestone(
                    position: 0.33,
                    icon: Icon(Icons.star, color: _progressColor, size: 20),
                  ),
                  Milestone(
                    position: 0.66,
                    icon: Icon(Icons.star, color: _progressColor, size: 20),
                  ),
                ],
                milestoneStyle: MilestoneStyle(
                  activeSize: 45,
                  inactiveSize: 30,
                  enableGlassEffect: _enableGlassEffect,
                ),
                centerBuilder: (context, progress) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.trending_up, size: 32, color: _progressColor),
                      const SizedBox(height: 8),
                      Text(
                        '${(progress * 100).toInt()}%',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: _progressColor,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            const SizedBox(height: 40),

            // Progress slider
            _buildSliderRow(
              label: 'Progress',
              value: _progress,
              min: 0,
              max: 1,
              onChanged: (v) => setState(() => _progress = v),
              displayValue: '${(_progress * 100).toInt()}%',
            ),

            // Stroke width slider
            _buildSliderRow(
              label: 'Stroke Width',
              value: _strokeWidth,
              min: 8,
              max: 40,
              onChanged: (v) => setState(() => _strokeWidth = v),
              displayValue: _strokeWidth.toInt().toString(),
            ),

            // Gap angle slider
            _buildSliderRow(
              label: 'Gap Angle',
              value: _gapAngle,
              min: 0.1,
              max: 0.8,
              onChanged: (v) => setState(() => _gapAngle = v),
              displayValue: _gapAngle.toStringAsFixed(2),
            ),

            const SizedBox(height: 20),

            // Color picker
            const Text(
              'Progress Color',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              children: _colors.map((color) {
                final isSelected = color == _progressColor;
                return GestureDetector(
                  onTap: () => setState(() => _progressColor = color),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? Colors.black : Colors.transparent,
                        width: 3,
                      ),
                    ),
                    child: isSelected
                        ? const Icon(Icons.check, color: Colors.white, size: 20)
                        : null,
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            // Glass effect toggle
            SwitchListTile(
              title: const Text('Glass Effect'),
              subtitle: const Text('Enable glassmorphic milestone style'),
              value: _enableGlassEffect,
              onChanged: (v) => setState(() => _enableGlassEffect = v),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSliderRow({
    required String label,
    required double value,
    required double min,
    required double max,
    required ValueChanged<double> onChanged,
    required String displayValue,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Slider(
              value: value,
              min: min,
              max: max,
              onChanged: onChanged,
            ),
          ),
          SizedBox(
            width: 50,
            child: Text(displayValue, textAlign: TextAlign.right),
          ),
        ],
      ),
    );
  }
}
