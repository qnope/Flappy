import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:flappy/game/score_entry.dart';
import 'package:flappy/game/score_repository.dart';

void main() {
  late Directory tempDir;
  late Box<ScoreEntry> box;
  late ScoreRepository repo;

  setUpAll(() {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(ScoreEntryAdapter());
    }
  });

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('score_repo_test_');
    Hive.init(tempDir.path);
  });

  tearDown(() async {
    if (box.isOpen) {
      await box.close();
    }
    await tempDir.delete(recursive: true);
  });

  Future<ScoreRepository> createRepo(String boxName) async {
    box = await Hive.openBox<ScoreEntry>(boxName);
    repo = ScoreRepository(box);
    return repo;
  }

  group('addScore', () {
    test('Add single score stores entry with correct score and date', () async {
      final repo = await createRepo('add_single');
      final date = DateTime(2026, 3, 22, 10, 0);

      await repo.addScore(42, date);

      final scores = repo.getTopScores();
      expect(scores.length, 1);
      expect(scores.first.score, 42);
      expect(scores.first.date, date);
    });

    test('Add 12 scores retains only top 10 after pruning', () async {
      final repo = await createRepo('add_twelve');
      final baseDate = DateTime(2026, 1, 1);

      for (int i = 1; i <= 12; i++) {
        final date = baseDate.add(Duration(hours: i));
        await repo.addScore(i, date);
      }

      final scores = repo.getTopScores();
      expect(scores.length, 10);
      // The two lowest scores (1 and 2) should have been pruned
      final scoreValues = scores.map((e) => e.score).toList();
      expect(scoreValues, [12, 11, 10, 9, 8, 7, 6, 5, 4, 3]);
    });
  });

  group('getTopScores', () {
    test('Empty box returns empty list', () async {
      final repo = await createRepo('empty_top');

      final scores = repo.getTopScores();
      expect(scores, isEmpty);
    });

    test('Multiple scores returns sorted descending by score', () async {
      final repo = await createRepo('sorted_desc');
      final baseDate = DateTime(2026, 1, 1);

      await repo.addScore(5, baseDate);
      await repo.addScore(20, baseDate.add(const Duration(hours: 1)));
      await repo.addScore(10, baseDate.add(const Duration(hours: 2)));
      await repo.addScore(15, baseDate.add(const Duration(hours: 3)));

      final scores = repo.getTopScores();
      final scoreValues = scores.map((e) => e.score).toList();
      expect(scoreValues, [20, 15, 10, 5]);
    });

    test('Same-score entries sorted by date descending (tie-breaking)',
        () async {
      final repo = await createRepo('tie_break');
      final earlyDate = DateTime(2026, 1, 1);
      final midDate = DateTime(2026, 6, 1);
      final lateDate = DateTime(2026, 12, 1);

      await repo.addScore(10, earlyDate);
      await repo.addScore(10, lateDate);
      await repo.addScore(10, midDate);

      final scores = repo.getTopScores();
      expect(scores.length, 3);
      expect(scores[0].date, lateDate);
      expect(scores[1].date, midDate);
      expect(scores[2].date, earlyDate);
    });
  });

  group('getLastScore', () {
    test('Empty box returns null', () async {
      final repo = await createRepo('empty_last');

      final last = repo.getLastScore();
      expect(last, isNull);
    });

    test('Multiple scores returns most recently dated entry', () async {
      final repo = await createRepo('last_multi');
      final earlyDate = DateTime(2026, 1, 1);
      final midDate = DateTime(2026, 6, 1);
      final lateDate = DateTime(2026, 12, 1);

      await repo.addScore(5, midDate);
      await repo.addScore(20, earlyDate);
      await repo.addScore(10, lateDate);

      final last = repo.getLastScore();
      expect(last, isNotNull);
      expect(last!.score, 10);
      expect(last.date, lateDate);
    });
  });

  group('isNewHighScore', () {
    test('Fewer than 10 entries always returns true', () async {
      final repo = await createRepo('fewer_than_10');
      final date = DateTime(2026, 1, 1);

      await repo.addScore(100, date);
      await repo.addScore(200, date.add(const Duration(hours: 1)));

      // Even a score of 0 should be a new high score when fewer than 10
      expect(repo.isNewHighScore(0), isTrue);
      expect(repo.isNewHighScore(1), isTrue);
      expect(repo.isNewHighScore(999), isTrue);
    });

    test('10 entries, score higher than lowest returns true', () async {
      final repo = await createRepo('higher_than_lowest');
      final baseDate = DateTime(2026, 1, 1);

      for (int i = 1; i <= 10; i++) {
        await repo.addScore(i * 10, baseDate.add(Duration(hours: i)));
      }

      // Lowest score is 10; a score of 11 should qualify
      expect(repo.isNewHighScore(11), isTrue);
    });

    test('10 entries, score equal to lowest returns false', () async {
      final repo = await createRepo('equal_to_lowest');
      final baseDate = DateTime(2026, 1, 1);

      for (int i = 1; i <= 10; i++) {
        await repo.addScore(i * 10, baseDate.add(Duration(hours: i)));
      }

      // Lowest score is 10; equal should not qualify
      expect(repo.isNewHighScore(10), isFalse);
    });

    test('10 entries, score lower than lowest returns false', () async {
      final repo = await createRepo('lower_than_lowest');
      final baseDate = DateTime(2026, 1, 1);

      for (int i = 1; i <= 10; i++) {
        await repo.addScore(i * 10, baseDate.add(Duration(hours: i)));
      }

      // Lowest score is 10; 5 should not qualify
      expect(repo.isNewHighScore(5), isFalse);
    });
  });

  group('clear', () {
    test('Clear with entries makes box empty', () async {
      final repo = await createRepo('clear_test');
      final date = DateTime(2026, 1, 1);

      await repo.addScore(10, date);
      await repo.addScore(20, date.add(const Duration(hours: 1)));
      await repo.addScore(30, date.add(const Duration(hours: 2)));

      expect(repo.getTopScores().length, 3);

      await repo.clear();

      expect(repo.getTopScores(), isEmpty);
      expect(repo.getLastScore(), isNull);
    });
  });
}
