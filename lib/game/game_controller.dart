import 'dart:math';

import 'bird.dart';
import 'game_constants.dart';
import 'game_state.dart';
import 'pipe_pool.dart';
import 'wing.dart';

class GameController {
  GamePhase gamePhase = GamePhase.idle;
  late Bird bird;
  late PipePool pipePool;
  double groundTopY = 0;
  double groundScrollOffset = 0.0;
  double cloudsScrollOffset = 0.0;
  double _birdStartY = 0;
  double _idleTime = 0.0;
  int _wingSequenceIndex = 0;
  Duration _wingFrameTimer = Duration.zero;
  bool _initialized = false;

  bool get initialized => _initialized;

  void initialize({
    required double birdStartY,
    required double groundTopY,
    required double screenWidth,
    Random? random,
  }) {
    bird = Bird(posY: birdStartY);
    _birdStartY = birdStartY;
    this.groundTopY = groundTopY;
    pipePool = PipePool(
      groundTopY: groundTopY,
      screenWidth: screenWidth,
      random: random,
    );
    _initialized = true;
  }

  void onTap() {
    if (gamePhase == GamePhase.idle) {
      gamePhase = GamePhase.playing;
      bird.posY = _birdStartY;
      bird.jump(GameConstants.jumpVelocity);
      pipePool.reset();
    } else if (gamePhase == GamePhase.playing) {
      bird.jump(GameConstants.jumpVelocity);
    }
  }

  void update(double dt) {
    if (!_initialized) return;
    if (dt > 0.1) return;

    final groundDistance = GameConstants.groundScrollSpeed * dt;
    groundScrollOffset += groundDistance;
    cloudsScrollOffset += GameConstants.cloudsScrollSpeed * dt;
    pipePool.update(groundDistance);

    if (gamePhase == GamePhase.idle) {
      _idleTime += dt;
      final bobOffset =
          sin(_idleTime * 2 * pi * GameConstants.bobFrequency) *
              GameConstants.bobAmplitude;
      bird.posY = _birdStartY + bobOffset;
    } else {
      bird.update(dt, GameConstants.gravity);
      bird.clampToGround(groundTopY, GameConstants.birdHeight);
    }

    _updateWingAnimation(dt);
  }

  double get birdRotation {
    if (gamePhase == GamePhase.idle) return 0.0;
    return bird.rotation;
  }

  void _updateWingAnimation(double dt) {
    if (gamePhase == GamePhase.idle || bird.velocityY <= 0) {
      _wingFrameTimer += Duration(microseconds: (dt * 1000000).round());
      if (_wingFrameTimer >= GameConstants.wingFrameDuration) {
        _wingFrameTimer = Duration.zero;
        _wingSequenceIndex =
            (_wingSequenceIndex + 1) % Wing.animationSequence.length;
      }
      bird.currentWing = Wing.animationSequence[_wingSequenceIndex];
    } else {
      bird.currentWing = Wing.mid;
      _wingFrameTimer = Duration.zero;
    }
  }
}
