# Task 5: GameController with ChangeNotifier

## Summary

Extract all game logic from `GameScreen` into a `GameController extends ChangeNotifier`. The controller owns game state, the Bird instance, idle bobbing, wing animation timing, and state transitions.

Covers: US-6

## Implementation Steps

### Step 1: Create `lib/game/game_controller.dart`

```dart
class GameController extends ChangeNotifier {
  GamePhase gamePhase = GamePhase.idle;
  late Bird bird;
  double groundTopY = 0;
  double _idleTime = 0.0;
  int _wingSequenceIndex = 0;
  Duration _wingFrameTimer = Duration.zero;
  bool _initialized = false;

  bool get initialized => _initialized;

  void initialize({
    required double birdX,
    required double birdStartY,
    required double groundTopY,
  }) {
    bird = Bird(posX: birdX, posY: birdStartY);
    this.groundTopY = groundTopY;
    _initialized = true;
  }

  void onTap() {
    if (gamePhase == GamePhase.idle) {
      gamePhase = GamePhase.playing;
      bird.jump(GameConstants.jumpVelocity);
      notifyListeners();
    } else if (gamePhase == GamePhase.playing) {
      bird.jump(GameConstants.jumpVelocity);
      notifyListeners();
    }
  }

  void update(double dt) {
    if (!_initialized) return;
    if (dt > 0.1) return;

    if (gamePhase == GamePhase.idle) {
      _idleTime += dt;
      final bobOffset = sin(_idleTime * 2 * pi * GameConstants.bobFrequency)
          * GameConstants.bobAmplitude;
      bird.posY = _birdStartY + bobOffset;
    } else {
      bird.update(dt, GameConstants.gravity);
      bird.clampToGround(groundTopY, GameConstants.birdHeight);
    }

    _updateWingAnimation(dt);
    notifyListeners();
  }

  double get birdRotation {
    if (gamePhase == GamePhase.idle) return 0.0;
    return bird.rotation;
  }

  void _updateWingAnimation(double dt) {
    if (gamePhase == GamePhase.idle || bird.velocityY <= 0) {
      _wingFrameTimer += Duration(microseconds: (dt * 1000000).round());
      if (_wingFrameTimer >= GameConstants.wingFrameDuration) {
        _wingFrameTimer = Duration.zero;
        _wingSequenceIndex =
            (_wingSequenceIndex + 1) % Wing.animationSequence.length;
      }
      bird.currentWing = Wing.animationSequence[_wingSequenceIndex];
    } else {
      bird.currentWing = Wing.mid;
      _wingFrameTimer = Duration.zero;
    }
  }
}
```

- Stores `_birdStartY` internally (set during `initialize()`) for idle bobbing reference.
- All math imports (`dart:math` for `sin`, `pi`) move here from `game_screen.dart`.
- `birdRotation` getter handles the idle-phase override (return 0.0).

### Step 2: Verify `GameController` is testable without Flutter

- The controller imports `package:flutter/foundation.dart` for `ChangeNotifier` only.
- No widget dependencies — fully unit-testable.

## Dependencies

- Task 1 (Wing enum).
- Task 4 (Bird entity).
- `game_state.dart` (GamePhase — unchanged).
- `game_constants.dart` (unchanged after Task 1).

## Test Plan

### File: `test/game_controller_test.dart` (new)

**State transitions:**
- Starts in `GamePhase.idle`.
- `onTap()` during idle → transitions to `GamePhase.playing`.
- `onTap()` during playing → bird jumps (velocity changes).

**Idle behavior:**
- `update()` during idle → bird Y oscillates (bobbing).
- Bird wing cycles through animation sequence during idle.
- `birdRotation` returns 0.0 during idle.

**Playing behavior:**
- `update()` during playing → bird Y increases (gravity pulls down).
- Bird wing cycles when rising, freezes to `Wing.mid` when falling.
- `birdRotation` returns negative when rising, positive when falling.

**Ground collision:**
- After many updates without tap, bird reaches ground and stops.

**Edge cases:**
- `update()` before `initialize()` is a no-op.
- `update()` with dt > 0.1 is skipped.

## Notes

- The `_birdStartY` value is needed for idle bobbing. Store it during `initialize()`.
