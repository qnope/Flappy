import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flappy/game/game_over_phase_widget.dart';
import 'package:flappy/game/leaderboard_widget.dart';
import 'package:flappy/game/pipe.dart';
import 'package:flappy/game/score_entry.dart';
import 'package:flappy/game/wing.dart';

Widget buildTestWidget(Widget child, {double height = 800}) {
  return MaterialApp(
    home: Scaffold(
      body: SizedBox(
        width: 288,
        height: height,
        child: child,
      ),
    ),
  );
}

GameOverPhaseWidget createGameOverPhase({
  int score = 10,
  List<ScoreEntry>? topScores,
  bool isNewHighScore = false,
  int? highlightIndex,
}) {
  final scores = topScores ??
      [
        ScoreEntry(score: 50, date: DateTime(2026, 3, 20)),
        ScoreEntry(score: 30, date: DateTime(2026, 3, 19)),
        ScoreEntry(score: 10, date: DateTime(2026, 3, 22)),
      ];
  return GameOverPhaseWidget(
    cloudsScrollOffset: 0.0,
    groundScrollOffset: 0.0,
    pipes: [Pipe(posX: 200, gapCenterY: 200, gapSize: 150)],
    birdPosY: 100,
    birdWing: Wing.mid,
    birdRotation: 0.0,
    screenHeight: 800,
    screenWidth: 288,
    score: score,
    topScores: scores,
    isNewHighScore: isNewHighScore,
    highlightIndex: highlightIndex,
  );
}

void main() {
  group('GameOverPhaseWidget', () {
    testWidgets('game over text is visible', (tester) async {
      final widget = createGameOverPhase();
      await tester.pumpWidget(buildTestWidget(widget));
      await tester.pump();

      expect(find.text('Game Over'), findsOneWidget);
    });

    testWidgets('current score displayed prominently', (tester) async {
      final widget = createGameOverPhase(score: 25);
      await tester.pumpWidget(buildTestWidget(widget));
      await tester.pump();

      expect(find.text('Score: 25'), findsOneWidget);
    });

    testWidgets('leaderboard with top scores shown', (tester) async {
      final scores = [
        ScoreEntry(score: 100, date: DateTime(2026, 3, 1)),
        ScoreEntry(score: 80, date: DateTime(2026, 3, 2)),
      ];
      final widget = createGameOverPhase(topScores: scores);
      await tester.pumpWidget(buildTestWidget(widget));
      await tester.pump();

      expect(find.byType(LeaderboardWidget), findsOneWidget);
      expect(find.text('100'), findsOneWidget);
      expect(find.text('80'), findsOneWidget);
    });

    testWidgets('new high score shown when isNewHighScore is true',
        (tester) async {
      final widget = createGameOverPhase(isNewHighScore: true);
      await tester.pumpWidget(buildTestWidget(widget));
      await tester.pump();

      expect(find.text('New High Score!'), findsOneWidget);
    });

    testWidgets('new high score not shown when isNewHighScore is false',
        (tester) async {
      final widget = createGameOverPhase(isNewHighScore: false);
      await tester.pumpWidget(buildTestWidget(widget));
      await tester.pump();

      expect(find.text('New High Score!'), findsNothing);
    });

    testWidgets('restart hint is visible', (tester) async {
      final widget = createGameOverPhase();
      await tester.pumpWidget(buildTestWidget(widget));
      await tester.pump();

      expect(find.text('Tap to restart'), findsOneWidget);
    });

    testWidgets('correct row highlighted in leaderboard', (tester) async {
      final scores = [
        ScoreEntry(score: 100, date: DateTime(2026, 3, 1)),
        ScoreEntry(score: 80, date: DateTime(2026, 3, 2)),
        ScoreEntry(score: 60, date: DateTime(2026, 3, 3)),
      ];
      final widget = createGameOverPhase(
        topScores: scores,
        highlightIndex: 1,
      );
      await tester.pumpWidget(buildTestWidget(widget));
      await tester.pump();

      // The highlighted row (index 1) should have golden color for rank #2
      const goldenColor = Color(0xFFFFD700);
      final highlightedRankFinder = find.text('#2');
      expect(highlightedRankFinder, findsOneWidget);

      final highlightedRankWidget =
          tester.widget<Text>(highlightedRankFinder);
      expect(highlightedRankWidget.style?.color, goldenColor);

      // Non-highlighted row should use white
      final normalRankFinder = find.text('#1');
      final normalRankWidget = tester.widget<Text>(normalRankFinder);
      expect(normalRankWidget.style?.color, Colors.white);
    });
  });
}
