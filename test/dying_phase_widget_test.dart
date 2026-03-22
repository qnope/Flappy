import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flappy/game/background_widget.dart';
import 'package:flappy/game/bird_widget.dart';
import 'package:flappy/game/dying_phase_widget.dart';
import 'package:flappy/game/ground_widget.dart';
import 'package:flappy/game/pipe.dart';
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

DyingPhaseWidget createDyingPhase({int score = 3}) {
  return DyingPhaseWidget(
    cloudsScrollOffset: 0.0,
    groundScrollOffset: 0.0,
    pipes: [Pipe(posX: 200, gapCenterY: 200, gapSize: 150)],
    birdPosY: 100,
    birdWing: Wing.mid,
    birdRotation: 0.0,
    screenHeight: 512,
    screenWidth: 288,
    score: score,
  );
}

void main() {
  group('DyingPhaseWidget', () {
    testWidgets('score display shows score during dying', (tester) async {
      final widget = createDyingPhase(score: 12);
      await tester.pumpWidget(buildTestWidget(widget));
      await tester.pump();

      expect(find.text('12'), findsOneWidget);
    });

    testWidgets('layers present: background, bird, ground', (tester) async {
      final widget = createDyingPhase();
      await tester.pumpWidget(buildTestWidget(widget));
      await tester.pump();

      expect(find.byType(BackgroundWidget), findsOneWidget);
      expect(find.byType(BirdWidget), findsOneWidget);
      expect(find.byType(GroundWidget), findsOneWidget);
    });
  });
}
