# Task 01: Create Clouds SVG Asset

## Summary

Create a new tileable `clouds.svg` in `assets/images/`. The SVG covers a full-screen area (matching `background.svg` dimensions) with simple white/light-gray clouds on a **transparent** background. Clouds are positioned in the upper ~40% of the viewport. The left and right edges must connect seamlessly for horizontal tiling.

## Implementation Steps

1. **Create `assets/images/clouds.svg`**
   - ViewBox: `0 0 288 512` (same as `background.svg`)
   - Transparent background (no `<rect>` fill)
   - Draw 3–5 simple cartoon clouds using ellipses/paths in the upper 40% of the viewport (y: 50–200)
   - Use white (`#FFFFFF`) and light gray (`#F0F0F0`) fills with slight opacity variation
   - Ensure the rightmost cloud wraps to the left edge so left-right tiling is seamless
   - Keep the style consistent with the existing cartoon aesthetic (rounded shapes, simple fills)

2. **No `pubspec.yaml` change needed** — the entire `assets/images/` directory is already declared.

## Dependencies

- None (standalone asset creation)

## Test Plan

- **`test/asset_existence_test.dart`**: Will be updated in task 12 to verify `clouds.svg` exists and has a valid `<svg>` root with `viewBox`.
- **Manual**: Open the SVG in a browser and verify clouds are visible, transparent background, and tiling works when two copies are placed side by side.

## Design Notes

- Keep the SVG lightweight (few paths) for rendering performance.
- Clouds should be sparse enough that the parallax effect is noticeable but not distracting.
- The transparent background allows the sky gradient from `background.svg` to show through.
