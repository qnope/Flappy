# Task 4: Integrate PipePool into GameController + Tests

## Summary
Wire the `PipePool` into `GameController` so pipes scroll with the ground and reset when the game starts.

## Implementation Steps

### Step 1: Modify `lib/game/game_controller.dart`

1. Add imports for `pipe_pool.dart` and `dart:math` (Random already imported).

2. Add fields:
   ```dart
   late PipePool pipePool;
   double _screenWidth = 0;
   ```

3. Update `initialize()` to accept `screenWidth` and create the pipe pool:
   ```dart
   void initialize({
     required double birdStartY,
     required double groundTopY,
     required double screenWidth,
     Random? random,
   }) {
     bird = Bird(posY: birdStartY);
     _birdStartY = birdStartY;
     this.groundTopY = groundTopY;
     _screenWidth = screenWidth;
     pipePool = PipePool(
       groundTopY: groundTopY,
       screenWidth: screenWidth,
       random: random,
     );
     _initialized = true;
   }
   ```

4. In `update(double dt)`, after advancing `groundScrollOffset`, add pipe update:
   ```dart
   final groundDistance = GameConstants.groundScrollSpeed * dt;
   groundScrollOffset += groundDistance;
   cloudsScrollOffset += GameConstants.cloudsScrollSpeed * dt;
   pipePool.update(groundDistance);
   ```
   Note: replace the existing `groundScrollOffset += GameConstants.groundScrollSpeed * dt;` line — extract the distance into a local variable so it can be shared with `pipePool.update()`.

5. In `onTap()`, when transitioning from idle to playing, reset the pipe pool:
   ```dart
   if (gamePhase == GamePhase.idle) {
     gamePhase = GamePhase.playing;
     bird.posY = _birdStartY;
     bird.jump(GameConstants.jumpVelocity);
     pipePool.reset();
   }
   ```

### Step 2: Update `lib/game/game_screen.dart`

Update the `_controller.initialize()` call to pass `screenWidth`:
```dart
_controller.initialize(
  birdStartY: birdStartY,
  groundTopY: groundTopY,
  screenWidth: screenWidth,
);
```

### Step 3: Update existing tests in `test/game_controller_test.dart`

Update all `controller.initialize()` calls to include `screenWidth: 360`:
```dart
controller.initialize(
  birdStartY: 200,
  groundTopY: 400,
  screenWidth: 360,
);
```

### Step 4: Add new tests to `test/game_controller_test.dart`

Add a new test group:

```dart
group('Pipe integration', () {
  test('pipe pool is created on initialize', () {
    expect(controller.pipePool.pipes.length, equals(GameConstants.pipePoolSize));
  });

  test('pipes move at ground scroll speed', () {
    final initialPosX = controller.pipePool.pipes[0].posX;
    controller.update(0.05);
    final expectedDistance = GameConstants.groundScrollSpeed * 0.05;
    expect(controller.pipePool.pipes[0].posX, closeTo(initialPosX - expectedDistance, 0.001));
  });

  test('pipes reset when transitioning from idle to playing', () {
    // Scroll pipes for a while
    for (int i = 0; i < 50; i++) {
      controller.update(0.016);
    }
    final posXBeforeReset = controller.pipePool.pipes[0].posX;

    controller.onTap(); // idle -> playing, triggers reset
    final posXAfterReset = controller.pipePool.pipes[0].posX;

    // After reset, first pipe should be back at starting position
    expect(posXAfterReset, greaterThan(posXBeforeReset));
  });

  test('pipes do not reset on subsequent taps (jumps)', () {
    controller.onTap(); // idle -> playing
    controller.update(0.016);
    final posXBefore = controller.pipePool.pipes[0].posX;
    controller.onTap(); // jump
    final posXAfter = controller.pipePool.pipes[0].posX;
    expect(posXAfter, equals(posXBefore));
  });
});
```

## Dependencies
- Task 1 (GameConstants)
- Task 2 (Pipe)
- Task 3 (PipePool)

## Test Plan
- **File**: `test/game_controller_test.dart`
- 4 new tests in a "Pipe integration" group
- All existing tests updated to pass `screenWidth` — must still pass

## Notes
- The ground scroll distance is extracted into a local variable and shared between `groundScrollOffset` and `pipePool.update()` to guarantee they stay in sync (US-1).
- `pipePool.reset()` is called in `onTap()` when going idle→playing (US-5), not on every tap.
- `Random` parameter is optional on `initialize()` — only used in tests for determinism.
