import 'package:flutter/material.dart';

import 'game_layers_widget.dart';
import 'pipe.dart';
import 'wing.dart';

class PlayingPhaseWidget extends StatelessWidget {
  final double cloudsScrollOffset;
  final double groundScrollOffset;
  final List<Pipe> pipes;
  final double birdPosY;
  final Wing birdWing;
  final double birdRotation;
  final double screenHeight;
  final double screenWidth;
  final int score;

  const PlayingPhaseWidget({
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
  });

  @override
  Widget build(BuildContext context) {
    final scoreText = Text(
      '$score',
      style: const TextStyle(
        fontSize: 48,
        color: Colors.white,
        fontWeight: FontWeight.bold,
        shadows: [
          Shadow(blurRadius: 4, color: Colors.black54),
          Shadow(blurRadius: 8, color: Colors.black26),
        ],
      ),
    );

    final scorePositioned = Align(
      alignment: const Alignment(0, -0.75),
      child: scoreText,
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
      overlays: [scorePositioned],
    );
  }
}
