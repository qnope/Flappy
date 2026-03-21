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

      final birdIdle = tester.widget<Align>(
        find.byKey(const ValueKey('bird')),
      );
      final idleY = (birdIdle.alignment as Alignment).y;

      // Tap to start
      await tester.tap(find.byType(GestureDetector));
      await tester.pump(const Duration(milliseconds: 16));

      // Bird should move upward after tap
      final birdAfterTap = tester.widget<Align>(
        find.byKey(const ValueKey('bird')),
      );
      expect((birdAfterTap.alignment as Alignment).y, lessThan(idleY));

      // Pump frames until bird starts falling (past the peak)
      for (int i = 0; i < 50; i++) {
        await tester.pump(const Duration(milliseconds: 16));
      }

      final birdFalling = tester.widget<Align>(
        find.byKey(const ValueKey('bird')),
      );
      // Bird should have fallen back past idle position
      expect((birdFalling.alignment as Alignment).y, greaterThan((birdAfterTap.alignment as Alignment).y));

      // Tap again to jump
      await tester.tap(find.byType(GestureDetector));
      await tester.pump(const Duration(milliseconds: 16));

      final birdAfterSecondTap = tester.widget<Align>(
        find.byKey(const ValueKey('bird')),
      );
      // Bird should have moved up from the falling position
      expect((birdAfterSecondTap.alignment as Alignment).y, lessThan((birdFalling.alignment as Alignment).y));

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

      final birdAtGround = tester.widget<Align>(
        find.byKey(const ValueKey('bird')),
      );
      final groundY = (birdAtGround.alignment as Alignment).y;

      // Pump more frames — bird Y should NOT increase further
      for (int i = 0; i < 30; i++) {
        await tester.pump(const Duration(milliseconds: 16));
      }

      final birdStill = tester.widget<Align>(
        find.byKey(const ValueKey('bird')),
      );
      expect((birdStill.alignment as Alignment).y, closeTo(groundY, 0.001));
    });

    testWidgets('full game cycle: idle → playing → gameOver → idle',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(288, 512));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(const MaterialApp(home: GameScreen()));
      await tester.pump();

      // Verify idle state
      expect(find.text('Tap to start'), findsOneWidget);

      // Tap to start playing
      await tester.tap(find.byType(GestureDetector));
      await tester.pump();
      expect(find.text('Tap to start'), findsNothing);

      // Let bird fall to ground to trigger gameOver
      for (int i = 0; i < 200; i++) {
        await tester.pump(const Duration(milliseconds: 16));
      }

      // Verify game over overlay is showing
      expect(find.text('Game Over'), findsOneWidget);

      // Tap to restart
      await tester.tap(find.byType(GestureDetector));
      await tester.pump();

      // Verify back in idle
      expect(find.text('Tap to start'), findsOneWidget);
      // Game over overlay is always in tree but hidden via AnimatedOpacity
      final animatedOpacity = tester.widget<AnimatedOpacity>(
        find.byType(AnimatedOpacity),
      );
      expect(animatedOpacity.opacity, equals(0.0));
    });

    testWidgets('score visible during dying phase', (tester) async {
      await tester.binding.setSurfaceSize(const Size(288, 512));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(const MaterialApp(home: GameScreen()));
      await tester.pump();

      // Tap to start playing
      await tester.tap(find.byType(GestureDetector));
      await tester.pump();

      // Score should be visible during playing
      expect(find.text('0'), findsOneWidget);

      // Let bird fall to ground (game will go through playing → gameOver)
      for (int i = 0; i < 200; i++) {
        await tester.pump(const Duration(milliseconds: 16));
      }

      // In game over, the score should be shown in the overlay
      expect(find.text('Score: 0'), findsOneWidget);
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

      final birdHigh = tester.widget<Align>(
        find.byKey(const ValueKey('bird')),
      );
      // Bird should be above the top of the screen (alignment.y < -1)
      expect((birdHigh.alignment as Alignment).y, lessThan(-1));
    });
  });
}
