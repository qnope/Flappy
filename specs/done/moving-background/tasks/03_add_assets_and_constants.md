# Task 03: Add Asset Paths and Scroll Constants

## Summary

Register the new `clouds.svg` asset path in `GameAssets` and add parallax scroll speed constants to `GameConstants`.

## Implementation Steps

1. **Edit `lib/game/game_assets.dart`**
   - Add: `static const String clouds = 'assets/images/clouds.svg';`

2. **Edit `lib/game/game_constants.dart`**
   - Add scroll speed constants:
     ```dart
     // Parallax scroll speeds (pixels per second)
     static const double groundScrollSpeed = 120.0;
     static const double cloudsScrollSpeed = 30.0;
     ```

## Dependencies

- None

## Test Plan

- **Compile check**: `flutter analyze` passes.
- Constants are exercised by tasks 05 (GameController) and tested in task 10 (unit tests).

## Design Notes

- The sky layer is static (speed = 0), so no constant is needed for it.
- Speeds chosen: ground at 120 px/s (brisk), clouds at 30 px/s (4× slower) for a classic parallax depth effect.
