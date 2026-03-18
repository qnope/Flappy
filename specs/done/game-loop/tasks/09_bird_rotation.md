# Task 09: Bird Rotation

## Summary

Add rotation to the bird based on its vertical velocity. The bird tilts upward when rising and downward when falling, with smooth proportional transitions.

## Implementation Steps

### Step 1: Add rotation calculation method

In `lib/game/game_screen.dart`, add a method to compute rotation:

```dart
double _calculateBirdRotation() {
  if (_gameState == GameState.idle) return 0.0;

  final velocity = _bird.velocityY;

  if (velocity <= 0) {
    // Rising: map velocity to [-25°, 0°]
    // jumpVelocity is the max upward speed
    final ratio = (velocity / GameConstants.jumpVelocity).clamp(0.0, 1.0);
    return GameConstants.maxUpRotation * ratio;
  } else {
    // Falling: map velocity to [0°, 70°]
    // Use maxFallVelocity as the reference for max rotation
    final ratio = (velocity / GameConstants.maxFallVelocity).clamp(0.0, 1.0);
    return GameConstants.maxDownRotation * ratio;
  }
}
```

### Step 2: Pass rotation to BirdWidget

In the `build` method, compute and pass rotation:

```dart
final birdRotation = _calculateBirdRotation();

final bird = BirdWidget(
  posX: _birdX,
  posY: _bird.posY,
  rotation: birdRotation,
  spritePath: GameConstants.wingSprites[_wingFrameIndex],
);
```

## Dependencies

- Task 01 (game_constants.dart — maxUpRotation, maxDownRotation, maxFallVelocity)
- Task 04 (bird_widget.dart — rotation parameter and Transform.rotate)
- Task 05 (ticker — velocity is updated each frame)

## Test Plan

- Visual check: bird tilts upward (-25°) immediately after tap
- Bird gradually tilts downward as it falls
- At terminal velocity, bird reaches max tilt (+70°)
- During idle state, bird has no rotation (0°)
- Transition between up/down tilt is smooth

## Notes

- Rotation is proportional to velocity, creating a natural feel
- The rotation is calculated fresh each frame (no interpolation needed — velocity changes smoothly)
- Max up rotation (-25°) is less extreme than max down rotation (+70°) per the SPEC
- During idle, rotation is locked at 0° regardless of bobbing movement
