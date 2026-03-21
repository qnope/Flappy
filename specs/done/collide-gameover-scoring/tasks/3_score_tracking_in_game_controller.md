# Task 3: Add Score Tracking to GameController

## Summary
Add a score counter that increments by 1 each time the bird's center passes the right edge of a pipe. Each pipe can only be scored once.

## Implementation Steps

### Step 1: Add `score` field to `lib/game/game_controller.dart`

```dart
int score = 0;
```

### Step 2: Add `_updateScore()` method to `lib/game/game_controller.dart`

The bird's center X is `_screenWidth / 2`. A pipe's right edge is `pipe.posX + GameConstants.pipeCapWidth / 2`. When the bird's center passes this edge, increment score and mark pipe as scored:

```dart
void _updateScore() {
  final birdCenterX = _screenWidth / 2;
  for (final pipe in pipePool.pipes) {
    if (pipe.scored) continue;
    final pipeRightEdge = pipe.posX + GameConstants.pipeCapWidth / 2;
    if (birdCenterX > pipeRightEdge) {
      pipe.scored = true;
      score++;
    }
  }
}
```

### Step 3: Call `_updateScore()` in `update()`

In the `playing` phase block, after the collision checks and before `_updateWingAnimation`:

```dart
} else if (gamePhase == GamePhase.playing) {
  // ... existing scrolling, gravity, collision code ...
  _updateScore();
}
```

### Step 4: Reset score in `onTap()` during idle → playing transition

In the `onTap()` method, when transitioning from idle to playing, reset score:

```dart
if (gamePhase == GamePhase.idle) {
  gamePhase = GamePhase.playing;
  bird.posY = _birdStartY;
  bird.jump(GameConstants.jumpVelocity);
  pipePool.reset();
  score = 0;
}
```

### Step 5: Add tests to `test/game_controller_test.dart`

New test group `'Score tracking'`:

1. **score starts at 0**: Verify `controller.score == 0` after initialization.
2. **score increments when bird passes pipe**: Use a deterministic `Random`, position pipes so bird center is past the first pipe's right edge after some updates. Verify `score == 1`.
3. **pipe scored only once**: After bird passes a pipe and score becomes 1, call `update()` several more times. Verify score stays 1 (pipe.scored prevents double-counting).
4. **score resets on new game**: Set score to 5, trigger `onTap()` from idle, verify `score == 0`.

## Dependencies
- Task 1 (Pipe `scored` flag)
- Task 2 (`_screenWidth` field, `update()` restructure)

## Test Plan
- **File**: `test/game_controller_test.dart`
- 4 new tests in `'Score tracking'` group
- All existing tests must still pass

## Notes
- We use `pipeCapWidth` for the scoring edge to match the visual right edge of the pipe (consistent with collision detection).
- The scoring check runs only during `playing` phase — during `dying` and `gameOver`, score is frozen.
