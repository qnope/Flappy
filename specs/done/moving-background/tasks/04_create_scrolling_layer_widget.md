# Task 04: Create ScrollingLayerWidget

## Summary

Create a reusable `ScrollingLayerWidget` in `lib/game/scrolling_layer_widget.dart`. This stateless widget renders two side-by-side copies of an SVG asset and shifts them horizontally by a given offset, creating a seamless infinite scroll effect.

## Implementation Steps

1. **Create `lib/game/scrolling_layer_widget.dart`**

   ```dart
   class ScrollingLayerWidget extends StatelessWidget {
     final String assetPath;
     final double scrollOffset;
     final BoxFit fit;

     const ScrollingLayerWidget({
       super.key,
       required this.assetPath,
       required this.scrollOffset,
       this.fit = BoxFit.cover,
     });

     @override
     Widget build(BuildContext context) {
       return LayoutBuilder(
         builder: (context, constraints) {
           final tileWidth = constraints.maxWidth;
           final wrappedOffset = scrollOffset % tileWidth;

           final tile1 = SvgPicture.asset(
             assetPath,
             width: tileWidth,
             fit: fit,
           );

           final sizedTile1 = SizedBox(width: tileWidth, child: tile1);

           final tile2 = SvgPicture.asset(
             assetPath,
             width: tileWidth,
             fit: fit,
           );

           final sizedTile2 = SizedBox(width: tileWidth, child: tile2);

           final row = Row(
             children: [sizedTile1, sizedTile2],
           );

           final translated = Transform.translate(
             offset: Offset(-wrappedOffset, 0),
             child: row,
           );

           final clipped = ClipRect(child: translated);

           return clipped;
         },
       );
     }
   }
   ```

2. **Follow the no-nesting rule**: Each widget is declared as a variable, then passed to its parent.

3. **How it works**:
   - `LayoutBuilder` provides the parent's width as `tileWidth`.
   - Two SVG copies sit in a `Row` (total width = 2 × tileWidth).
   - `Transform.translate` shifts the row left by `wrappedOffset`.
   - `ClipRect` clips overflow so only one screen-width of content is visible.
   - When `scrollOffset` increases by `tileWidth`, it wraps to 0 — seamless loop.

## Dependencies

- Task 03 (for asset paths used by callers, not by this widget directly)

## Test Plan

- **`test/scrolling_layer_widget_test.dart`**: Created in task 11.
  - Renders without error with a valid SVG asset.
  - Contains two `SvgPicture` widgets (tiles).
  - `ClipRect` is present in the widget tree.
  - `Transform` is present with the correct offset.

## Design Notes

- The widget is **stateless** — the scroll offset is computed externally (by `GameController`) and passed in. This keeps the widget pure and testable.
- Using `constraints.maxWidth` as tile width means each tile fills exactly one screen width. The SVG's own aspect ratio and the `fit` parameter control how it scales within that width.
- The modulo operation (`scrollOffset % tileWidth`) prevents floating-point overflow for long-running sessions.
