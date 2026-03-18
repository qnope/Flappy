import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flappy/game/game_screen.dart';

void main() {
  group('Game flow integration', () {
    testWidgets('full game flow: idle, tap to start, gravity, tap to jump',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(288, 512));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(const MaterialApp(home: GameScreen()));
      await tester.pump();

      // Verify idle state
      expect(find.text('Tap to start'), findsOneWidget);

      final birdIdle = tester.widget<Positioned>(
        find.byKey(const ValueKey('bird')),
      );
      final idleY = birdIdle.top!;

      // Tap to start
      await tester.tap(find.byType(GestureDetector));
      await tester.pump(const Duration(milliseconds: 16));

      // Bird should move upward after tap
      final birdAfterTap = tester.widget<Positioned>(
        find.byKey(const ValueKey('bird')),
      );
      expect(birdAfterTap.top!, lessThan(idleY));

      // Pump frames until bird starts falling (past the peak)
      for (int i = 0; i < 60; i++) {
        await tester.pump(const Duration(milliseconds: 16));
      }

      final birdFalling = tester.widget<Positioned>(
        find.byKey(const ValueKey('bird')),
      );
      // Bird should have fallen back past idle position
      expect(birdFalling.top!, greaterThan(birdAfterTap.top!));

      // Tap again to jump
      await tester.tap(find.byType(GestureDetector));
      await tester.pump(const Duration(milliseconds: 16));

      final birdAfterSecondTap = tester.widget<Positioned>(
        find.byKey(const ValueKey('bird')),
      );
      // Bird should have moved up from the falling position
      expect(birdAfterSecondTap.top!, lessThan(birdFalling.top!));

      // Verify tap to start text is gone
      expect(find.text('Tap to start'), findsNothing);
    });

    testWidgets('ground collision stops bird', (tester) async {
      await tester.binding.setSurfaceSize(const Size(288, 512));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(const MaterialApp(home: GameScreen()));
      await tester.pump();

      // Tap to start
      await tester.tap(find.byType(GestureDetector));

      // Pump many frames without tapping — bird should fall to ground
      for (int i = 0; i < 200; i++) {
        await tester.pump(const Duration(milliseconds: 16));
      }

      final birdAtGround = tester.widget<Positioned>(
        find.byKey(const ValueKey('bird')),
      );
      final groundY = birdAtGround.top!;

      // Pump more frames — bird Y should NOT increase further
      for (int i = 0; i < 30; i++) {
        await tester.pump(const Duration(milliseconds: 16));
      }

      final birdStill = tester.widget<Positioned>(
        find.byKey(const ValueKey('bird')),
      );
      expect(birdStill.top!, closeTo(groundY, 0.001));
    });

    testWidgets('bird can exit top of screen', (tester) async {
      await tester.binding.setSurfaceSize(const Size(288, 512));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(const MaterialApp(home: GameScreen()));
      await tester.pump();

      // Tap to start
      await tester.tap(find.byType(GestureDetector));
      await tester.pump(const Duration(milliseconds: 16));

      // Tap rapidly to send bird very high
      for (int i = 0; i < 20; i++) {
        await tester.tap(find.byType(GestureDetector));
        await tester.pump(const Duration(milliseconds: 50));
      }

      final birdHigh = tester.widget<Positioned>(
        find.byKey(const ValueKey('bird')),
      );
      // Bird should be above the top of the screen (negative Y)
      expect(birdHigh.top!, lessThan(0));
    });
  });
}
