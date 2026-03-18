# Task 1: Wing Enum and GameAssets Registry

## Summary

Create the `Wing` enum with asset path getters and a `GameAssets` class centralizing all SVG asset paths. Update `GameConstants` to remove the `wingSprites` list.

Covers: US-1, US-2

## Implementation Steps

### Step 1: Create `lib/game/wing.dart`

Create the `Wing` enum with three values and an `assetPath` getter:

```dart
enum Wing {
  up('assets/images/bird_up.svg'),
  mid('assets/images/bird_mid.svg'),
  down('assets/images/bird_down.svg');

  final String assetPath;
  const Wing(this.assetPath);
}
```

Also define the wing animation sequence as a `static const List<Wing>` on the enum (replacing the 4-frame string list in `GameConstants`):

```dart
static const List<Wing> animationSequence = [up, mid, down, mid];
```

### Step 2: Create `lib/game/game_assets.dart`

Create `GameAssets` with named constants for non-bird SVG paths:

```dart
class GameAssets {
  static const String background = 'assets/images/background.svg';
  static const String ground = 'assets/images/ground.svg';
  static const String pipe = 'assets/images/pipe.svg';
  static const String pipeTop = 'assets/images/pipe_top.svg';
}
```

### Step 3: Update `lib/game/game_constants.dart`

- Remove the `wingSprites` list (now lives on `Wing.animationSequence`).
- The rest of the constants stay as-is.

### Step 4: Update `lib/game/bird_widget.dart`

- Change `spritePath` parameter from `String` to `Wing`.
- Load SVG from `wing.assetPath` instead of raw string.
- Update import to include `wing.dart`.

### Step 5: Update `lib/game/game_screen.dart`

- Replace `_wingFrameIndex` (int) with `_wingFrame` (Wing).
- Use `Wing.animationSequence` instead of `GameConstants.wingSprites`.
- Replace index-based access with direct `Wing` value.
- Use `GameAssets.background` and `GameAssets.ground` instead of hardcoded strings.

## Dependencies

- None (this is the foundation task).

## Test Plan

### File: `test/wing_test.dart` (new)

- `Wing.up.assetPath` returns correct path.
- `Wing.mid.assetPath` returns correct path.
- `Wing.down.assetPath` returns correct path.
- `Wing.animationSequence` has 4 entries in correct order.

### Existing tests

- `test/game_screen_test.dart` — must still pass (bird sprite checks still find SVGs with `bird_` in name).
- `test/asset_rendering_test.dart` — must still pass.
- `test/game_flow_integration_test.dart` — must still pass.

## Notes

- The `BirdWidget` API changes from `String spritePath` to `Wing wing`. All callers must be updated in the same step to avoid compile errors.
