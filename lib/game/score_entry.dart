import 'package:hive/hive.dart';

part 'score_entry.g.dart';

@HiveType(typeId: 0)
class ScoreEntry {
  @HiveField(0)
  final int score;

  @HiveField(1)
  final DateTime date;

  ScoreEntry({required this.score, required this.date});
}
