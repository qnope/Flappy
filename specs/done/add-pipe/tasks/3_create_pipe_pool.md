# Task 3: Create PipePool Class + Unit Tests

## Summary
Create a `PipePool` that manages a fixed pool of `Pipe` objects, handling initialization, scrolling, recycling, and reset.

## Implementation Steps

### Step 1: Create `lib/game/pipe_pool.dart`

```dart
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

  /// Resets all pipes to starting positions with fresh random gaps.
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

  /// Moves all pipes left by `distance` and recycles any that exit the screen.
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
    // Find the rightmost pipe to know where to place recycled ones
    double maxX = pipes.fold<double>(double.negativeInfinity, (max, p) => p.posX > max ? p.posX : max);

    for (final pipe in pipes) {
      if (pipe.posX + GameConstants.pipeCapWidth / 2 < 0) {
        // Pipe fully off left edge — recycle to the right
        pipe.posX = maxX + GameConstants.pipeSpacing;
        pipe.gapCenterY = _randomGapCenter();
        pipe.gapSize = _randomGapSize();
        maxX = pipe.posX; // update rightmost
      }
    }
  }
}
```

### Step 2: Create `test/pipe_pool_test.dart`

Test cases (use `Random(42)` for determinism):

- **Initialization creates correct number of pipes**: `pipes.length == GameConstants.pipePoolSize`
- **Initial pipes are spaced correctly**: each pipe's `posX` differs by `pipeSpacing` from the previous one
- **First pipe starts at screenWidth + firstPipeOffset**: verify `pipes[0].posX`
- **Gap size within bounds**: for each pipe, `gapMinSize <= gapSize <= gapMaxSize`
- **Gap center within safe bounds**: for each pipe, gap doesn't clip above screen or below ground
- **update moves pipes left**: call `update(50)`, verify each pipe moved left by 50
- **Recycling works**: move pipes far enough that one exits the left edge, verify it gets repositioned to the right with new gap values
- **Recycled pipe maintains spacing**: after recycling, verify the repositioned pipe is `pipeSpacing` to the right of the previous rightmost pipe
- **reset regenerates all pipes**: call `reset()`, verify fresh positions and new gap values

## Dependencies
- Task 1 (GameConstants — pipe constants)
- Task 2 (Pipe model)

## Test Plan
- **File**: `test/pipe_pool_test.dart`
- ~9 unit tests covering initialization, spacing, bounds, scrolling, recycling, and reset

## Notes
- `Random` is injected for testability (seeded in tests, unseeded in production).
- `_randomGapCenter` uses `gapMaxSize / 2` as margin so even the largest gap stays within bounds.
- Recycling finds the rightmost pipe dynamically rather than assuming order, since pipes may be recycled out of order.
