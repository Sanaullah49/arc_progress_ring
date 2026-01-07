import 'package:arc_progress_ring/arc_progress_ring.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ArcProgressRing', () {
    testWidgets('renders without errors', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: ArcProgressRing(progress: 0.5, size: 200)),
        ),
      );

      expect(find.byType(ArcProgressRing), findsOneWidget);
    });

    testWidgets('renders with zero progress', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: ArcProgressRing(progress: 0.0, size: 200)),
        ),
      );

      expect(find.byType(ArcProgressRing), findsOneWidget);
    });

    testWidgets('renders with full progress', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: ArcProgressRing(progress: 1.0, size: 200)),
        ),
      );

      expect(find.byType(ArcProgressRing), findsOneWidget);
    });

    testWidgets('renders with custom colors', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ArcProgressRing(
              progress: 0.5,
              size: 200,
              progressColor: Colors.red,
              backgroundColor: Colors.grey,
            ),
          ),
        ),
      );

      expect(find.byType(ArcProgressRing), findsOneWidget);
    });

    testWidgets('renders with custom stroke width', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ArcProgressRing(progress: 0.5, size: 200, strokeWidth: 30),
          ),
        ),
      );

      expect(find.byType(ArcProgressRing), findsOneWidget);
    });

    testWidgets('renders center content', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ArcProgressRing(
              progress: 0.5,
              size: 200,
              centerBuilder: (context, progress) {
                return Text('${(progress * 100).toInt()}%');
              },
            ),
          ),
        ),
      );

      expect(find.text('50%'), findsOneWidget);
    });

    testWidgets('renders with milestones', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ArcProgressRing(
              progress: 0.5,
              size: 200,
              milestones: [
                Milestone(position: 0.25, icon: Icon(Icons.star)),
                Milestone(position: 0.75, icon: Icon(Icons.star)),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(ArcProgressRing), findsOneWidget);
      expect(find.byIcon(Icons.star), findsNWidgets(2));
    });

    testWidgets('renders bottom widget', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ArcProgressRing(
              progress: 0.5,
              size: 200,
              bottomWidget: Text('16:8'),
            ),
          ),
        ),
      );

      expect(find.text('16:8'), findsOneWidget);
    });

    testWidgets('renders with gradient', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ArcProgressRing(
              progress: 0.5,
              size: 200,
              progressGradient: LinearGradient(
                colors: [Colors.blue, Colors.purple],
              ),
            ),
          ),
        ),
      );

      expect(find.byType(ArcProgressRing), findsOneWidget);
    });

    testWidgets('adapts to parent size when size is null', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 300,
              height: 300,
              child: ArcProgressRing(progress: 0.5),
            ),
          ),
        ),
      );

      expect(find.byType(ArcProgressRing), findsOneWidget);
    });

    testWidgets('milestone style is applied', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ArcProgressRing(
              progress: 0.5,
              size: 200,
              milestones: [Milestone(position: 0.5, icon: Icon(Icons.star))],
              milestoneStyle: MilestoneStyle(
                activeSize: 60,
                inactiveSize: 40,
                enableGlassEffect: false,
              ),
            ),
          ),
        ),
      );

      expect(find.byType(ArcProgressRing), findsOneWidget);
    });
  });

  group('Milestone', () {
    test('creates with required parameters', () {
      const milestone = Milestone(position: 0.5, icon: Icon(Icons.star));

      expect(milestone.position, 0.5);
      expect(milestone.label, isNull);
      expect(milestone.onTap, isNull);
    });

    test('creates with all parameters', () {
      final milestone = Milestone(
        position: 0.5,
        icon: const Icon(Icons.star),
        label: 'Halfway',
        onTap: () {},
      );

      expect(milestone.position, 0.5);
      expect(milestone.label, 'Halfway');
      expect(milestone.onTap, isNotNull);
    });
  });

  group('MilestoneStyle', () {
    test('creates with default values', () {
      const style = MilestoneStyle();

      expect(style.activeSize, 50);
      expect(style.inactiveSize, 30);
      expect(style.enableGlassEffect, true);
      expect(style.blurSigma, 4);
      expect(style.borderWidth, 1.5);
      expect(style.iconScale, 0.55);
    });

    test('creates with custom values', () {
      const style = MilestoneStyle(
        activeSize: 60,
        inactiveSize: 40,
        enableGlassEffect: false,
        blurSigma: 8,
        borderWidth: 2,
        iconScale: 0.6,
      );

      expect(style.activeSize, 60);
      expect(style.inactiveSize, 40);
      expect(style.enableGlassEffect, false);
      expect(style.blurSigma, 8);
      expect(style.borderWidth, 2);
      expect(style.iconScale, 0.6);
    });

    test('copyWith creates new instance with updated values', () {
      const original = MilestoneStyle();
      final copied = original.copyWith(
        activeSize: 70,
        enableGlassEffect: false,
      );

      expect(copied.activeSize, 70);
      expect(copied.inactiveSize, 30); // unchanged
      expect(copied.enableGlassEffect, false);
      expect(copied.blurSigma, 4); // unchanged
    });
  });

  group('Animation', () {
    testWidgets('animates progress change', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ArcProgressRing(
              progress: 0.0,
              size: 200,
              animationDuration: Duration(milliseconds: 300),
            ),
          ),
        ),
      );

      // Change progress
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ArcProgressRing(
              progress: 1.0,
              size: 200,
              animationDuration: Duration(milliseconds: 300),
            ),
          ),
        ),
      );

      // Pump frames to animate
      await tester.pump(const Duration(milliseconds: 150));
      await tester.pump(const Duration(milliseconds: 150));

      expect(find.byType(ArcProgressRing), findsOneWidget);
    });
  });
}
