# Task 07: Create CloudsWidget

## Summary

Create a new `CloudsWidget` in `lib/game/clouds_widget.dart` that renders the scrolling clouds layer using `ScrollingLayerWidget`.

## Implementation Steps

1. **Create `lib/game/clouds_widget.dart`**

   ```dart
   import 'package:flutter/material.dart';
   import 'game_assets.dart';
   import 'scrolling_layer_widget.dart';

   class CloudsWidget extends StatelessWidget {
     final double scrollOffset;

     const CloudsWidget({super.key, required this.scrollOffset});

     @override
     Widget build(BuildContext context) {
       return ScrollingLayerWidget(
         assetPath: GameAssets.clouds,
         scrollOffset: scrollOffset,
         fit: BoxFit.cover,
       );
     }
   }
   ```

2. **Follow the same pattern as `GroundWidget`** — thin wrapper around `ScrollingLayerWidget` with layer-specific defaults.

## Dependencies

- Task 01 (clouds.svg asset)
- Task 03 (GameAssets.clouds path)
- Task 04 (ScrollingLayerWidget)

## Test Plan

- **`test/clouds_widget_test.dart`**: Created in task 12.
  - Renders with `scrollOffset: 0.0` without errors.
  - Contains `ScrollingLayerWidget` in widget tree.
  - Uses `GameAssets.clouds` asset path.

## Design Notes

- Uses `BoxFit.cover` so the clouds SVG fills the entire area (full-screen overlay approach).
- The transparent background of `clouds.svg` lets the sky gradient show through.
