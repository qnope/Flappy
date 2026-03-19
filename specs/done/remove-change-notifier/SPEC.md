# Remove ChangeNotifier from GameController — Feature Specification

## 1. Feature Overview
- Remove the `ChangeNotifier` dependency from `GameController`, turning it into a plain Dart class that holds game logic only.
- Replace the `ListenableBuilder` pattern in `GameScreen` with direct `setState()` calls driven by the existing `Ticker` callback and tap handler.
- This simplifies the architecture: the Ticker already fires every frame, so the `ChangeNotifier` → `ListenableBuilder` indirection adds overhead with no benefit.

## 2. User Stories

### US-1: GameController becomes a plain Dart class
- `GameController` no longer extends `ChangeNotifier`.
- All `notifyListeners()` calls are removed from `GameController`.
- The `import 'package:flutter/foundation.dart'` is removed (if no longer needed).
- `GameController` has no `dispose()` method — it is a plain object with no lifecycle.

**Acceptance criteria:**
- `GameController` does not extend or mixin any Flutter class.
- `GameController` has no `dispose()` method.
- `GameController` compiles without `package:flutter/foundation.dart`.

### US-2: GameScreen uses setState instead of ListenableBuilder
- `_onTick` calls `setState(() {})` after `_controller.update(dt)` so the widget rebuilds each frame.
- `_onTap` calls `setState(() {})` after `_controller.onTap()` (though the next tick will also trigger a rebuild, the explicit setState ensures immediate visual feedback on tap).
- The `ListenableBuilder` wrapper is removed from the build tree.
- `_controller.dispose()` is removed from `GameScreen.dispose()` since GameController no longer has a dispose method.

**Acceptance criteria:**
- `ListenableBuilder` is no longer used in `GameScreen`.
- The game renders and updates identically to the current behavior.
- Tap responsiveness is unchanged.

### US-3: Tests are updated
- Remove the test that calls `freshController.dispose()` (edge case test for dispose on uninitialized controller).
- All other existing tests continue to pass without modification (they test game logic, not notification).

**Acceptance criteria:**
- All tests pass.
- No test references `dispose()` on `GameController`.

## 3. Testing and Validation
- **Unit tests:** Existing `game_controller_test.dart` tests remain valid (they test game logic, not the notification mechanism). The one test calling `dispose()` is removed.
- **Widget tests:** If any widget tests exist that rely on `ListenableBuilder`, they should be updated to reflect the `setState` approach.
- **Manual testing:** Verify on Chrome that the game still renders, the bird bobs in idle, responds to tap, falls with gravity, and the background/ground/clouds scroll.
