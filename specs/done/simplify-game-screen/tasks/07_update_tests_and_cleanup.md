# Task 7: Update Tests and Final Cleanup

## Summary

Update all existing tests to match the new architecture, delete obsolete test files, and verify everything passes. Update the architecture documentation.

## Implementation Steps

### Step 1: Delete `test/bird_physics_test.dart`

- `BirdPhysics` no longer exists. Its tests have been replaced by `test/bird_test.dart` (created in Task 4).

### Step 2: Update `test/game_screen_test.dart`

- Update imports if needed (remove `bird_physics.dart` import if present).
- Verify all existing test assertions still work:
  - SVG asset name checks via `SvgAssetLoader.assetName` — unchanged.
  - `ValueKey('bird')` on Positioned — unchanged.
  - `BirdWidget` type check — unchanged. Its `rotation` field is still a `double`. If tests check `spritePath`, update to check `wing` (a `Wing` enum value) instead.
- If `BirdWidget` constructor changed from `spritePath: String` to `wing: Wing`, update the rotation test that reads `bird.rotation` — the property name is the same.

### Step 3: Update `test/game_flow_integration_test.dart`

- Should require no changes — it only interacts via `GestureDetector` taps and reads `Positioned` top values.
- Run and verify.

### Step 4: Update `test/asset_rendering_test.dart` and `test/asset_existence_test.dart`

- These test raw SVG files and rendering — should be unaffected.
- Run and verify.

### Step 5: Run full test suite

```bash
flutter test
```

All tests must pass.

### Step 6: Update architecture documentation

Update `specs/architecture/README.md` component table to reflect:
- New files: `wing.dart`, `game_assets.dart`, `background_widget.dart`, `ground_widget.dart`, `bird.dart`, `game_controller.dart`.
- Removed: `bird_physics.dart`.

Update `specs/architecture/game/README.md` to reflect the new game loop flow (Ticker → GameController → Bird).

### Step 7: Delete `lib/game/bird_physics.dart`

- If not already deleted in Task 4, ensure it is removed now.

## Dependencies

- All previous tasks (1-6) must be complete.

## Test Plan

- `flutter test` — all tests green.
- `flutter analyze` — no lint warnings or errors.
- Manual run on Chrome — identical gameplay behavior.

## Notes

- This task is a cleanup/verification pass. If tests were already updated in their respective tasks, this task may be very short.
- The `asset_preview_screen.dart` file may still use hardcoded SVG paths. Optionally update it to use `GameAssets` constants — but this is low priority and not required by the spec.
