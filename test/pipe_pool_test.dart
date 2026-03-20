import 'dart:math';
import 'package:flutter_test/flutter_test.dart';
import 'package:flappy/game/pipe_pool.dart';
import 'package:flappy/game/game_constants.dart';

void main() {
  group('PipePool', () {
    late PipePool pool;

    setUp(() {
      pool = PipePool(
        groundTopY: 500,
        screenWidth: 360,
        random: Random(42),
      );
    });

    test('initialization creates correct number of pipes', () {
      expect(pool.pipes.length, equals(GameConstants.pipePoolSize));
    });

    test('initial pipes are spaced correctly', () {
      for (int i = 1; i < pool.pipes.length; i++) {
        final spacing = pool.pipes[i].posX - pool.pipes[i - 1].posX;
        expect(spacing, closeTo(GameConstants.pipeSpacing, 0.001));
      }
    });

    test('first pipe starts at screenWidth + firstPipeOffset', () {
      final expected = 360.0 + GameConstants.firstPipeOffset;
      expect(pool.pipes[0].posX, closeTo(expected, 0.001));
    });

    test('gap size within bounds', () {
      for (final pipe in pool.pipes) {
        expect(pipe.gapSize, greaterThanOrEqualTo(GameConstants.gapMinSize));
        expect(pipe.gapSize, lessThanOrEqualTo(GameConstants.gapMaxSize));
      }
    });

    test('gap center within safe bounds', () {
      final minCenter = GameConstants.gapMinCenterMargin + GameConstants.gapMaxSize / 2;
      final maxCenter = 500.0 - GameConstants.gapMinCenterMargin - GameConstants.gapMaxSize / 2;

      for (final pipe in pool.pipes) {
        expect(pipe.gapCenterY, greaterThanOrEqualTo(minCenter));
        expect(pipe.gapCenterY, lessThanOrEqualTo(maxCenter));
      }
    });

    test('update moves pipes left', () {
      final originalPositions = pool.pipes.map((p) => p.posX).toList();
      pool.update(50);

      for (int i = 0; i < pool.pipes.length; i++) {
        expect(pool.pipes[i].posX, closeTo(originalPositions[i] - 50, 0.001));
      }
    });

    test('recycling works', () {
      final firstPipe = pool.pipes[0];
      final originalGapCenterY = firstPipe.gapCenterY;
      final originalGapSize = firstPipe.gapSize;

      // Move far enough so the first pipe exits the left edge
      final moveDistance = firstPipe.posX + GameConstants.pipeCapWidth / 2 + 1;
      pool.update(moveDistance);

      // The recycled pipe should now be to the right of all other pipes
      final maxX = pool.pipes.fold<double>(
        double.negativeInfinity,
        (max, p) => p.posX > max ? p.posX : max,
      );
      expect(firstPipe.posX, closeTo(maxX, 0.001));

      // Gap values should have been regenerated (with seeded random, they will differ)
      final gapChanged = firstPipe.gapCenterY != originalGapCenterY ||
          firstPipe.gapSize != originalGapSize;
      expect(gapChanged, isTrue);
    });

    test('recycled pipe maintains spacing', () {
      // Record second-to-last rightmost posX before recycling
      final sortedByX = List.of(pool.pipes)..sort((a, b) => a.posX.compareTo(b.posX));
      final previousRightmostX = sortedByX.last.posX;

      final firstPipe = pool.pipes[0];
      final moveDistance = firstPipe.posX + GameConstants.pipeCapWidth / 2 + 1;
      pool.update(moveDistance);

      // After recycling, the recycled pipe should be pipeSpacing to the right of the previous rightmost
      // The previous rightmost was also shifted left by moveDistance
      final expectedX = previousRightmostX - moveDistance + GameConstants.pipeSpacing;
      expect(firstPipe.posX, closeTo(expectedX, 0.001));
    });

    test('reset regenerates all pipes', () {
      pool.update(100);
      final positionsAfterUpdate = pool.pipes.map((p) => p.posX).toList();

      pool.reset();

      expect(pool.pipes.length, equals(GameConstants.pipePoolSize));

      // Positions should be fresh (back to initial layout pattern)
      final expectedFirstX = 360.0 + GameConstants.firstPipeOffset;
      expect(pool.pipes[0].posX, closeTo(expectedFirstX, 0.001));

      // Verify positions differ from the updated state
      final positionsAfterReset = pool.pipes.map((p) => p.posX).toList();
      expect(positionsAfterReset, isNot(equals(positionsAfterUpdate)));
    });
  });
}
