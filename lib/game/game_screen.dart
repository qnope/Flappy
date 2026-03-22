import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'dying_phase_widget.dart';
import 'game_constants.dart';
import 'game_controller.dart';
import 'game_over_phase_widget.dart';
import 'game_state.dart';
import 'idle_phase_widget.dart';
import 'playing_phase_widget.dart';
import 'score_entry.dart';
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
  Duration _lastTickTime = Duration.zero;

  List<ScoreEntry> _topScores = [];
  int? _lastScore;
  bool _isNewHighScore = false;
  int? _highlightIndex;
  GamePhase? _previousPhase;

  @override
  void initState() {
    super.initState();
    _controller = GameController();
    _ticker = createTicker(_onTick);
    _ticker.start();
    _loadScores();
  }

  void _loadScores() {
    _topScores = widget.scoreRepository.getTopScores();
    _lastScore = widget.scoreRepository.getLastScore()?.score;
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  void _onTap() {
    if (_controller.gamePhase == GamePhase.gameOver) {
      _isNewHighScore = false;
      _highlightIndex = null;
    }
    _controller.onTap();
    setState(() {});
  }

  void _onTick(Duration elapsed) {
    if (!_controller.initialized) return;

    final dt = (elapsed - _lastTickTime).inMicroseconds / 1000000.0;
    _lastTickTime = elapsed;

    _controller.update(dt);

    if (_controller.gamePhase == GamePhase.gameOver &&
        _previousPhase != GamePhase.gameOver) {
      _saveScore();
    }
    _previousPhase = _controller.gamePhase;

    setState(() {});
  }

  Future<void> _saveScore() async {
    _isNewHighScore =
        widget.scoreRepository.isNewHighScore(_controller.score);
    await widget.scoreRepository.addScore(
      _controller.score,
      DateTime.now(),
    );
    _topScores = widget.scoreRepository.getTopScores();
    _highlightIndex =
        _isNewHighScore ? _findHighlightIndex(_controller.score) : null;
    _lastScore = _controller.score;
  }

  int? _findHighlightIndex(int score) {
    for (var i = 0; i < _topScores.length; i++) {
      if (_topScores[i].score == score) return i;
    }
    return null;
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
          final pipes = _controller.pipePool.pipes;
          final birdPosY = _controller.bird.posY;
          final birdWing = _controller.bird.currentWing;
          final birdRotation = _controller.birdRotation;

          final Widget phaseWidget;
          switch (_controller.gamePhase) {
            case GamePhase.idle:
              phaseWidget = IdlePhaseWidget(
                cloudsScrollOffset: cloudsOffset,
                groundScrollOffset: groundOffset,
                pipes: pipes,
                birdPosY: birdPosY,
                birdWing: birdWing,
                screenHeight: screenHeight,
                screenWidth: screenWidth,
                lastScore: _lastScore,
                topScores: _topScores,
              );
            case GamePhase.playing:
              phaseWidget = PlayingPhaseWidget(
                cloudsScrollOffset: cloudsOffset,
                groundScrollOffset: groundOffset,
                pipes: pipes,
                birdPosY: birdPosY,
                birdWing: birdWing,
                birdRotation: birdRotation,
                screenHeight: screenHeight,
                screenWidth: screenWidth,
                score: _controller.score,
              );
            case GamePhase.dying:
              phaseWidget = DyingPhaseWidget(
                cloudsScrollOffset: cloudsOffset,
                groundScrollOffset: groundOffset,
                pipes: pipes,
                birdPosY: birdPosY,
                birdWing: birdWing,
                birdRotation: birdRotation,
                screenHeight: screenHeight,
                screenWidth: screenWidth,
                score: _controller.score,
              );
            case GamePhase.gameOver:
              phaseWidget = GameOverPhaseWidget(
                cloudsScrollOffset: cloudsOffset,
                groundScrollOffset: groundOffset,
                pipes: pipes,
                birdPosY: birdPosY,
                birdWing: birdWing,
                birdRotation: birdRotation,
                screenHeight: screenHeight,
                screenWidth: screenWidth,
                score: _controller.score,
                topScores: _topScores,
                isNewHighScore: _isNewHighScore,
                highlightIndex: _highlightIndex,
              );
          }

          return GestureDetector(
            onTap: _onTap,
            behavior: HitTestBehavior.opaque,
            child: phaseWidget,
          );
        },
      ),
    );
  }
}
