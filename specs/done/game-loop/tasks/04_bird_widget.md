# Task 04: Bird Widget

## Summary

Create a `BirdWidget` that renders the correct bird SVG sprite at a given position with rotation. This is a stateless display component — all logic lives in the parent.

## Implementation Steps

### Step 1: Create `lib/game/bird_widget.dart`

```dart
class BirdWidget extends StatelessWidget {
  final double posX;
  final double posY;
  final double rotation;     // in degrees
  final String spritePath;   // e.g. 'assets/images/bird_mid.svg'

  const BirdWidget({
    super.key,
    required this.posX,
    required this.posY,
    required this.rotation,
    required this.spritePath,
  });
}
```

Build method:
1. Create the SVG image: `SvgPicture.asset(spritePath, width: GameConstants.birdWidth, height: GameConstants.birdHeight)`
2. Wrap in `Transform.rotate(angle: rotation * pi / 180, child: svgImage)` — convert degrees to radians
3. Wrap in `Positioned(left: posX, top: posY, child: rotated)`

**Important**: The widget must be used inside a `Stack` (it returns a `Positioned` widget).

### Step 2: Add bird to GameScreen

In `lib/game/game_screen.dart`:
1. Import `bird_widget.dart`, `bird_physics.dart`, `game_constants.dart`
2. Add `late BirdPhysics _bird;` field to `_GameScreenState`
3. In the `LayoutBuilder` builder, initialize bird position on first build:
   - `posX` = horizontal center: `(screenWidth - GameConstants.birdWidth) / 2`
   - `posY` = vertical center: `(screenHeight - groundHeight - GameConstants.birdHeight) / 2`
   - Use a flag (`_initialized`) to avoid re-initializing on rebuild
4. Add `BirdWidget` to the `Stack` children (after ground):
   - `posX`: bird's horizontal center (fixed, bird doesn't move horizontally)
   - `posY`: `_bird.posY`
   - `rotation`: 0.0 (rotation added in Task 09)
   - `spritePath`: `'assets/images/bird_mid.svg'` (animation added in Task 08)

## Dependencies

- Task 01 (game_constants.dart, bird_physics.dart)
- Task 03 (game_screen.dart with Stack)

## Test Plan

- Visual check: bird appears at center of playable area (above ground)
- Bird is rendered at correct size (51x36 logical pixels)

## Notes

- `BirdWidget` is intentionally stateless and simple — a pure rendering component
- Rotation uses degrees in the API but converts to radians internally for `Transform.rotate`
- The bird's X position is fixed (classic Flappy Bird: bird stays in place, world scrolls)
