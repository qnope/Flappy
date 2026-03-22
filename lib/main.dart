import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'game/game_screen.dart';
import 'game/score_entry.dart';
import 'game/score_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(ScoreEntryAdapter());
  final scoreRepo = await ScoreRepository.create();
  runApp(MyApp(scoreRepository: scoreRepo));
}

class MyApp extends StatelessWidget {
  final ScoreRepository scoreRepository;

  const MyApp({super.key, required this.scoreRepository});

  @override
  Widget build(BuildContext context) {
    final home = GameScreen(scoreRepository: scoreRepository);

    final theme = ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    );

    return MaterialApp(
      title: 'Flappy',
      theme: theme,
      home: home,
    );
  }
}
