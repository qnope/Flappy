# Task 02: Create Background SVG

## Summary

Create `assets/images/background.svg` — a cartoon sky scene with clouds and a gradient sky. This serves as the full-screen background for the game.

## Implementation Steps

1. **Create `assets/images/background.svg`**
   - SVG dimensions: `viewBox="0 0 288 512"` (portrait mobile aspect ratio)
   - **Sky gradient**: Vertical linear gradient from light blue (#87CEEB) at top to pale blue (#E0F0FF) at bottom
   - **Clouds**: 2–3 cartoon clouds with rounded white shapes, subtle gray (#E8E8E8) shadows
   - **Style**: Rounded shapes, vivid colors, visible outlines (cartoon style per spec)
   - No raster images — pure SVG paths and shapes only

## Files Created

- `assets/images/background.svg`

## Dependencies

- Task 01 (Flutter project initialized, `assets/images/` directory exists)

## Test Plan

- File exists at `assets/images/background.svg`
- File is valid SVG (parseable XML with `<svg>` root element)
- Has appropriate viewBox attribute
- Renders correctly when loaded with `SvgPicture.asset()`

## Notes

- The background should fill the screen and look good when scaled to different screen sizes.
- Keep the SVG simple enough to render performantly but detailed enough to look like a cartoon.
