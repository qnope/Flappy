# Task 4: Add Game Over Reset in GameController

## Summary
Handle the tap during `gameOver` phase to fully reset the game back to `idle` state, completing the game cycle: idle → playing → dying → gameOver → idle.

## Implementation Steps

### Step 1: Update `onTap()` in `lib/game/game_controller.dart`

Add a `gameOver` branch that resets everything:

```dart
void onTap() {
  if (gamePhase == GamePhase.idle) {
    gamePhase = GamePhase.playing;
    bird.posY = _birdStartY;
    bird.jump(GameConstants.jumpVelocity);
    pipePool.reset();
    score = 0;
  } else if (gamePhase == GamePhase.playing) {
    bird.jump(GameConstants.jumpVelocity);
  } else if (gamePhase == GamePhase.gameOver) {
    _resetToIdle();
  }
  // dying: ignore taps
}
```

### Step 2: Add `_resetToIdle()` private method

```dart
void _resetToIdle() {
  gamePhase = GamePhase.idle;
  bird.posY = _birdStartY;
  bird.velocityY = 0.0;
  bird.currentWing = Wing.mid;
  score = 0;
  _idleTime = 0.0;
  _wingSequenceIndex = 0;
  _wingFrameTimer = Duration.zero;
  pipePool.reset();
}
```

### Step 3: Add tests to `test/game_controller_test.dart`

New test group `'Game over reset'`:

1. **tap during gameOver resets to idle**: Set `gamePhase = GamePhase.gameOver`, call `onTap()`, verify `gamePhase == GamePhase.idle`.
2. **bird position resets after gameOver**: After reset, verify `bird.posY == birdStartY` and `bird.velocityY == 0`.
3. **score resets after gameOver**: Set score to 10, set gameOver, call `onTap()`, verify `score == 0`.
4. **pipes reset after gameOver**: Modify some pipe positions, set gameOver, call `onTap()`, verify pipes are back at starting positions.
5. **full cycle: idle → playing → dying → gameOver → idle**: Simulate a complete game cycle and verify the final state is idle.

## Dependencies
- Task 2 (dying/gameOver phase handling)
- Task 3 (score field)

## Test Plan
- **File**: `test/game_controller_test.dart`
- 5 new tests in `'Game over reset'` group
- All existing tests must still pass

## Notes
- `_resetToIdle()` is extracted as a private method to keep `onTap()` clean and allow future reuse.
- Wing animation state (`_wingSequenceIndex`, `_wingFrameTimer`) is also reset to ensure clean restart.
- The `_idleTime` is reset to 0 so the bobbing animation starts fresh.
