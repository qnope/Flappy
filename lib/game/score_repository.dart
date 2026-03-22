import 'package:hive/hive.dart';

import 'score_entry.dart';

class ScoreRepository {
  final Box<ScoreEntry> _box;

  ScoreRepository(this._box);

  static Future<ScoreRepository> create() async {
    final box = await Hive.openBox<ScoreEntry>('scores');
    return ScoreRepository(box);
  }

  Future<void> addScore(int score, DateTime date) async {
    final entry = ScoreEntry(score: score, date: date);
    await _box.add(entry);

    if (_box.length > 10) {
      final sorted = _box.toMap().entries.toList()
        ..sort((a, b) {
          final scoreCompare = b.value.score.compareTo(a.value.score);
          if (scoreCompare != 0) return scoreCompare;
          return b.value.date.compareTo(a.value.date);
        });

      final keysToRemove = sorted.skip(10).map((e) => e.key).toList();
      await _box.deleteAll(keysToRemove);
    }
  }

  List<ScoreEntry> getTopScores() {
    final entries = _box.values.toList()
      ..sort((a, b) {
        final scoreCompare = b.score.compareTo(a.score);
        if (scoreCompare != 0) return scoreCompare;
        return b.date.compareTo(a.date);
      });

    return entries.take(10).toList();
  }

  ScoreEntry? getLastScore() {
    if (_box.isEmpty) return null;

    final entries = _box.values.toList()
      ..sort((a, b) => b.date.compareTo(a.date));

    return entries.first;
  }

  bool isNewHighScore(int score) {
    if (_box.isEmpty) return true;

    final topScores = getTopScores();
    return score > topScores.first.score;
  }

  Future<void> clear() async {
    await _box.clear();
  }
}
