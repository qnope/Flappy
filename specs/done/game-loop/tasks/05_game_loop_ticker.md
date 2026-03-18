# Task 05: Game Loop with Ticker

## Summary

Set up the core game loop using Flutter's `Ticker` mechanism. The ticker fires every frame (~60fps), calculates delta time, updates bird physics, and triggers a rebuild via `setState`.

## Implementation Steps

### Step 1: Add `SingleTickerProviderStateMixin` to GameScreen

In `lib/game/game_screen.dart`:

```dart
class _GameScreenState extends State<GameScreen>
    with SingleTickerProviderStateMixin {
  late Ticker _ticker;
  Duration _lastTickTime = Duration.zero;
  GameState _gameState = GameState.idle;
  // ... existing fields
}
```

### Step 2: Create and configure the Ticker

In `initState`:
```dart
@override
void initState() {
  super.initState();
  _ticker = createTicker(_onTick);
  // Don't start the ticker yet — it starts on first tap
}
```

In `dispose`:
```dart
@override
void dispose() {
  _ticker.dispose();
  super.dispose();
}
```

### Step 3: Implement `_onTick` callback

```dart
void _onTick(Duration elapsed) {
  final dt = (elapsed - _lastTickTime).inMicroseconds / 1000000.0;
  _lastTickTime = elapsed;

  // Skip unreasonably large dt (e.g. first frame or after pause)
  if (dt > 0.1) return;

  setState(() {
    _bird.update(dt, GameConstants.gravity);
    _bird.clampToGround(_groundTopY, GameConstants.birdHeight);
  });
}
```

### Step 4: Compute `_groundTopY`

In the `LayoutBuilder` builder, calculate ground top Y:
```dart
final groundHeight = screenHeight * GameConstants.groundHeightRatio;
_groundTopY = screenHeight - groundHeight;
```

Store `_groundTopY` as a field in the state class so `_onTick` can access it.

## Dependencies

- Task 01 (game_constants.dart, game_state.dart, bird_physics.dart)
- Task 03 (game_screen.dart)
- Task 04 (bird_widget.dart — to see the bird moving)

## Test Plan

- At this point the ticker is created but NOT started (starts on tap, Task 07)
- Verify no crashes on screen load
- Verify `dispose` is called without errors when navigating away

## Notes

- `SingleTickerProviderStateMixin` is more efficient than `TickerProviderStateMixin` since we only need one ticker
- Delta time capping at 0.1s prevents physics explosions after app resume/tab switch
- The ticker is NOT started in `initState` — it starts when the player taps (Task 07)
- `_lastTickTime` is reset when starting the ticker to avoid a large first dt
