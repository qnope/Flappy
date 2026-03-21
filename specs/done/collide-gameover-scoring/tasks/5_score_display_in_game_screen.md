# Task 5: Add Score Display to GameScreen

## Summary
Display the current score as large white text with a drop shadow, centered at the top of the screen. Visible only during `playing` and `dying` phases.

## Implementation Steps

### Step 1: Add score text widget in `lib/game/game_screen.dart`

In the `build()` method, after building the `children` list, add a score display conditionally:

```dart
final isScoreVisible =
    _controller.gamePhase == GamePhase.playing ||
    _controller.gamePhase == GamePhase.dying;

if (isScoreVisible) {
  final scoreText = Text(
    '${_controller.score}',
    style: const TextStyle(
      fontSize: 48,
      color: Colors.white,
      fontWeight: FontWeight.bold,
      shadows: [
        Shadow(blurRadius: 4, color: Colors.black54),
        Shadow(blurRadius: 8, color: Colors.black26),
      ],
    ),
  );

  final scorePositioned = Align(
    alignment: const Alignment(0, -0.75),
    child: scoreText,
  );

  children.add(scorePositioned);
}
```

### Step 2: Ensure score is rendered above pipes but below ground

The score widget is added to `children` after `groundPositioned`, so it renders on top. The rendering order in the stack should be:
1. background
2. clouds
3. pipes
4. bird
5. ground
6. score text (on top of everything for readability)

If needed, adjust insertion index:
```dart
children.add(scorePositioned); // after ground, so it's on top
```

### Step 3: Hide "Tap to start" during playing/dying/gameOver

The existing "Tap to start" text is already only shown during `idle`. No change needed — verify it's still correct with the new phases.

## Dependencies
- Task 2 (GamePhase `dying`, `gameOver` values used in conditions)
- Task 3 (`score` field on GameController)

## Test Plan
- **File**: `test/game_screen_test.dart`
- Add tests:
  1. **score not visible in idle**: Verify no score text is rendered initially.
  2. **score visible during playing**: Tap to start, verify score "0" is displayed.
  3. **score updates visually**: Simulate enough frames for bird to pass a pipe, verify score text changes.

## Notes
- Two shadows (one tight, one wider) create a readable outline effect against any background.
- `Alignment(0, -0.75)` positions the score in the upper quarter of the screen — high enough to not overlap the bird, low enough to not be cut off by notches.
- The score is rendered as a plain `Text` widget — no custom painting needed.
