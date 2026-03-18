# Task 02: Bird Physics Unit Tests

## Summary

Write unit tests for `BirdPhysics` to verify gravity, jump, and ground collision logic before integrating into the UI.

## Implementation Steps

### Step 1: Create `test/bird_physics_test.dart`

Write tests using plain Dart `test` package (no Flutter widget testing needed):

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flappy/game/bird_physics.dart';
import 'package:flappy/game/game_constants.dart';
```

### Test Cases

1. **Initial state** — `BirdPhysics(posY: 100)` has `velocityY == 0.0`
2. **Gravity increases downward velocity** — After `update(0.016, GameConstants.gravity)`, `velocityY > 0` (positive = downward)
3. **Gravity moves bird downward** — After update, `posY` is greater than initial
4. **Jump sets upward velocity** — After `jump(GameConstants.jumpVelocity)`, `velocityY == GameConstants.jumpVelocity` (negative)
5. **Jump replaces velocity, not additive** — Set velocityY to 200, then jump. `velocityY` should equal `jumpVelocity` exactly
6. **Ground collision clamps position** — Bird at posY=450 with birdHeight=36, groundTopY=460. After `clampToGround`, `posY == 424` and `velocityY == 0`
7. **Ground collision returns true** — `clampToGround` returns true when bird is at/below ground
8. **No collision returns false** — `clampToGround` returns false when bird is above ground
9. **Multiple frames accumulate velocity** — Run `update` 10 times, verify velocity increases each frame

## Dependencies

- Task 01 (game_constants.dart, bird_physics.dart)

## Test Plan

- Run: `flutter test test/bird_physics_test.dart`
- All 9 tests should pass

## Notes

- These are pure Dart tests (no widget tester needed), so they run fast
- Use `closeTo` matcher for floating-point comparisons
