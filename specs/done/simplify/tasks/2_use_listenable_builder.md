# Task 2 — Use `ListenableBuilder` for automatic rebuilds

## Summary

Replace the manual `setState(() {})` call in `GameScreen._onTick` with a `ListenableBuilder` that listens to `GameController`. Since `GameController` already calls `notifyListeners()` in `update()` and `onTap()`, the widget tree will rebuild automatically.

## Implementation Steps

### Step 1: Remove `setState` from `_onTick`

**File:** `lib/game/game_screen.dart`

- In `_onTick()` (line 43–51), remove the `setState(() {});` call (line 50)
- The method becomes:
  ```dart
  void _onTick(Duration elapsed) {
    if (!_controller.initialized) return;
    final dt = (elapsed - _lastTickTime).inMicroseconds / 1000000.0;
    _lastTickTime = elapsed;
    _controller.update(dt);
  }
  ```

### Step 2: Wrap the `LayoutBuilder` body in a `ListenableBuilder`

**File:** `lib/game/game_screen.dart`

- In `build()`, wrap the returned widget tree (from the `LayoutBuilder`'s builder return) with a `ListenableBuilder` that listens to `_controller`.
- The `ListenableBuilder` should be placed inside the `LayoutBuilder` builder, wrapping the `GestureDetector` return. This way the `LayoutBuilder` still provides constraints for initialization, but the `ListenableBuilder` handles rebuilds when `_controller` notifies.

Concretely, the `LayoutBuilder` builder should:
1. Keep the initialization block (checking `!_controller.initialized` and calling `initialize()`) outside of `ListenableBuilder`
2. Return a `ListenableBuilder` that:
   - `listenable: _controller`
   - `builder:` contains the existing widget tree (background, ground, bird, tap text, stack, GestureDetector)

### Step 3: Verify no other `setState` calls remain

**File:** `lib/game/game_screen.dart`

- Confirm there are no remaining `setState` calls in the file.
- `_onTap()` already delegates to `_controller.onTap()` which calls `notifyListeners()`, so no `setState` is needed there either.

## Dependencies

- **Task 1** should be completed first (removes `birdX` from initialize), but this task is technically independent — it only changes the rebuild mechanism, not the data model.

## Test Plan

- Run `flutter test test/game_screen_test.dart` — all rendering, tap, animation, and rotation tests pass
- Run `flutter test test/game_flow_integration_test.dart` — full flow unchanged
- Run `flutter test` — all tests green

Key verification points:
- Bird still animates during idle (bobbing + wing cycling)
- Tap still transitions from idle to playing
- Gravity still affects bird after tap
- Wing animation still works (cycles when rising, freezes when falling)
- Bird rotation still applies correctly

## Notes

- `GameScreen` stays as a `StatefulWidget` because it needs `SingleTickerProviderStateMixin` for the `Ticker`.
- `ListenableBuilder` is a Flutter built-in widget (available since Flutter 3.10) that rebuilds its subtree whenever the `Listenable` notifies.
- The `_controller.dispose()` call in `dispose()` must remain to clean up the `ChangeNotifier`.
