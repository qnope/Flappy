import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'background_widget.dart';
import 'bird_widget.dart';
import 'clouds_widget.dart';
import 'game_constants.dart';
import 'game_controller.dart';
import 'game_state.dart';
import 'ground_widget.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>
    with SingleTickerProviderStateMixin {
  late Ticker _ticker;
  late GameController _controller;
  Duration _lastTickTime = Duration.zero;

  @override
  void initState() {
    super.initState();
    _controller = GameController();
    _ticker = createTicker(_onTick);
    _ticker.start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onTap() {
    _controller.onTap();
  }

  void _onTick(Duration elapsed) {
    if (!_controller.initialized) return;

    final dt = (elapsed - _lastTickTime).inMicroseconds / 1000000.0;
    _lastTickTime = elapsed;

    _controller.update(dt);
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
            );
          }

          return ListenableBuilder(
            listenable: _controller,
            builder: (context, child) {
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
          );
        },
      ),
    );
  }
}
