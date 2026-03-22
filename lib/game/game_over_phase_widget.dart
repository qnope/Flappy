import 'package:flutter/material.dart';

import 'game_layers_widget.dart';
import 'leaderboard_widget.dart';
import 'pipe.dart';
import 'score_entry.dart';
import 'wing.dart';

class GameOverPhaseWidget extends StatelessWidget {
  final double cloudsScrollOffset;
  final double groundScrollOffset;
  final List<Pipe> pipes;
  final double birdPosY;
  final Wing birdWing;
  final double birdRotation;
  final double screenHeight;
  final double screenWidth;
  final int score;
  final List<ScoreEntry> topScores;
  final bool isNewHighScore;
  final int? highlightIndex;

  const GameOverPhaseWidget({
    super.key,
    required this.cloudsScrollOffset,
    required this.groundScrollOffset,
    required this.pipes,
    required this.birdPosY,
    required this.birdWing,
    required this.birdRotation,
    required this.screenHeight,
    required this.screenWidth,
    required this.score,
    required this.topScores,
    required this.isNewHighScore,
    this.highlightIndex,
  });

  @override
  Widget build(BuildContext context) {
    final gameOverText = Text(
      'Game Over',
      style: const TextStyle(
        fontSize: 48,
        color: Colors.white,
        fontWeight: FontWeight.bold,
        shadows: [
          Shadow(blurRadius: 6, color: Colors.black87),
        ],
      ),
    );

    final finalScoreText = Text(
      'Score: $score',
      style: const TextStyle(
        fontSize: 32,
        color: Colors.white,
        fontWeight: FontWeight.w500,
        shadows: [
          Shadow(blurRadius: 4, color: Colors.black54),
        ],
      ),
    );

    final spacer = const SizedBox(height: 16);

    final columnChildren = <Widget>[
      gameOverText,
      spacer,
      finalScoreText,
      spacer,
    ];

    if (isNewHighScore) {
      final newHighScoreText = Text(
        'New High Score!',
        style: const TextStyle(
          fontSize: 24,
          color: Color(0xFFFFD700),
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(blurRadius: 4, color: Colors.black87),
          ],
        ),
      );
      columnChildren.add(newHighScoreText);
      columnChildren.add(spacer);
    }

    final leaderboard = LeaderboardWidget(
      scores: topScores,
      highlightIndex: highlightIndex,
    );
    columnChildren.add(leaderboard);
    columnChildren.add(spacer);

    final restartText = Text(
      'Tap to restart',
      style: const TextStyle(
        fontSize: 20,
        color: Colors.white70,
      ),
    );
    columnChildren.add(restartText);

    final overlayColumn = Column(
      mainAxisSize: MainAxisSize.min,
      children: columnChildren,
    );

    final overlayCenter = Center(child: overlayColumn);

    final overlayBackground = Container(
      color: Colors.black54,
      child: overlayCenter,
    );

    final gameOverOverlay = Positioned.fill(
      child: overlayBackground,
    );

    return GameLayersWidget(
      cloudsScrollOffset: cloudsScrollOffset,
      groundScrollOffset: groundScrollOffset,
      pipes: pipes,
      birdPosY: birdPosY,
      birdWing: birdWing,
      birdRotation: birdRotation,
      screenHeight: screenHeight,
      screenWidth: screenWidth,
      overlays: [gameOverOverlay],
    );
  }
}
