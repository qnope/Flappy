# Task 08: Bird Wing Animation

## Summary

Implement sprite cycling for the bird's wing animation. The bird cycles through 4 frames (up -> mid -> down -> mid) when rising or idle, and shows `bird_mid.svg` when falling.

## Implementation Steps

### Step 1: Define sprite list

In `lib/game/game_screen.dart` (or as a constant in `game_constants.dart`):

```dart
static const List<String> wingSprites = [
  'assets/images/bird_up.svg',
  'assets/images/bird_mid.svg',
  'assets/images/bird_down.svg',
  'assets/images/bird_mid.svg',
];
```

### Step 2: Add animation state to `_GameScreenState`

```dart
int _wingFrameIndex = 0;
Duration _wingFrameTimer = Duration.zero;
```

### Step 3: Update wing frame in `_onTick`

In the `_onTick` method, update the wing frame timer:

```dart
// Wing animation logic
if (_gameState == GameState.idle || _bird.velocityY <= 0) {
  // Flap when idle or rising
  _wingFrameTimer += Duration(microseconds: (dt * 1000000).round());
  if (_wingFrameTimer >= GameConstants.wingFrameDuration) {
    _wingFrameTimer = Duration.zero;
    _wingFrameIndex = (_wingFrameIndex + 1) % GameConstants.wingSprites.length;
  }
} else {
  // Wings level when falling
  _wingFrameIndex = 1; // bird_mid.svg
  _wingFrameTimer = Duration.zero;
}
```

### Step 4: Pass current sprite to BirdWidget

Update the `BirdWidget` instantiation in `build`:

```dart
final bird = BirdWidget(
  posX: _birdX,
  posY: _bird.posY,
  rotation: ...,
  spritePath: GameConstants.wingSprites[_wingFrameIndex],
);
```

## Dependencies

- Task 04 (bird_widget.dart — accepts spritePath)
- Task 05 (ticker — drives frame updates)
- Task 06 (idle state — animation during idle)

## Test Plan

- Visual check: bird wings cycle smoothly during idle
- After tap, wings continue to cycle while bird rises
- When bird falls, wings stay in mid position
- Animation speed feels natural (~150ms per frame)

## Notes

- The 4-frame cycle (up -> mid -> down -> mid) creates a smooth flapping effect
- `velocityY <= 0` means rising or stationary = flap; `velocityY > 0` means falling = wings level
- Timer is reset when switching to falling state to ensure clean restart when bird rises again
