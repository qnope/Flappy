# Task 03: GameScreen Scaffold with Background and Ground

## Summary

Create the `GameScreen` widget with static background and ground scenery, and replace `AssetPreviewScreen` as the app home screen. This establishes the visual foundation for the game.

## Implementation Steps

### Step 1: Create `lib/game/game_screen.dart`

Create a `StatefulWidget` (needs state for game loop later):

- Use a `Stack` to layer: background (bottom), ground (on top at bottom), bird (middle, added later)
- Background: `SvgPicture.asset('assets/images/background.svg')` filling the full screen with `BoxFit.cover`
- Ground: `SvgPicture.asset('assets/images/ground.svg')` positioned at the bottom using `Positioned` with `bottom: 0, left: 0, right: 0`
- Use `LayoutBuilder` to get screen dimensions (needed for physics calculations later)
- Store screen size in state for later use

Structure (following "no nested construction" rule):
```dart
class GameScreen extends StatefulWidget { ... }

class _GameScreenState extends State<GameScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;
          final screenHeight = constraints.maxHeight;

          final background = SvgPicture.asset(
            'assets/images/background.svg',
            width: screenWidth,
            height: screenHeight,
            fit: BoxFit.cover,
          );

          final ground = SvgPicture.asset(
            'assets/images/ground.svg',
            width: screenWidth,
            fit: BoxFit.fitWidth,
          );

          final groundPositioned = Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ground,
          );

          return Stack(
            children: [background, groundPositioned],
          );
        },
      ),
    );
  }
}
```

### Step 2: Update `lib/main.dart`

- Change import from `asset_preview_screen.dart` to `game/game_screen.dart`
- Replace `AssetPreviewScreen()` with `GameScreen()` as the home widget
- Keep `AssetPreviewScreen` file in place (don't delete it)

## Dependencies

- None (uses existing SVG assets)

## Test Plan

- Visual check: run `flutter run -d chrome` and verify background fills screen, ground is at bottom
- Existing asset tests should still pass

## Notes

- Do NOT delete `asset_preview_screen.dart` — it can be useful for asset debugging
- `LayoutBuilder` is essential for responsive sizing across Chrome, iOS, Android
- The `Stack` layering order matters: background first, then ground, then bird (added in later tasks)
