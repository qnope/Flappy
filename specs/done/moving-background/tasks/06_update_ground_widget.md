# Task 06: Update GroundWidget to Scroll

## Summary

Update `GroundWidget` to accept a `scrollOffset` parameter and use `ScrollingLayerWidget` internally for seamless horizontal scrolling.

## Implementation Steps

1. **Edit `lib/game/ground_widget.dart`**

   - Add a `scrollOffset` constructor parameter:
     ```dart
     final double scrollOffset;
     const GroundWidget({super.key, required this.scrollOffset});
     ```

   - Replace the current `SvgPicture.asset(...)` body with:
     ```dart
     @override
     Widget build(BuildContext context) {
       return ScrollingLayerWidget(
         assetPath: GameAssets.ground,
         scrollOffset: scrollOffset,
         fit: BoxFit.fitWidth,
       );
     }
     ```

   - Add import for `scrolling_layer_widget.dart`.

## Dependencies

- Task 04 (ScrollingLayerWidget)

## Test Plan

- **`test/ground_widget_test.dart`**: Updated in task 12.
  - Renders with `scrollOffset: 0.0`.
  - Contains `ScrollingLayerWidget` in widget tree.
  - Contains two `SvgPicture` instances (from ScrollingLayerWidget).

## Design Notes

- `BoxFit.fitWidth` is preserved from the original implementation — the ground scales to fill screen width.
- The `GroundWidget` wrapper is kept (rather than using `ScrollingLayerWidget` directly in `GameScreen`) to maintain the existing abstraction and encapsulate the ground's specific fit behavior.
