# Task 3: GroundWidget

## Summary

Extract the ground rendering from `GameScreen` into a reusable `GroundWidget` stateless widget.

Covers: US-4

## Implementation Steps

### Step 1: Create `lib/game/ground_widget.dart`

```dart
class GroundWidget extends StatelessWidget {
  const GroundWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      GameAssets.ground,
      fit: BoxFit.fitWidth,
    );
  }
}
```

- Imports `flutter_svg` and `game_assets.dart`.
- No size parameters. Uses `BoxFit.fitWidth` so the ground scales to container width.

### Step 2: Update `lib/game/game_screen.dart`

Replace the inline `SvgPicture.asset('assets/images/ground.svg', ...)` block (lines ~137-148) with:

```dart
final groundPositioned = Positioned(
  bottom: 0,
  left: 0,
  right: 0,
  child: const GroundWidget(),
);
```

## Dependencies

- Task 1 (GameAssets must exist).

## Test Plan

### File: `test/ground_widget_test.dart` (new)

- Renders an `SvgPicture` with the ground asset.
- Can be placed inside a constrained container and renders without error.

### Existing tests

- `test/game_screen_test.dart` — "renders ground" test must still pass (checks for `SvgPicture` with `ground.svg` asset name).
