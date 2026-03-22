import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flappy/game/background_widget.dart';
import 'package:flappy/game/bird_widget.dart';
import 'package:flappy/game/clouds_widget.dart';
import 'package:flappy/game/game_layers_widget.dart';
import 'package:flappy/game/ground_widget.dart';
import 'package:flappy/game/pipe.dart';
import 'package:flappy/game/pipe_widget.dart';
import 'package:flappy/game/wing.dart';

Widget buildTestWidget(Widget child) {
  return MaterialApp(
    home: Scaffold(
      body: SizedBox(
        width: 288,
        height: 512,
        child: child,
      ),
    ),
  );
}

GameLayersWidget createGameLayers({
  List<Pipe>? pipes,
  double birdPosY = 100,
  double screenHeight = 512,
  double screenWidth = 288,
  Wing birdWing = Wing.mid,
  double birdRotation = 0.0,
  List<Widget> overlays = const [],
}) {
  return GameLayersWidget(
    cloudsScrollOffset: 0.0,
    groundScrollOffset: 0.0,
    pipes: pipes ?? [Pipe(posX: 200, gapCenterY: 200, gapSize: 150)],
    birdPosY: birdPosY,
    birdWing: birdWing,
    birdRotation: birdRotation,
    screenHeight: screenHeight,
    screenWidth: screenWidth,
    overlays: overlays,
  );
}

void main() {
  group('GameLayersWidget', () {
    testWidgets('renders all layers', (tester) async {
      final widget = createGameLayers();
      await tester.pumpWidget(buildTestWidget(widget));
      await tester.pump();

      expect(find.byType(BackgroundWidget), findsOneWidget);
      expect(find.byType(CloudsWidget), findsOneWidget);
      expect(find.byType(GroundWidget), findsOneWidget);
      expect(find.byType(BirdWidget), findsOneWidget);
      expect(find.byType(PipeWidget), findsOneWidget);
    });

    testWidgets('renders overlays', (tester) async {
      const overlayKey = ValueKey('test-overlay');
      final overlay = Positioned.fill(
        child: Container(key: overlayKey, color: Colors.red),
      );

      final widget = createGameLayers(overlays: [overlay]);
      await tester.pumpWidget(buildTestWidget(widget));
      await tester.pump();

      expect(find.byKey(overlayKey), findsOneWidget);
    });

    testWidgets('bird alignment based on posY and screenHeight', (tester) async {
      const birdPosY = 100.0;
      const screenHeight = 512.0;
      final widget = createGameLayers(
        birdPosY: birdPosY,
        screenHeight: screenHeight,
      );
      await tester.pumpWidget(buildTestWidget(widget));
      await tester.pump();

      final expectedAlignedY = birdPosY / screenHeight * 2 - 1;

      final alignFinder = find.byKey(const ValueKey('bird'));
      expect(alignFinder, findsOneWidget);

      final alignWidget = tester.widget<Align>(alignFinder);
      expect(alignWidget.alignment, equals(Alignment(0, expectedAlignedY)));
    });

    testWidgets('pipe positioning at correct X coordinates', (tester) async {
      final pipe = Pipe(posX: 200, gapCenterY: 200, gapSize: 150);
      final widget = createGameLayers(pipes: [pipe]);
      await tester.pumpWidget(buildTestWidget(widget));
      await tester.pump();

      final positionedFinder = find.byType(Positioned);
      final positionedWidgets =
          tester.widgetList<Positioned>(positionedFinder).toList();

      // Find the Positioned that wraps the PipeWidget
      // It should have left = pipe.posX - pipeCapWidth / 2 = 200 - 30 = 170
      final pipePositioned = positionedWidgets.firstWhere(
        (p) => p.left == 170.0 && p.top == 0 && p.bottom == 0,
      );
      expect(pipePositioned.left, equals(170.0));
      expect(pipePositioned.width, equals(60.0));
    });
  });
}
