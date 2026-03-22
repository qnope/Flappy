import 'package:flutter/material.dart';

import 'game_layers_widget.dart';
import 'leaderboard_widget.dart';
import 'pipe.dart';
import 'score_entry.dart';
import 'wing.dart';

class IdlePhaseWidget extends StatelessWidget {
  final double cloudsScrollOffset;
  final double groundScrollOffset;
  final List<Pipe> pipes;
  final double birdPosY;
  final Wing birdWing;
  final double screenHeight;
  final double screenWidth;
  final int? lastScore;
  final List<ScoreEntry> topScores;

  const IdlePhaseWidget({
    super.key,
    required this.cloudsScrollOffset,
    required this.groundScrollOffset,
    required this.pipes,
    required this.birdPosY,
    required this.birdWing,
    required this.screenHeight,
    required this.screenWidth,
    this.lastScore,
    this.topScores = const [],
  });

  @override
  Widget build(BuildContext context) {
    final overlays = <Widget>[];

    const tapTextStyle = TextStyle(
      fontSize: 24,
      color: Colors.white,
      fontWeight: FontWeight.bold,
      shadows: [
        Shadow(blurRadius: 4, color: Colors.black54),
      ],
    );

    const tapText = Text('Tap to start', style: tapTextStyle);

    final tapTextAligned = Align(
      alignment: const Alignment(0, -0.5),
      child: tapText,
    );

    overlays.add(tapTextAligned);

    if (lastScore != null) {
      const lastScoreTextStyle = TextStyle(
        fontSize: 20,
        color: Colors.white,
        fontWeight: FontWeight.bold,
        shadows: [
          Shadow(blurRadius: 4, color: Colors.black54),
        ],
      );

      final lastScoreText = Text(
        'Last Score: $lastScore',
        style: lastScoreTextStyle,
      );

      final lastScoreAligned = Align(
        alignment: const Alignment(0, 0.05),
        child: lastScoreText,
      );

      overlays.add(lastScoreAligned);
    }

    if (topScores.isNotEmpty) {
      final leaderboard = LeaderboardWidget(scores: topScores);

      final leaderboardAligned = Align(
        alignment: const Alignment(0, 0.5),
        child: leaderboard,
      );

      overlays.add(leaderboardAligned);
    }

    final gameLayers = GameLayersWidget(
      cloudsScrollOffset: cloudsScrollOffset,
      groundScrollOffset: groundScrollOffset,
      pipes: pipes,
      birdPosY: birdPosY,
      birdWing: birdWing,
      birdRotation: 0.0,
      screenHeight: screenHeight,
      screenWidth: screenWidth,
      overlays: overlays,
    );

    return gameLayers;
  }
}
