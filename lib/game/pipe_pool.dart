import 'dart:math';
import 'pipe.dart';
import 'game_constants.dart';

class PipePool {
  final List<Pipe> pipes;
  final Random _random;
  final double _groundTopY;
  final double _screenWidth;

  PipePool({
    required double groundTopY,
    required double screenWidth,
    Random? random,
  })  : _groundTopY = groundTopY,
        _screenWidth = screenWidth,
        _random = random ?? Random(),
        pipes = [] {
    reset();
  }

  void reset() {
    pipes.clear();
    for (int i = 0; i < GameConstants.pipePoolSize; i++) {
      final posX = _screenWidth + GameConstants.firstPipeOffset + i * GameConstants.pipeSpacing;
      pipes.add(Pipe(
        posX: posX,
        gapCenterY: _randomGapCenter(),
        gapSize: _randomGapSize(),
      ));
    }
  }

  void update(double distance) {
    for (final pipe in pipes) {
      pipe.posX -= distance;
    }
    _recyclePipes();
  }

  double _randomGapSize() {
    return GameConstants.gapMinSize +
        _random.nextDouble() * (GameConstants.gapMaxSize - GameConstants.gapMinSize);
  }

  double _randomGapCenter() {
    final minCenter = GameConstants.gapMinCenterMargin + GameConstants.gapMaxSize / 2;
    final maxCenter = _groundTopY - GameConstants.gapMinCenterMargin - GameConstants.gapMaxSize / 2;
    return minCenter + _random.nextDouble() * (maxCenter - minCenter);
  }

  void _recyclePipes() {
    double maxX = pipes.fold<double>(double.negativeInfinity, (max, p) => p.posX > max ? p.posX : max);

    for (final pipe in pipes) {
      if (pipe.posX + GameConstants.pipeCapWidth / 2 < 0) {
        pipe.posX = maxX + GameConstants.pipeSpacing;
        pipe.gapCenterY = _randomGapCenter();
        pipe.gapSize = _randomGapSize();
        pipe.scored = false;
        maxX = pipe.posX;
      }
    }
  }
}
