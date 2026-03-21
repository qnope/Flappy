# Task 2: Add Collision Detection to GameController

## Summary
Add pipe collision and ground collision detection in `GameController`. When the bird collides with a pipe during `playing`, transition to `dying`. When the bird collides with the ground during `playing`, transition directly to `gameOver`.

## Implementation Steps

### Step 1: Re-add `_screenWidth` field to `lib/game/game_controller.dart`

The `_screenWidth` field was previously removed as unused. Re-add it — it's now needed to compute the bird's horizontal position for collision and scoring.

```dart
double _screenWidth = 0;
```

In `initialize()`, store it:
```dart
_screenWidth = screenWidth;
```

### Step 2: Add `_birdRect` helper in `lib/game/game_controller.dart`

Compute the bird's bounding rectangle (AABB). The bird is always centered horizontally at `_screenWidth / 2`:

```dart
({double left, double right, double top, double bottom}) get _birdRect {
  final centerX = _screenWidth / 2;
  return (
    left: centerX - GameConstants.birdWidth / 2,
    right: centerX + GameConstants.birdWidth / 2,
    top: bird.posY,
    bottom: bird.posY + GameConstants.birdHeight,
  );
}
```

### Step 3: Add `_checkPipeCollisions()` method in `lib/game/game_controller.dart`

Check if the bird's rect overlaps any pipe's solid area (above gap or below gap):

```dart
bool _checkPipeCollisions() {
  final birdRect = _birdRect;
  for (final pipe in pipePool.pipes) {
    final pipeLeft = pipe.posX - GameConstants.pipeCapWidth / 2;
    final pipeRight = pipe.posX + GameConstants.pipeCapWidth / 2;

    final horizontalOverlap =
        birdRect.right > pipeLeft && birdRect.left < pipeRight;
    if (!horizontalOverlap) continue;

    final inGap = birdRect.top >= pipe.gapTop && birdRect.bottom <= pipe.gapBottom;
    if (!inGap) return true;
  }
  return false;
}
```

### Step 4: Update `update()` method in `lib/game/game_controller.dart`

In the `playing` phase block (the `else` branch of `if (gamePhase == GamePhase.idle)`):

After `bird.update(dt, GameConstants.gravity)`:
1. Check pipe collision:
   ```dart
   if (_checkPipeCollisions()) {
     gamePhase = GamePhase.dying;
     return;
   }
   ```
2. Update ground collision — `clampToGround` already returns `true` when grounded. Change the existing call:
   ```dart
   final hitGround = bird.clampToGround(groundTopY, GameConstants.birdHeight);
   if (hitGround) {
     gamePhase = GamePhase.gameOver;
     return;
   }
   ```

The full playing section becomes:
```dart
if (gamePhase == GamePhase.playing) {
  bird.update(dt, GameConstants.gravity);
  if (_checkPipeCollisions()) {
    gamePhase = GamePhase.dying;
    return;
  }
  final hitGround = bird.clampToGround(groundTopY, GameConstants.birdHeight);
  if (hitGround) {
    gamePhase = GamePhase.gameOver;
    return;
  }
}
```

### Step 5: Refactor `update()` to handle all phases

Restructure `update()` with explicit phase handling:

```dart
void update(double dt) {
  if (!_initialized) return;
  if (dt > 0.1) return;

  if (gamePhase == GamePhase.idle) {
    final groundDistance = GameConstants.groundScrollSpeed * dt;
    groundScrollOffset += groundDistance;
    cloudsScrollOffset += GameConstants.cloudsScrollSpeed * dt;
    pipePool.update(groundDistance);

    _idleTime += dt;
    final bobOffset =
        sin(_idleTime * 2 * pi * GameConstants.bobFrequency) *
            GameConstants.bobAmplitude;
    bird.posY = _birdStartY + bobOffset;
  } else if (gamePhase == GamePhase.playing) {
    final groundDistance = GameConstants.groundScrollSpeed * dt;
    groundScrollOffset += groundDistance;
    cloudsScrollOffset += GameConstants.cloudsScrollSpeed * dt;
    pipePool.update(groundDistance);

    bird.update(dt, GameConstants.gravity);
    if (_checkPipeCollisions()) {
      gamePhase = GamePhase.dying;
      return;
    }
    final hitGround = bird.clampToGround(groundTopY, GameConstants.birdHeight);
    if (hitGround) {
      gamePhase = GamePhase.gameOver;
      return;
    }
  } else if (gamePhase == GamePhase.dying) {
    bird.update(dt, GameConstants.gravity);
    final hitGround = bird.clampToGround(groundTopY, GameConstants.birdHeight);
    if (hitGround) {
      gamePhase = GamePhase.gameOver;
    }
  }
  // gameOver: nothing updates

  _updateWingAnimation(dt);
}
```

Key behaviors:
- **idle**: scrolling + bobbing (unchanged)
- **playing**: scrolling + gravity + collision checks
- **dying**: gravity only (no scrolling, no pipe movement), bird falls to ground
- **gameOver**: nothing updates

### Step 6: Update `onTap()` to ignore dying phase

```dart
void onTap() {
  if (gamePhase == GamePhase.idle) {
    gamePhase = GamePhase.playing;
    bird.posY = _birdStartY;
    bird.jump(GameConstants.jumpVelocity);
    pipePool.reset();
  } else if (gamePhase == GamePhase.playing) {
    bird.jump(GameConstants.jumpVelocity);
  }
  // dying and gameOver: ignore taps (gameOver tap handled in task 4)
}
```

### Step 7: Update `_updateWingAnimation()` for dying/gameOver

During dying and gameOver, freeze wing at `Wing.mid`:

```dart
void _updateWingAnimation(double dt) {
  if (gamePhase == GamePhase.dying || gamePhase == GamePhase.gameOver) {
    bird.currentWing = Wing.mid;
    _wingFrameTimer = Duration.zero;
    return;
  }
  // ... existing logic unchanged
}
```

### Step 8: Add tests to `test/game_controller_test.dart`

New test group `'Collision detection'`:

1. **pipe collision triggers dying**: Position bird overlapping a pipe (above gap), call `update()`, verify `gamePhase == GamePhase.dying`.
2. **no collision when bird is in gap**: Position bird within the gap, call `update()`, verify `gamePhase == GamePhase.playing`.
3. **ground collision during playing triggers gameOver**: Set bird velocity very high (falling fast), update enough frames for bird to hit ground, verify `gamePhase == GamePhase.gameOver`.
4. **dying bird falls to ground then gameOver**: Set phase to dying, update frames, verify bird falls and eventually `gamePhase == GamePhase.gameOver`.
5. **dying phase stops scrolling**: Record `groundScrollOffset`, set phase to dying, call `update()`, verify offset unchanged.
6. **tap ignored during dying**: Set phase to dying, call `onTap()`, verify still dying.

## Dependencies
- Task 1 (GamePhase `dying`/`gameOver`, Pipe `scored`)

## Test Plan
- **File**: `test/game_controller_test.dart`
- 6 new tests in `'Collision detection'` group
- All existing tests must still pass

## Notes
- The bird's horizontal position is always `_screenWidth / 2` (centered by `Align` widget in `GameScreen`).
- Collision uses `pipeCapWidth` (60px) as the horizontal hitbox — this matches the widest visual part of the pipe (the cap).
- The collision check verifies the bird is NOT fully inside the gap. If any part of the bird is above `gapTop` or below `gapBottom` while horizontally overlapping, it's a collision.
- During `dying`, the wing animation freezes at `Wing.mid` — this naturally happens because velocityY > 0 in the old code, but we make it explicit for clarity.
