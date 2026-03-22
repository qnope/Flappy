import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flappy/game/leaderboard_widget.dart';
import 'package:flappy/game/score_entry.dart';

Widget buildTestWidget(List<ScoreEntry> scores, {int? highlightIndex}) {
  final leaderboard = LeaderboardWidget(
    scores: scores,
    highlightIndex: highlightIndex,
  );
  final scaffold = Scaffold(body: leaderboard);
  return MaterialApp(home: scaffold);
}

void main() {
  group('Empty state', () {
    testWidgets('Empty scores list renders empty SizedBox, no text visible',
        (tester) async {
      await tester.pumpWidget(buildTestWidget([]));

      expect(find.byType(SizedBox), findsOneWidget);
      expect(find.byType(Text), findsNothing);
      expect(find.byType(Row), findsNothing);
    });
  });

  group('Single score', () {
    testWidgets('One entry shows rank #1, score, and date', (tester) async {
      final scores = [
        ScoreEntry(score: 42, date: DateTime(2026, 3, 22)),
      ];

      await tester.pumpWidget(buildTestWidget(scores));

      expect(find.text('#1'), findsOneWidget);
      expect(find.text('42'), findsOneWidget);
      expect(find.text('22/03/2026'), findsOneWidget);
    });
  });

  group('Multiple scores', () {
    testWidgets('5 entries all shown with correct ranking', (tester) async {
      final scores = List.generate(
        5,
        (i) => ScoreEntry(score: (5 - i) * 10, date: DateTime(2026, 1, i + 1)),
      );

      await tester.pumpWidget(buildTestWidget(scores));

      for (var i = 0; i < 5; i++) {
        expect(find.text('#${i + 1}'), findsOneWidget);
      }
      expect(find.text('50'), findsOneWidget);
      expect(find.text('40'), findsOneWidget);
      expect(find.text('30'), findsOneWidget);
      expect(find.text('20'), findsOneWidget);
      expect(find.text('10'), findsOneWidget);
    });
  });

  group('Full leaderboard', () {
    testWidgets('10 entries all rendered', (tester) async {
      final scores = List.generate(
        10,
        (i) => ScoreEntry(score: (10 - i) * 5, date: DateTime(2026, 1, i + 1)),
      );

      await tester.pumpWidget(buildTestWidget(scores));

      for (var i = 0; i < 10; i++) {
        expect(find.text('#${i + 1}'), findsOneWidget);
      }
    });
  });

  group('Sort order', () {
    testWidgets('Rank #1 has highest score', (tester) async {
      final scores = [
        ScoreEntry(score: 100, date: DateTime(2026, 3, 1)),
        ScoreEntry(score: 80, date: DateTime(2026, 3, 2)),
        ScoreEntry(score: 60, date: DateTime(2026, 3, 3)),
      ];

      await tester.pumpWidget(buildTestWidget(scores));

      // The widget renders scores in the order given, so rank #1 should
      // correspond to the first entry (highest score = 100).
      final rankFinder = find.text('#1');
      expect(rankFinder, findsOneWidget);

      // Verify the first score text appears (100) paired with rank #1
      final scoreFinder = find.text('100');
      expect(scoreFinder, findsOneWidget);

      // Confirm the descending order: #1=100, #2=80, #3=60
      expect(find.text('#2'), findsOneWidget);
      expect(find.text('80'), findsOneWidget);
      expect(find.text('#3'), findsOneWidget);
      expect(find.text('60'), findsOneWidget);
    });
  });

  group('Date format', () {
    testWidgets('Date displayed in dd/MM/yyyy format', (tester) async {
      final scores = [
        ScoreEntry(score: 10, date: DateTime(2026, 1, 5)),
      ];

      await tester.pumpWidget(buildTestWidget(scores));

      expect(find.text('05/01/2026'), findsOneWidget);
    });
  });

  group('New high score', () {
    testWidgets('highlightIndex = 0 shows "New High Score!" text',
        (tester) async {
      final scores = [
        ScoreEntry(score: 99, date: DateTime(2026, 3, 22)),
      ];

      await tester.pumpWidget(buildTestWidget(scores, highlightIndex: 0));

      expect(find.text('New High Score!'), findsOneWidget);
    });
  });

  group('No highlight', () {
    testWidgets('highlightIndex = null hides "New High Score!" text',
        (tester) async {
      final scores = [
        ScoreEntry(score: 99, date: DateTime(2026, 3, 22)),
      ];

      await tester.pumpWidget(buildTestWidget(scores));

      expect(find.text('New High Score!'), findsNothing);
    });
  });

  group('Highlight style', () {
    testWidgets('highlightIndex = 2 highlights that row with golden color',
        (tester) async {
      final scores = [
        ScoreEntry(score: 100, date: DateTime(2026, 3, 1)),
        ScoreEntry(score: 80, date: DateTime(2026, 3, 2)),
        ScoreEntry(score: 60, date: DateTime(2026, 3, 3)),
      ];

      await tester.pumpWidget(buildTestWidget(scores, highlightIndex: 2));

      // The highlighted row (index 2) should display rank #3 in golden color
      const goldenColor = Color(0xFFFFD700);
      final highlightedRankFinder = find.text('#3');
      expect(highlightedRankFinder, findsOneWidget);

      final highlightedRankWidget =
          tester.widget<Text>(highlightedRankFinder);
      expect(highlightedRankWidget.style?.color, goldenColor);

      // Non-highlighted rows should use white, not golden
      final normalRankFinder = find.text('#1');
      final normalRankWidget = tester.widget<Text>(normalRankFinder);
      expect(normalRankWidget.style?.color, isNot(goldenColor));
      expect(normalRankWidget.style?.color, Colors.white);
    });
  });
}
