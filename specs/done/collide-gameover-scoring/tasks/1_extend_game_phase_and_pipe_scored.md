# Task 1: Extend GamePhase Enum + Add Scored Flag to Pipe

## Summary
Add `dying` and `gameOver` values to `GamePhase`, and add a `scored` boolean to `Pipe` so each pipe can only count once toward the score.

## Implementation Steps

### Step 1: Update `lib/game/game_state.dart`

Add two new phases:

```dart
enum GamePhase {
  idle,     // before first tap, bird bobs at center
  playing,  // game loop active, gravity on
  dying,    // bird hit a pipe, falling to ground, no input
  gameOver, // bird on ground, game over overlay shown
}
```

### Step 2: Update `lib/game/pipe.dart`

Add a `scored` field:

```dart
class Pipe {
  double posX;
  double gapCenterY;
  double gapSize;
  bool scored;

  Pipe({
    required this.posX,
    required this.gapCenterY,
    required this.gapSize,
    this.scored = false,
  });

  double get gapTop => gapCenterY - gapSize / 2;
  double get gapBottom => gapCenterY + gapSize / 2;
}
```

### Step 3: Update `lib/game/pipe_pool.dart`

Reset `scored` in two places:

1. In `reset()`, set `scored: false` in the `Pipe` constructor (already default, but explicit):
   ```dart
   pipes.add(Pipe(
     posX: posX,
     gapCenterY: _randomGapCenter(),
     gapSize: _randomGapSize(),
     scored: false,
   ));
   ```

2. In `_recyclePipes()`, reset scored when a pipe is recycled:
   ```dart
   pipe.scored = false;
   ```
   Add this line after `pipe.gapSize = _randomGapSize();`.

### Step 4: Update `test/pipe_test.dart`

Add test:
- **scored defaults to false**: `Pipe(posX: 100, gapCenterY: 300, gapSize: 140).scored` is `false`.
- **scored can be set**: create pipe, set `scored = true`, verify it's `true`.

### Step 5: Update `test/pipe_pool_test.dart`

Add test:
- **scored resets on pool reset**: Set some pipes' `scored = true`, call `reset()`, verify all pipes have `scored == false`.
- **scored resets on recycle**: Move a pipe off-screen, call `update()` to trigger recycle, verify recycled pipe has `scored == false`.

## Dependencies
- None. This is a foundational task.

## Test Plan
- **Files**: `test/pipe_test.dart`, `test/pipe_pool_test.dart`
- 4 new tests total
- All existing pipe/pipe_pool tests must still pass

## Notes
- `GamePhase` extension does not break existing code — `idle` and `playing` remain unchanged. Downstream tasks handle the new phases.
- `scored` defaults to `false`, so existing `Pipe` construction remains compatible.
