# Task 2: Update GameScreen to Use setState

## Summary
Replace the `ListenableBuilder` pattern with direct `setState()` calls in the Ticker callback and tap handler.

## Implementation Steps

1. **Update `_onTick`** in `lib/game/game_screen.dart` (line 44–51):
   - After `_controller.update(dt)`, wrap with `setState(() { ... })` or call `setState(() {})` after.

2. **Update `_onTap`** in `lib/game/game_screen.dart` (line 40–42):
   - After `_controller.onTap()`, call `setState(() {})` to ensure immediate rebuild on tap.

3. **Remove `ListenableBuilder`** from `build()` method (line 71–147):
   - Remove the `ListenableBuilder` wrapper. The builder content becomes direct children of the `LayoutBuilder` builder.

4. **Remove `_controller.dispose()`** from `dispose()` (line 36):
   - `GameController` no longer has `dispose()`, so remove the call. Only `_ticker.dispose()` remains.

## Dependencies
- **Task 1** must be completed first (GameController no longer has `notifyListeners` or `dispose`).

## Test Plan
- `test/game_screen_test.dart`: Verify existing widget tests still pass (they test rendering and interaction, not the notification mechanism).
- `test/game_flow_integration_test.dart`: Verify integration tests still pass.
- Manual: Run on Chrome, verify bird bobs, tap starts game, gravity works, scrolling works.

## Notes
- The `build()` method structure stays the same — only the `ListenableBuilder` wrapper is removed.
- `setState` in `_onTick` triggers a rebuild every frame, same as `notifyListeners` did before.
