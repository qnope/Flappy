import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flappy/game/game_screen.dart';
import 'package:flappy/game/bird_widget.dart';

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

      final birdBefore = tester.widget<Positioned>(
        find.byKey(const ValueKey('bird')),
      );
      final initialY = birdBefore.top!;

      await tester.tap(find.byType(GestureDetector));
      await tester.pump(const Duration(milliseconds: 16));

      final birdAfterTap = tester.widget<Positioned>(
        find.byKey(const ValueKey('bird')),
      );
      expect(birdAfterTap.top!, lessThan(initialY));

      // Pump many frames to let gravity pull bird back down past the tap position
      for (int i = 0; i < 60; i++) {
        await tester.pump(const Duration(milliseconds: 16));
      }

      final birdAfterFall = tester.widget<Positioned>(
        find.byKey(const ValueKey('bird')),
      );
      expect(birdAfterFall.top!, greaterThan(birdAfterTap.top!));
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
}
