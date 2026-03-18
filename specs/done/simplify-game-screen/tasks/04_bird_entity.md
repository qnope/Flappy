# Task 4: Bird Entity Class

## Summary

Create a `Bird` class that encapsulates position, physics, wing state, and rotation into a single cohesive object. Absorbs `BirdPhysics` logic inline (the existing `BirdPhysics` class can be removed or kept as internal implementation — prefer inlining for simplicity since the physics are only 3 short methods).

Covers: US-5

## Implementation Steps

### Step 1: Create `lib/game/bird.dart`

```dart
class Bird {
  double posX;
  double posY;
  double velocityY;
  Wing currentWing;

  Bird({
    required this.posX,
    required this.posY,
    this.velocityY = 0.0,
    this.currentWing = Wing.mid,
  });

  void update(double dt, double gravity) {
    velocityY += gravity * dt;
    posY += velocityY * dt;
  }

  void jump(double jumpVelocity) {
    velocityY = jumpVelocity;
  }

  bool clampToGround(double groundTopY, double birdHeight) {
    final birdBottom = posY + birdHeight;
    if (birdBottom >= groundTopY) {
      posY = groundTopY - birdHeight;
      velocityY = 0.0;
      return true;
    }
    return false;
  }

  double get rotation {
    if (velocityY <= 0) {
      final ratio = (velocityY / GameConstants.jumpVelocity).clamp(0.0, 1.0);
      return GameConstants.maxUpRotation * ratio;
    } else {
      final ratio = (velocityY / GameConstants.maxFallVelocity).clamp(0.0, 1.0);
      return GameConstants.maxDownRotation * ratio;
    }
  }
}
```

- Imports `wing.dart` and `game_constants.dart`.
- `rotation` getter returns 0.0 when `velocityY == 0` (idle case handled by caller passing 0 override or by checking game phase in the controller — see Task 5).
- Physics methods are identical to `BirdPhysics` — same Euler integration, same velocity replacement jump, same ground clamping.

### Step 2: Update `lib/game/bird_widget.dart`

- Change constructor to accept `Wing wing` and `double rotation` (rotation stays explicit because idle state overrides it to 0).
- The widget does NOT take a `Bird` instance to avoid coupling the visual widget to the entity model.

### Step 3: Delete `lib/game/bird_physics.dart`

- All logic is now in `Bird`. Remove the file.

### Step 4: Update `lib/game/game_screen.dart`

- Replace `BirdPhysics _bird` with `Bird _bird`.
- Remove `_calculateBirdRotation()` method — use `_bird.rotation` (or 0.0 in idle).
- Replace `_wingFrameIndex` int with direct `Wing` value from `_bird.currentWing`.
- The controller extraction in Task 5 will clean this further, but this task ensures `Bird` works stand-alone.

## Dependencies

- Task 1 (Wing enum must exist).

## Test Plan

### File: `test/bird_test.dart` (new)

- Initial state: zero velocity, correct position.
- `update()`: gravity increases velocity and moves bird down.
- `jump()`: replaces velocity.
- `clampToGround()`: clamps position and zeros velocity when at ground.
- `clampToGround()`: returns false when above ground.
- `rotation`: returns negative value when rising, positive when falling, 0 when stationary.
- `currentWing`: can be set to any `Wing` value.

### File: `test/bird_physics_test.dart` (update)

- This file should be deleted or merged into `bird_test.dart` since `BirdPhysics` no longer exists.

### Existing tests

- `test/game_screen_test.dart` and integration tests must still pass after the `GameScreen` updates.
