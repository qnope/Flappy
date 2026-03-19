# Task 02: Update background.svg to Sky-Only

## Summary

Remove the embedded cloud shapes from `background.svg` so it becomes a pure sky gradient. Clouds are now handled by the separate `clouds.svg` layer (task 01).

## Implementation Steps

1. **Edit `assets/images/background.svg`**
   - Keep the `viewBox="0 0 288 512"` and the sky gradient (`<linearGradient>` from `#87CEEB` to `#E0F0FF`).
   - Keep the full-area `<rect>` that applies the gradient.
   - **Remove** all cloud `<ellipse>`, `<circle>`, or `<path>` elements and their associated shadow/filter definitions.
   - The result should be a clean sky gradient rectangle with no decorative elements.

2. **Verify the gradient still renders correctly** by opening the SVG in a browser.

## Dependencies

- None (can be done in parallel with task 01)

## Test Plan

- **`test/asset_existence_test.dart`**: Existing test verifies `background.svg` has `<svg>` root and `viewBox` — still passes.
- **`test/asset_rendering_test.dart`**: Existing test verifies it renders as `SvgPicture` — still passes.
- **Manual**: Verify the sky gradient renders without clouds in the app.

## Design Notes

- The sky gradient serves as the static backdrop (no scrolling).
- Removing clouds from this layer prevents them from appearing duplicated with the new scrolling clouds layer.
