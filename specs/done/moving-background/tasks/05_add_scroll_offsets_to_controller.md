# Task 05: Add Scroll Offsets to GameController

## Summary

Add scroll offset tracking to `GameController` so it updates ground and clouds offsets every frame. Scrolling runs continuously in **both** idle and playing phases.

## Implementation Steps

1. **Edit `lib/game/game_controller.dart`**

   - Add two new fields:
     ```dart
     double groundScrollOffset = 0.0;
     double cloudsScrollOffset = 0.0;
     ```

   - In `update(double dt)`, **before** the phase-specific logic (so it runs in both phases), add:
     ```dart
     groundScrollOffset += GameConstants.groundScrollSpeed * dt;
     cloudsScrollOffset += GameConstants.cloudsScrollSpeed * dt;
     ```

   - Place these lines after the early return for `dt > 0.1` but before the idle/playing branch.

2. **No reset needed on game restart** — scrolling is continuous and independent of game phase per the spec.

## Dependencies

- Task 03 (scroll speed constants in `GameConstants`)

## Test Plan

- **`test/game_controller_test.dart`**: New tests added in task 10.
  - After `update(1.0)`, `groundScrollOffset` equals `120.0` and `cloudsScrollOffset` equals `30.0`.
  - Offsets update in both idle and playing phases.
  - Offsets do not update when `dt > 0.1` (early return).

## Design Notes

- Offsets grow unboundedly in the controller. The `ScrollingLayerWidget` applies `% tileWidth` to wrap them. This separation keeps the controller simple and layout-agnostic.
- Both offsets are public fields (read by `GameScreen` to pass to widgets). No getters needed — `GameController` is already a `ChangeNotifier` that triggers rebuilds.
