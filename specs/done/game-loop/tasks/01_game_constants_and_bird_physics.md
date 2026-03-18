# Task 01: Game Constants and Bird Physics Model

## Summary

Create the game constants file and bird physics model. These are the foundational data structures that the rest of the game loop depends on.

## Implementation Steps

### Step 1: Create `lib/game/game_constants.dart`

Define all physics and layout constants:

```dart
class GameConstants {
  // Bird physics
  static const double gravity = 1200.0;        // pixels/sec² downward
  static const double jumpVelocity = -400.0;   // pixels/sec upward (negative = up)
  static const double maxFallVelocity = 600.0;  // terminal velocity

  // Bird dimensions (based on SVG viewBox 34x24, scaled up)
  static const double birdWidth = 51.0;
  static const double birdHeight = 36.0;

  // Bird rotation
  static const double maxUpRotation = -25.0;    // degrees when rising
  static const double maxDownRotation = 70.0;   // degrees when falling

  // Ground height (based on SVG viewBox 336x112, proportional)
  static const double groundHeightRatio = 0.2;  // ground takes 20% of screen height

  // Idle bobbing
  static const double bobAmplitude = 8.0;       // pixels up/down
  static const double bobFrequency = 2.0;       // cycles per second

  // Wing animation
  static const Duration wingFrameDuration = Duration(milliseconds: 150);
}
```

### Step 2: Create `lib/game/game_state.dart`

```dart
enum GameState {
  idle,    // before first tap, bird bobs at center
  playing, // game loop active, gravity on
}
```

### Step 3: Create `lib/game/bird_physics.dart`

Create a plain Dart class (no Flutter dependency) that manages bird position and velocity:

```dart
class BirdPhysics {
  double posY;          // vertical position (pixels from top)
  double velocityY;     // vertical velocity (pixels/sec, negative = up)

  BirdPhysics({required this.posY, this.velocityY = 0.0});

  /// Apply gravity and update position for the given delta time
  void update(double dt, double gravity) {
    velocityY += gravity * dt;
    posY += velocityY * dt;
  }

  /// Set velocity to jump value (replaces current velocity)
  void jump(double jumpVelocity) {
    velocityY = jumpVelocity;
  }

  /// Clamp bird to stay above ground
  /// Returns true if bird hit the ground
  bool clampToGround(double groundTopY, double birdHeight) {
    final birdBottom = posY + birdHeight;
    if (birdBottom >= groundTopY) {
      posY = groundTopY - birdHeight;
      velocityY = 0.0;
      return true;
    }
    return false;
  }
}
```

## Dependencies

- None (foundational task)

## Test Plan

- Tested in Task 02 (bird_physics_test.dart)

## Notes

- `posY` is measured from the top of the screen (Flutter convention)
- Negative velocity = upward movement
- Ground height is a ratio to support different screen sizes
- All constants tunable — values chosen for a fun Flappy Bird feel
