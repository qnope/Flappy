import 'package:flutter/material.dart';

import 'background_widget.dart';
import 'bird_widget.dart';
import 'clouds_widget.dart';
import 'game_constants.dart';
import 'ground_widget.dart';
import 'pipe.dart';
import 'pipe_widget.dart';
import 'wing.dart';

class GameLayersWidget extends StatelessWidget {
  final double cloudsScrollOffset;
  final double groundScrollOffset;
  final List<Pipe> pipes;
  final double birdPosY;
  final Wing birdWing;
  final double birdRotation;
  final double screenHeight;
  final double screenWidth;
  final List<Widget> overlays;

  const GameLayersWidget({
    super.key,
    required this.cloudsScrollOffset,
    required this.groundScrollOffset,
    required this.pipes,
    required this.birdPosY,
    required this.birdWing,
    required this.birdRotation,
    required this.screenHeight,
    required this.screenWidth,
    this.overlays = const [],
  });

  @override
  Widget build(BuildContext context) {
    final background = Positioned.fill(
      child: const BackgroundWidget(),
    );

    final cloudsWidget = CloudsWidget(scrollOffset: cloudsScrollOffset);
    final clouds = Positioned.fill(child: cloudsWidget);

    final pipeWidgets = _buildPipeWidgets();

    final birdWidget = BirdWidget(
      rotation: birdRotation,
      wing: birdWing,
    );
    final alignedY = birdPosY / screenHeight * 2 - 1;
    final bird = Align(
      key: const ValueKey('bird'),
      alignment: Alignment(0, alignedY),
      child: birdWidget,
    );

    final groundWidget = GroundWidget(scrollOffset: groundScrollOffset);
    final groundPositioned = Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: groundWidget,
    );

    final children = <Widget>[
      background,
      clouds,
      ...pipeWidgets,
      bird,
      groundPositioned,
      ...overlays,
    ];

    return Stack(
      fit: StackFit.expand,
      children: children,
    );
  }

  List<Widget> _buildPipeWidgets() {
    final pipeWidgets = <Widget>[];
    for (final pipe in pipes) {
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
    return pipeWidgets;
  }
}
