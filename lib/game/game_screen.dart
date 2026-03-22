import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'background_widget.dart';
import 'bird_widget.dart';
import 'clouds_widget.dart';
import 'game_constants.dart';
import 'game_controller.dart';
import 'game_state.dart';
import 'ground_widget.dart';
import 'pipe_widget.dart';
import 'score_repository.dart';

class GameScreen extends StatefulWidget {
  final ScoreRepository scoreRepository;

  const GameScreen({super.key, required this.scoreRepository});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>
    with SingleTickerProviderStateMixin {
  late Ticker _ticker;
  late GameController _controller;
  // ignore: unused_field — will be wired in a later task
  late ScoreRepository _scoreRepository;
  Duration _lastTickTime = Duration.zero;

  @override
  void initState() {
    super.initState();
    _scoreRepository = widget.scoreRepository;
    _controller = GameController();
    _ticker = createTicker(_onTick);
    _ticker.start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  void _onTap() {
    _controller.onTap();
    setState(() {});
  }

  void _onTick(Duration elapsed) {
    if (!_controller.initialized) return;

    final dt = (elapsed - _lastTickTime).inMicroseconds / 1000000.0;
    _lastTickTime = elapsed;

    _controller.update(dt);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;
          final screenHeight = constraints.maxHeight;
          final groundRenderedHeight = screenWidth / 3.0;
          final groundTopY = screenHeight - groundRenderedHeight;

          if (!_controller.initialized) {
            final birdStartY = (groundTopY - GameConstants.birdHeight) / 2;
            _controller.initialize(
              birdStartY: birdStartY,
              groundTopY: groundTopY,
              screenWidth: screenWidth,
            );
          }

          final groundOffset = _controller.groundScrollOffset;
          final cloudsOffset = _controller.cloudsScrollOffset;

          final background = Positioned.fill(
            child: const BackgroundWidget(),
          );

          final clouds = Positioned.fill(
            child: CloudsWidget(scrollOffset: cloudsOffset),
          );

          final groundPositioned = Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: GroundWidget(
              scrollOffset: groundOffset,
            ),
          );

          final pipeWidgets = <Widget>[];
          for (final pipe in _controller.pipePool.pipes) {
            final pipeWidget = PipeWidget(
              gapCenterY: pipe.gapCenterY,
              gapSize: pipe.gapSize,
              screenHeight: screenHeight,
            );

            final positionedPipe = Positioned(
              left: pipe.posX - GameConstants.pipeCapWidth / 2,
              top: 0,
              bottom: 0,
              width: GameConstants.pipeCapWidth,
              child: pipeWidget,
            );

            pipeWidgets.add(positionedPipe);
          }

          final birdWidget = BirdWidget(
            rotation: _controller.birdRotation,
            wing: _controller.bird.currentWing,
          );

          final alignedY =
              _controller.bird.posY / screenHeight * 2 - 1;

          final bird = Align(
            key: const ValueKey('bird'),
            alignment: Alignment(0, alignedY),
            child: birdWidget,
          );

          final children = <Widget>[
            background,
            clouds,
            ...pipeWidgets,
            bird,
            groundPositioned,
          ];

          if (_controller.gamePhase == GamePhase.idle) {
            final tapText = const Text(
              'Tap to start',
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(blurRadius: 4, color: Colors.black54),
                ],
              ),
            );

            final tapTextCentered = Align(
              alignment: Alignment(0, -0.5),
              child: tapText,
            );

            children.add(tapTextCentered);
          }

          final isScoreVisible =
              _controller.gamePhase == GamePhase.playing ||
              _controller.gamePhase == GamePhase.dying;

          if (isScoreVisible) {
            final scoreText = Text(
              '${_controller.score}',
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

            children.add(scorePositioned);
          }

          final isGameOver = _controller.gamePhase == GamePhase.gameOver;

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
            'Score: ${_controller.score}',
            style: const TextStyle(
              fontSize: 32,
              color: Colors.white,
              fontWeight: FontWeight.w500,
              shadows: [
                Shadow(blurRadius: 4, color: Colors.black54),
              ],
            ),
          );

          final restartText = Text(
            'Tap to restart',
            style: const TextStyle(
              fontSize: 20,
              color: Colors.white70,
            ),
          );

          final spacer = const SizedBox(height: 16);

          final overlayColumn = Column(
            mainAxisSize: MainAxisSize.min,
            children: [gameOverText, spacer, finalScoreText, spacer, restartText],
          );

          final overlayCenter = Center(child: overlayColumn);

          final overlayBackground = Container(
            color: Colors.black54,
            child: overlayCenter,
          );

          final gameOverOverlay = Positioned.fill(
            child: AnimatedOpacity(
              opacity: isGameOver ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 500),
              child: IgnorePointer(
                ignoring: !isGameOver,
                child: overlayBackground,
              ),
            ),
          );

          children.add(gameOverOverlay);

          final stack = Stack(
            fit: StackFit.expand,
            children: children,
          );

          return GestureDetector(
            onTap: _onTap,
            behavior: HitTestBehavior.opaque,
            child: stack,
          );
        },
      ),
    );
  }
}
