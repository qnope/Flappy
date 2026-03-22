import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flappy/game/background_widget.dart';
import 'package:flappy/game/bird_widget.dart';
import 'package:flappy/game/ground_widget.dart';
import 'package:flappy/game/pipe.dart';
import 'package:flappy/game/playing_phase_widget.dart';
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

PlayingPhaseWidget createPlayingPhase({int score = 5}) {
  return PlayingPhaseWidget(
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
  group('PlayingPhaseWidget', () {
    testWidgets('score display shows current score', (tester) async {
      final widget = createPlayingPhase(score: 7);
      await tester.pumpWidget(buildTestWidget(widget));
      await tester.pump();

      expect(find.text('7'), findsOneWidget);
    });

    testWidgets('layers present: background, bird, ground', (tester) async {
      final widget = createPlayingPhase();
      await tester.pumpWidget(buildTestWidget(widget));
      await tester.pump();

      expect(find.byType(BackgroundWidget), findsOneWidget);
      expect(find.byType(BirdWidget), findsOneWidget);
      expect(find.byType(GroundWidget), findsOneWidget);
    });
  });
}
