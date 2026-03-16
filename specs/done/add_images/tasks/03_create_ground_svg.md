# Task 03: Create Ground SVG

## Summary

Create `assets/images/ground.svg` — a scrolling ground/floor strip displayed at the bottom of the screen. It must be tileable horizontally.

## Implementation Steps

1. **Create `assets/images/ground.svg`**
   - SVG dimensions: `viewBox="0 0 336 112"` (wide for tiling, short height)
   - **Ground surface**: Green grass layer on top with jagged/wavy edge
   - **Dirt layer**: Brown/tan dirt below the grass
   - **Details**: Small grass tufts or texture dots on the surface
   - **Style**: Cartoon style — vivid greens (#4CAF50, #388E3C), warm browns (#8D6E63, #6D4C41)
   - **Tiling**: Left and right edges must align seamlessly when placed side by side

## Files Created

- `assets/images/ground.svg`

## Dependencies

- Task 01 (Flutter project initialized, `assets/images/` directory exists)

## Test Plan

- File exists at `assets/images/ground.svg`
- File is valid SVG (parseable XML with `<svg>` root element)
- Left and right edges tile seamlessly (visual check)
- Renders correctly when loaded with `SvgPicture.asset()`

## Notes

- The ground will be scrolled horizontally during gameplay, so seamless tiling is critical.
- Keep the width wider than the viewport to reduce visible repeat patterns.
