# Task 06: Idle State (Bobbing + Tap to Start Text)

## Summary

Implement the idle state where the bird bobs gently at the center of the screen and a "Tap to start" text is displayed. This is what the player sees before the first tap.

## Implementation Steps

### Step 1: Add bobbing animation

In `lib/game/game_screen.dart`, create a separate ticker or use an `AnimationController` for the idle bobbing:

Since we already have `SingleTickerProviderStateMixin`, use the existing ticker but handle idle state separately. Alternatively, use a simple time-based approach:

```dart
double _idleTime = 0.0;
```

Start the ticker immediately (but only for bobbing in idle state):
```dart
@override
void initState() {
  super.initState();
  _ticker = createTicker(_onTick);
  _ticker.start(); // Start immediately for bobbing
}
```

In `_onTick`, handle both states:
```dart
void _onTick(Duration elapsed) {
  final dt = (elapsed - _lastTickTime).inMicroseconds / 1000000.0;
  _lastTickTime = elapsed;
  if (dt > 0.1) return;

  setState(() {
    if (_gameState == GameState.idle) {
      _idleTime += dt;
      // Bob up and down using sine wave
      final bobOffset = sin(_idleTime * 2 * pi * GameConstants.bobFrequency) * GameConstants.bobAmplitude;
      _bird.posY = _birdStartY + bobOffset;
    } else {
      _bird.update(dt, GameConstants.gravity);
      _bird.clampToGround(_groundTopY, GameConstants.birdHeight);
    }
  });
}
```

Store `_birdStartY` as the initial center Y position (set during initialization).

### Step 2: Add "Tap to start" text overlay

In the `build` method, when `_gameState == GameState.idle`, add a text widget to the `Stack`:

```dart
if (_gameState == GameState.idle) {
  final tapText = const Text(
    'Tap to start',
    style: TextStyle(
      fontSize: 24,
      color: Colors.white,
      fontWeight: FontWeight.bold,
      shadows: [Shadow(blurRadius: 4, color: Colors.black54)],
    ),
  );

  final tapTextCentered = Positioned(
    top: screenHeight * 0.25,
    left: 0,
    right: 0,
    child: Center(child: tapText),
  );

  // Add tapTextCentered to Stack children
}
```

Use a shadow on the text so it's readable against the sky background.

## Dependencies

- Task 03 (game_screen.dart)
- Task 04 (bird_widget.dart — bird is visible and positioned)
- Task 05 (ticker setup)

## Test Plan

- Visual check: bird bobs up and down smoothly at center
- "Tap to start" text is visible and readable
- Bobbing amplitude and frequency feel gentle (not frantic)

## Notes

- Import `dart:math` for `sin` and `pi`
- The bobbing uses a sine wave for smooth, organic motion
- The text is positioned above center so it doesn't overlap the bird
- Text shadow ensures readability against the light sky background
