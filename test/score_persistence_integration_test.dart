import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

import 'package:flappy/game/game_screen.dart';
import 'package:flappy/game/score_entry.dart';
import 'package:flappy/game/score_repository.dart';

late Directory _tempDir;
late ScoreRepository _scoreRepo;
late List<Box<ScoreEntry>> _boxes;
int _boxCounter = 0;

ScoreRepository _freshRepo() {
  return ScoreRepository(_boxes[_boxCounter++]);
}

Widget _buildApp(ScoreRepository repo, {Key? key}) {
  return MaterialApp(home: GameScreen(key: key, scoreRepository: repo));
}

Future<void> _playUntilGameOver(WidgetTester tester) async {
  // Tap to start playing
  await tester.tap(find.byType(GestureDetector));
  await tester.pump();

  // Let bird fall to ground to trigger gameOver
  for (int i = 0; i < 300; i++) {
    await tester.pump(const Duration(milliseconds: 16));
  }

  // Let fire-and-forget _saveScore complete its real Hive I/O,
  // then pump to process the continuation in the fake-async zone.
  await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 50)));
  await tester.pump();
}

void main() {
  setUpAll(() async {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(ScoreEntryAdapter());
    }
    _tempDir = await Directory.systemTemp.createTemp('score_persist_test_');
    Hive.init(_tempDir.path);
    _boxes = [];
    for (int i = 0; i < 10; i++) {
      _boxes.add(await Hive.openBox<ScoreEntry>('integration_$i'));
    }
  });

  tearDownAll(() {
    _tempDir.deleteSync(recursive: true);
  });

  group('Score persistence integration', () {
    testWidgets('score saved on game over', (tester) async {
      await tester.binding.setSurfaceSize(const Size(288, 512));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      _scoreRepo = _freshRepo();
      await tester.pumpWidget(_buildApp(_scoreRepo));
      await tester.pump();

      await _playUntilGameOver(tester);

      expect(find.text('Game Over'), findsOneWidget);

      final scores = _scoreRepo.getTopScores();
      expect(scores.length, equals(1));
      expect(scores.first.score, equals(0));
    });

    testWidgets('score survives restart with same repository', (tester) async {
      await tester.binding.setSurfaceSize(const Size(288, 512));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      _scoreRepo = _freshRepo();

      // First game
      await tester.pumpWidget(_buildApp(_scoreRepo));
      await tester.pump();
      await _playUntilGameOver(tester);

      expect(_scoreRepo.getTopScores().length, equals(1));

      // Simulate restart by creating new widget with same repo
      await tester.pumpWidget(_buildApp(_scoreRepo, key: UniqueKey()));
      await tester.pump();

      // Should be in idle with leaderboard showing
      expect(find.text('Tap to start'), findsOneWidget);
      // The saved score should be visible in leaderboard
      expect(find.text('Last Score: 0'), findsOneWidget);
    });

    testWidgets('top 10 maintained after many scores', (tester) async {
      _scoreRepo = _freshRepo();

      // Add 12 scores directly
      await tester.runAsync(() async {
        for (int i = 1; i <= 12; i++) {
          await _scoreRepo.addScore(i * 10, DateTime(2026, 1, i));
        }
      });

      final topScores = _scoreRepo.getTopScores();
      expect(topScores.length, equals(10));
      // Highest should be first
      expect(topScores.first.score, equals(120));
      // Lowest in top 10 should be 30 (scores 10 and 20 pruned)
      expect(topScores.last.score, equals(30));
    });

    testWidgets('new high score detected', (tester) async {
      await tester.binding.setSurfaceSize(const Size(288, 512));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      _scoreRepo = _freshRepo();
      await tester.pumpWidget(_buildApp(_scoreRepo));
      await tester.pump();

      // Play to game over (score will be 0)
      await _playUntilGameOver(tester);

      // First score is always a new high score
      expect(find.text('New High Score!'), findsWidgets);
    });

    testWidgets('first launch shows only tap to start', (tester) async {
      await tester.binding.setSurfaceSize(const Size(288, 512));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      _scoreRepo = _freshRepo();
      await tester.pumpWidget(_buildApp(_scoreRepo));
      await tester.pump();

      expect(find.text('Tap to start'), findsOneWidget);
      expect(find.text('Last Score: 0'), findsNothing);
      expect(find.text('Game Over'), findsNothing);
    });

    testWidgets('leaderboard on idle after restart', (tester) async {
      await tester.binding.setSurfaceSize(const Size(288, 512));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      _scoreRepo = _freshRepo();

      // Play first game
      await tester.pumpWidget(_buildApp(_scoreRepo));
      await tester.pump();
      await _playUntilGameOver(tester);

      // Tap to restart to idle
      await tester.tap(find.byType(GestureDetector));
      await tester.pump();

      // Idle screen should show leaderboard with the saved score
      expect(find.text('Tap to start'), findsOneWidget);
      expect(find.text('Last Score: 0'), findsOneWidget);
    });
  });
}
