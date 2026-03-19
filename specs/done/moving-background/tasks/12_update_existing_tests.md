# Task 12: Update Existing Tests and Add New Widget Tests

## Summary

Fix tests broken by the parallax changes and add new test coverage for the clouds widget and updated game screen.

## Implementation Steps

1. **Edit `test/ground_widget_test.dart`**
   - Update all `GroundWidget()` constructor calls to include `scrollOffset: 0.0`.
   - Verify it still finds `SvgPicture` in the widget tree (now finds 2 instead of 1 due to tiling).
   - Adjust `findsOneWidget` to `findsNWidgets(2)` for `SvgPicture` checks if needed.

2. **Edit `test/background_widget_test.dart`**
   - No changes expected — `BackgroundWidget` API is unchanged.
   - Run to confirm it still passes.

3. **Create `test/clouds_widget_test.dart`**
   - Test: renders with `scrollOffset: 0.0` without errors.
   - Test: contains `ScrollingLayerWidget` in widget tree.
   - Test: uses the correct asset (find `SvgPicture` rendering `GameAssets.clouds`).

4. **Edit `test/game_screen_test.dart`**
   - Verify `CloudsWidget` is present in the widget tree.
   - Existing tests for `BackgroundWidget`, `GroundWidget`, and bird should still pass (constructor changes are internal).
   - Add test: all three layers (background, clouds, ground) render in the game screen.

5. **Edit `test/asset_existence_test.dart`**
   - Add `clouds.svg` to the list of assets checked for existence and SVG validity.

6. **Edit `test/asset_rendering_test.dart`**
   - Add a test that `clouds.svg` renders as `SvgPicture` without exceptions.

## Dependencies

- Task 06 (GroundWidget API change)
- Task 07 (CloudsWidget)
- Task 08 (BackgroundWidget verification)
- Task 09 (GameScreen changes)

## Test Plan

- Run: `flutter test` (all tests)
- All existing tests pass (with updates).
- All new tests pass.
- No regressions.

## Design Notes

- The main source of test breakage is `GroundWidget` now requiring `scrollOffset` — all call sites in tests must be updated.
- `SvgPicture` count changes from 1 to 2 in GroundWidget tests because `ScrollingLayerWidget` renders two tiles.
- Keep test patterns consistent with existing test style (no mocking, real assets).
