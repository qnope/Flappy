import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'bird_physics.dart';
import 'bird_widget.dart';
import 'game_constants.dart';
import 'game_state.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>
    with SingleTickerProviderStateMixin {
  late Ticker _ticker;
  late BirdPhysics _bird;
  Duration _lastTickTime = Duration.zero;
  GamePhase _gamePhase = GamePhase.idle;
  bool _initialized = false;
  double _birdX = 0;
  double _birdStartY = 0;
  double _groundTopY = 0;
  double _idleTime = 0.0;
  int _wingFrameIndex = 0;
  Duration _wingFrameTimer = Duration.zero;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick);
    _ticker.start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  void _onTap() {
    if (_gamePhase == GamePhase.idle) {
      setState(() {
        _gamePhase = GamePhase.playing;
        _bird.posY = _birdStartY;
        _bird.jump(GameConstants.jumpVelocity);
      });
    } else if (_gamePhase == GamePhase.playing) {
      _bird.jump(GameConstants.jumpVelocity);
    }
  }

  void _onTick(Duration elapsed) {
    if (!_initialized) return;

    final dt = (elapsed - _lastTickTime).inMicroseconds / 1000000.0;
    _lastTickTime = elapsed;

    if (dt > 0.1) return;

    setState(() {
      if (_gamePhase == GamePhase.idle) {
        _idleTime += dt;
        final bobOffset =
            sin(_idleTime * 2 * pi * GameConstants.bobFrequency) *
                GameConstants.bobAmplitude;
        _bird.posY = _birdStartY + bobOffset;
      } else {
        _bird.update(dt, GameConstants.gravity);
        _bird.clampToGround(_groundTopY, GameConstants.birdHeight);
      }

      // Wing animation
      if (_gamePhase == GamePhase.idle || _bird.velocityY <= 0) {
        _wingFrameTimer +=
            Duration(microseconds: (dt * 1000000).round());
        if (_wingFrameTimer >= GameConstants.wingFrameDuration) {
          _wingFrameTimer = Duration.zero;
          _wingFrameIndex =
              (_wingFrameIndex + 1) % GameConstants.wingSprites.length;
        }
      } else {
        _wingFrameIndex = 1; // bird_mid.svg when falling
        _wingFrameTimer = Duration.zero;
      }
    });
  }

  double _calculateBirdRotation() {
    if (_gamePhase == GamePhase.idle) return 0.0;

    final velocity = _bird.velocityY;

    if (velocity <= 0) {
      final ratio = (velocity / GameConstants.jumpVelocity).clamp(0.0, 1.0);
      return GameConstants.maxUpRotation * ratio;
    } else {
      final ratio =
          (velocity / GameConstants.maxFallVelocity).clamp(0.0, 1.0);
      return GameConstants.maxDownRotation * ratio;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;
          final screenHeight = constraints.maxHeight;
          final groundRenderedHeight = screenWidth / 3.0;
          _groundTopY = screenHeight - groundRenderedHeight;

          if (!_initialized) {
            _birdX = (screenWidth - GameConstants.birdWidth) / 2;
            _birdStartY = (_groundTopY - GameConstants.birdHeight) / 2;
            _bird = BirdPhysics(posY: _birdStartY);
            _initialized = true;
          }

          final backgroundImage = SvgPicture.asset(
            'assets/images/background.svg',
            width: screenWidth,
            height: screenHeight,
            fit: BoxFit.cover,
          );

          final background = Positioned.fill(
            child: backgroundImage,
          );

          final ground = SvgPicture.asset(
            'assets/images/ground.svg',
            width: screenWidth,
            fit: BoxFit.fitWidth,
          );

          final groundPositioned = Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ground,
          );

          final birdRotation = _calculateBirdRotation();

          final birdWidget = BirdWidget(
            rotation: birdRotation,
            spritePath: GameConstants.wingSprites[_wingFrameIndex],
          );

          final bird = Positioned(
            key: const ValueKey('bird'),
            left: _birdX,
            top: _bird.posY,
            width: GameConstants.birdWidth,
            height: GameConstants.birdHeight,
            child: birdWidget,
          );

          final children = <Widget>[background, groundPositioned, bird];

          if (_gamePhase == GamePhase.idle) {
            final tapText = const Text(
              'Tap to start',
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                shadows: [Shadow(blurRadius: 4, color: Colors.black54)],
              ),
            );

            final tapTextCentered = Positioned(
              top: screenHeight * 0.25,
              left: 0,
              right: 0,
              child: Center(child: tapText),
            );

            children.add(tapTextCentered);
          }

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
