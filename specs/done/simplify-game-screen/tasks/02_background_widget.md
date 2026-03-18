# Task 2: BackgroundWidget

## Summary

Extract the background rendering from `GameScreen` into a reusable `BackgroundWidget` stateless widget.

Covers: US-3

## Implementation Steps

### Step 1: Create `lib/game/background_widget.dart`

```dart
class BackgroundWidget extends StatelessWidget {
  const BackgroundWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      GameAssets.background,
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.cover,
    );
  }
}
```

- Imports `flutter_svg` and `game_assets.dart`.
- No size parameters — fills parent via `double.infinity` and `BoxFit.cover`.

### Step 2: Update `lib/game/game_screen.dart`

Replace the inline `SvgPicture.asset('assets/images/background.svg', ...)` block (lines ~126-135) with:

```dart
final background = Positioned.fill(
  child: const BackgroundWidget(),
);
```

## Dependencies

- Task 1 (GameAssets must exist).

## Test Plan

### File: `test/background_widget_test.dart` (new)

- Renders an `SvgPicture` with the background asset.
- Can be placed inside a `SizedBox` and renders without error.

### Existing tests

- `test/game_screen_test.dart` — "renders background" test must still pass (it checks for `SvgPicture` with `background.svg` asset name).
