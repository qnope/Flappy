# Task 08: Update BackgroundWidget

## Summary

Verify and minimally adjust `BackgroundWidget` to work with the updated sky-only `background.svg`. Since the widget already renders the SVG with `BoxFit.cover` at full size, **no code change should be needed** — this task is a verification step.

## Implementation Steps

1. **Review `lib/game/background_widget.dart`**
   - Confirm it renders `GameAssets.background` with `BoxFit.cover`, `width: double.infinity`, `height: double.infinity`.
   - No changes expected — the widget is already correct for a static sky layer.

2. **If any change is needed** (unlikely), apply it following the no-nesting rule.

## Dependencies

- Task 02 (updated background.svg without clouds)

## Test Plan

- **`test/background_widget_test.dart`**: Existing tests should pass unchanged.
  - Renders `SvgPicture` with the correct asset.
  - Uses `BoxFit.cover`.

## Design Notes

- The sky layer is **static** (no scrolling). `BackgroundWidget` remains a simple stateless SVG renderer.
- This task exists as a checkpoint to ensure the updated asset doesn't break the existing widget.
