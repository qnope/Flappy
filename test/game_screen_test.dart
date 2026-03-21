import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flappy/game/game_screen.dart';
import 'package:flappy/game/bird_widget.dart';
import 'package:flappy/game/clouds_widget.dart';
import 'package:flappy/game/pipe_widget.dart';
import 'package:flappy/game/game_constants.dart';

Widget createTestApp() {
  return const MaterialApp(home: GameScreen());
}

void main() {
  group('GameScreen rendering', () {
    testWidgets('renders background', (tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pump();

      final svgWidgets =
          tester.widgetList<SvgPicture>(find.byType(SvgPicture));
      final hasBackground = svgWidgets.any((svg) {
        final bytesLoader = svg.bytesLoader;
        return bytesLoader is SvgAssetLoader &&
            bytesLoader.assetName == 'assets/images/background.svg';
      });
      expect(hasBackground, isTrue);
    });

    testWidgets('renders ground', (tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pump();

      final svgWidgets =
          tester.widgetList<SvgPicture>(find.byType(SvgPicture));
      final hasGround = svgWidgets.any((svg) {
        final bytesLoader = svg.bytesLoader;
        return bytesLoader is SvgAssetLoader &&
            bytesLoader.assetName == 'assets/images/ground.svg';
      });
      expect(hasGround, isTrue);
    });

    testWidgets('renders bird', (tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pump();

      final svgWidgets =
          tester.widgetList<SvgPicture>(find.byType(SvgPicture));
      final hasBird = svgWidgets.any((svg) {
        final bytesLoader = svg.bytesLoader;
        return bytesLoader is SvgAssetLoader &&
            bytesLoader.assetName.contains('bird_');
      });
      expect(hasBird, isTrue);
    });

    testWidgets('renders clouds', (tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pump();

      expect(find.byType(CloudsWidget), findsOneWidget);

      final svgWidgets =
          tester.widgetList<SvgPicture>(find.byType(SvgPicture));
      final hasClouds = svgWidgets.any((svg) {
        final bytesLoader = svg.bytesLoader;
        return bytesLoader is SvgAssetLoader &&
            bytesLoader.assetName == 'assets/images/clouds.svg';
      });
      expect(hasClouds, isTrue);
    });

    testWidgets('shows tap to start text initially', (tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pump();

      expect(find.text('Tap to start'), findsOneWidget);
    });
  });

  group('GameScreen tap interaction', () {
    testWidgets('tap hides start text', (tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pump();

      expect(find.text('Tap to start'), findsOneWidget);

      await tester.tap(find.byType(GestureDetector));
      await tester.pump();

      expect(find.text('Tap to start'), findsNothing);
    });

    testWidgets('tap triggers state change and gravity affects bird',
        (tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pump();

      final birdBefore = tester.widget<Align>(
        find.byKey(const ValueKey('bird')),
      );
      final initialY = (birdBefore.alignment as Alignment).y;

      await tester.tap(find.byType(GestureDetector));
      await tester.pump(const Duration(milliseconds: 16));

      final birdAfterTap = tester.widget<Align>(
        find.byKey(const ValueKey('bird')),
      );
      expect((birdAfterTap.alignment as Alignment).y, lessThan(initialY));

      // Pump many frames to let gravity pull bird back down past the tap position
      for (int i = 0; i < 60; i++) {
        await tester.pump(const Duration(milliseconds: 16));
      }

      final birdAfterFall = tester.widget<Align>(
        find.byKey(const ValueKey('bird')),
      );
      expect((birdAfterFall.alignment as Alignment).y, greaterThan((birdAfterTap.alignment as Alignment).y));
    });
  });

  group('GameScreen animation', () {
    testWidgets('bird sprite changes during idle', (tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pump();

      String getCurrentBirdSprite() {
        final svgWidgets =
            tester.widgetList<SvgPicture>(find.byType(SvgPicture));
        for (final svg in svgWidgets) {
          final bytesLoader = svg.bytesLoader;
          if (bytesLoader is SvgAssetLoader &&
              bytesLoader.assetName.contains('bird_')) {
            return bytesLoader.assetName;
          }
        }
        return '';
      }

      final sprites = <String>{};
      for (int i = 0; i < 40; i++) {
        await tester.pump(const Duration(milliseconds: 50));
        sprites.add(getCurrentBirdSprite());
      }

      expect(sprites.length, greaterThan(1));
    });

    testWidgets('bird shows mid sprite when falling', (tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pump();

      await tester.tap(find.byType(GestureDetector));

      // Pump enough frames for bird to start falling
      for (int i = 0; i < 40; i++) {
        await tester.pump(const Duration(milliseconds: 16));
      }

      final svgWidgets =
          tester.widgetList<SvgPicture>(find.byType(SvgPicture));
      String birdSprite = '';
      for (final svg in svgWidgets) {
        final bytesLoader = svg.bytesLoader;
        if (bytesLoader is SvgAssetLoader &&
            bytesLoader.assetName.contains('bird_')) {
          birdSprite = bytesLoader.assetName;
          break;
        }
      }
      expect(birdSprite, equals('assets/images/bird_mid.svg'));
    });
  });

  group('GameScreen rotation', () {
    testWidgets('bird has no rotation in idle state', (tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pump();

      final bird = tester.widget<BirdWidget>(
        find.descendant(
          of: find.byKey(const ValueKey('bird')),
          matching: find.byType(BirdWidget),
        ),
      );
      expect(bird.rotation, closeTo(0.0, 0.001));
    });

    testWidgets('bird rotates upward after tap', (tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pump();

      await tester.tap(find.byType(GestureDetector));
      await tester.pump(const Duration(milliseconds: 16));

      final bird = tester.widget<BirdWidget>(
        find.descendant(
          of: find.byKey(const ValueKey('bird')),
          matching: find.byType(BirdWidget),
        ),
      );
      expect(bird.rotation, lessThan(0));
    });
  });

  group('GameScreen pipes', () {
    testWidgets('pipe widgets present during idle', (tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pump();

      expect(find.byType(PipeWidget), findsWidgets);
    });

    testWidgets('pipe widgets present during playing', (tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pump();

      await tester.tap(find.byType(GestureDetector));
      await tester.pump();

      expect(find.byType(PipeWidget), findsWidgets);
    });

    testWidgets('correct number of pipe widgets', (tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pump();

      expect(find.byType(PipeWidget), findsNWidgets(GameConstants.pipePoolSize));
    });
  });

  group('GameScreen game over overlay', () {
    testWidgets('game over overlay not visible in idle', (tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pump();

      final animatedOpacity = tester.widget<AnimatedOpacity>(
        find.byType(AnimatedOpacity),
      );
      expect(animatedOpacity.opacity, equals(0.0));
    });

    testWidgets('game over overlay visible in gameOver', (tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pump();

      // Tap to start playing
      await tester.tap(find.byType(GestureDetector));
      await tester.pump();

      // Pump many frames so bird falls to ground and triggers gameOver
      for (int i = 0; i < 300; i++) {
        await tester.pump(const Duration(milliseconds: 16));
      }

      final animatedOpacity = tester.widget<AnimatedOpacity>(
        find.byType(AnimatedOpacity),
      );
      expect(animatedOpacity.opacity, equals(1.0));
      expect(find.text('Game Over'), findsOneWidget);
    });

    testWidgets('game over shows final score', (tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pump();

      // Tap to start playing
      await tester.tap(find.byType(GestureDetector));
      await tester.pump();

      // Pump many frames so bird falls to ground and triggers gameOver
      for (int i = 0; i < 300; i++) {
        await tester.pump(const Duration(milliseconds: 16));
      }

      expect(find.text('Score: 0'), findsOneWidget);
    });

    testWidgets('tap during gameOver restarts game', (tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pump();

      // Tap to start playing
      await tester.tap(find.byType(GestureDetector));
      await tester.pump();

      // Pump many frames so bird falls to ground and triggers gameOver
      for (int i = 0; i < 300; i++) {
        await tester.pump(const Duration(milliseconds: 16));
      }

      expect(find.text('Game Over'), findsOneWidget);

      // Tap to restart
      await tester.tap(find.byType(GestureDetector));
      await tester.pump();

      expect(find.text('Tap to start'), findsOneWidget);
    });
  });

  group('GameScreen score display', () {
    testWidgets('score not visible in idle', (tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pump();

      expect(find.text('0'), findsNothing);
    });

    testWidgets('score visible during playing', (tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pump();

      await tester.tap(find.byType(GestureDetector));
      await tester.pump();

      expect(find.text('0'), findsOneWidget);
    });

    testWidgets('score text has correct style', (tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pump();

      await tester.tap(find.byType(GestureDetector));
      await tester.pump();

      final scoreWidget = tester.widget<Text>(find.text('0'));
      expect(scoreWidget.style!.fontSize, equals(48));
      expect(scoreWidget.style!.color, equals(Colors.white));
      expect(scoreWidget.style!.fontWeight, equals(FontWeight.bold));
    });
  });
}
