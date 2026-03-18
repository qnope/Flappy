# Task 07: Tap to Start and Tap to Jump

## Summary

Add tap input handling. The first tap transitions from idle to playing state and gives the bird its initial jump. Subsequent taps trigger additional jumps.

## Implementation Steps

### Step 1: Add GestureDetector to GameScreen

In `lib/game/game_screen.dart`, wrap the entire `Stack` with a `GestureDetector`:

```dart
final gestureDetector = GestureDetector(
  onTap: _onTap,
  behavior: HitTestBehavior.opaque, // ensure taps register on empty areas
  child: stack,
);
```

Return `gestureDetector` from the `LayoutBuilder` builder instead of the `Stack` directly.

### Step 2: Implement `_onTap`

```dart
void _onTap() {
  if (_gameState == GameState.idle) {
    setState(() {
      _gameState = GameState.playing;
      _bird.posY = _birdStartY;  // reset to center before first jump
      _bird.jump(GameConstants.jumpVelocity);
    });
  } else if (_gameState == GameState.playing) {
    _bird.jump(GameConstants.jumpVelocity);
  }
}
```

### Step 3: Hide "Tap to start" text when playing

The conditional from Task 06 already handles this: the text is only shown when `_gameState == GameState.idle`.

## Dependencies

- Task 01 (game_constants.dart — jumpVelocity)
- Task 05 (ticker and game loop — physics run during playing state)
- Task 06 (idle state — transition from idle to playing)

## Test Plan

- Tap screen: bird jumps upward, gravity pulls it down
- Tap again: bird jumps again
- "Tap to start" text disappears after first tap
- Rapid tapping gives consistent jump height (velocity is replaced, not additive)

## Notes

- `HitTestBehavior.opaque` is critical — without it, taps on transparent areas won't register
- The jump replaces velocity (not additive) per SPEC US-5
- The first tap both starts the game AND gives an initial jump per SPEC US-3
