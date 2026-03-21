# Task 6: Add Game Over Overlay to GameScreen

## Summary
Display a semi-transparent overlay with "Game Over" text, the final score, and a "Tap to restart" button when the game is in `gameOver` phase. The overlay fades in using `AnimatedOpacity`.

## Implementation Steps

### Step 1: Add game over overlay widget in `lib/game/game_screen.dart`

In the `build()` method, add the overlay as the last element in `children`. It's always in the widget tree (for `AnimatedOpacity` to work) but only visible during `gameOver`:

```dart
final isGameOver = _controller.gamePhase == GamePhase.gameOver;

final gameOverText = Text(
  'Game Over',
  style: const TextStyle(
    fontSize: 48,
    color: Colors.white,
    fontWeight: FontWeight.bold,
    shadows: [
      Shadow(blurRadius: 6, color: Colors.black87),
    ],
  ),
);

final finalScoreText = Text(
  'Score: ${_controller.score}',
  style: const TextStyle(
    fontSize: 32,
    color: Colors.white,
    fontWeight: FontWeight.w500,
    shadows: [
      Shadow(blurRadius: 4, color: Colors.black54),
    ],
  ),
);

final restartText = Text(
  'Tap to restart',
  style: const TextStyle(
    fontSize: 20,
    color: Colors.white70,
  ),
);

final spacer = const SizedBox(height: 16);

final overlayColumn = Column(
  mainAxisSize: MainAxisSize.min,
  children: [gameOverText, spacer, finalScoreText, spacer, restartText],
);

final overlayCenter = Center(child: overlayColumn);

final overlayBackground = Container(
  color: Colors.black54,
  child: overlayCenter,
);

final gameOverOverlay = Positioned.fill(
  child: AnimatedOpacity(
    opacity: isGameOver ? 1.0 : 0.0,
    duration: const Duration(milliseconds: 500),
    child: IgnorePointer(
      ignoring: !isGameOver,
      child: overlayBackground,
    ),
  ),
);

children.add(gameOverOverlay);
```

### Step 2: Update `_onTap()` to handle game over

The existing `_onTap()` already delegates to `_controller.onTap()` which handles the gameOver → idle transition (Task 4). No change needed — the `GestureDetector` already wraps the entire screen.

### Step 3: Verify rendering order

Final stack order:
1. background
2. clouds
3. pipes
4. bird
5. ground
6. "Tap to start" text (idle only)
7. score text (playing/dying only)
8. game over overlay (always present, opacity 0 or 1)

The game over overlay is the last child, so it renders on top of everything, including the score. During gameOver, the overlay shows its own score display, so the in-game score (from Task 5) is naturally hidden behind the overlay or not shown (since it's only visible during playing/dying).

## Dependencies
- Task 4 (`onTap()` handles gameOver → idle reset)
- Task 5 (score display — to ensure no visual conflict)

## Test Plan
- **File**: `test/game_screen_test.dart`
- Add tests:
  1. **game over overlay not visible in idle**: Verify `AnimatedOpacity` has `opacity: 0.0`.
  2. **game over overlay visible in gameOver**: Simulate collision and fall to ground, verify overlay has `opacity: 1.0` and contains "Game Over" text.
  3. **game over shows final score**: Verify the score value is displayed in the overlay.
  4. **tap during gameOver restarts game**: Tap during gameOver, verify return to idle state (bird bobs, "Tap to start" shown).

## Notes
- `AnimatedOpacity` handles the fade-in animation automatically. The `duration: 500ms` gives a smooth fade.
- `IgnorePointer(ignoring: !isGameOver)` prevents the overlay from intercepting taps when invisible. When visible, taps pass through to the `GestureDetector` which calls `_controller.onTap()`.
- The overlay is always in the widget tree so that the fade-in animation can play when transitioning to `gameOver`.
- The overlay uses `Colors.black54` as background to darken the frozen game behind it.
