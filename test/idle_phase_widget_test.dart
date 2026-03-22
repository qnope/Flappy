import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flappy/game/idle_phase_widget.dart';
import 'package:flappy/game/leaderboard_widget.dart';
import 'package:flappy/game/pipe.dart';
import 'package:flappy/game/score_entry.dart';
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

IdlePhaseWidget createIdlePhase({
  int? lastScore,
  List<ScoreEntry> topScores = const [],
}) {
  return IdlePhaseWidget(
    cloudsScrollOffset: 0.0,
    groundScrollOffset: 0.0,
    pipes: <Pipe>[],
    birdPosY: 256,
    birdWing: Wing.mid,
    screenHeight: 512,
    screenWidth: 288,
    lastScore: lastScore,
    topScores: topScores,
  );
}

void main() {
  group('IdlePhaseWidget', () {
    testWidgets('first launch shows tap to start, no leaderboard, no last score',
        (tester) async {
      final widget = createIdlePhase();
      await tester.pumpWidget(buildTestWidget(widget));
      await tester.pump();

      expect(find.text('Tap to start'), findsOneWidget);
      expect(find.byType(LeaderboardWidget), findsNothing);
      expect(find.textContaining('Last Score'), findsNothing);
    });

    testWidgets('with scores shows leaderboard and last score', (tester) async {
      final scores = [
        ScoreEntry(score: 42, date: DateTime(2026, 3, 22)),
        ScoreEntry(score: 30, date: DateTime(2026, 3, 21)),
      ];
      final widget = createIdlePhase(lastScore: 42, topScores: scores);
      await tester.pumpWidget(buildTestWidget(widget));
      await tester.pump();

      expect(find.byType(LeaderboardWidget), findsOneWidget);
      expect(find.text('Last Score: 42'), findsOneWidget);
    });

    testWidgets('tap to start always visible', (tester) async {
      final scores = [
        ScoreEntry(score: 10, date: DateTime(2026, 1, 1)),
      ];
      final widget = createIdlePhase(lastScore: 10, topScores: scores);
      await tester.pumpWidget(buildTestWidget(widget));
      await tester.pump();

      expect(find.text('Tap to start'), findsOneWidget);
    });

    testWidgets('no empty leaderboard rendered when scores list is empty',
        (tester) async {
      final widget = createIdlePhase(topScores: const []);
      await tester.pumpWidget(buildTestWidget(widget));
      await tester.pump();

      expect(find.byType(LeaderboardWidget), findsNothing);
    });
  });
}
