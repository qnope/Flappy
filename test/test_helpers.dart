import 'dart:io';

import 'package:hive/hive.dart';

import 'package:flappy/game/score_entry.dart';
import 'package:flappy/game/score_repository.dart';

Future<ScoreRepository> createTestScoreRepository() async {
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(ScoreEntryAdapter());
  }
  final tempDir = Directory.systemTemp.createTempSync();
  Hive.init(tempDir.path);
  final box = await Hive.openBox<ScoreEntry>(
    'test_scores_${DateTime.now().millisecondsSinceEpoch}',
  );
  return ScoreRepository(box);
}
