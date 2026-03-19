# Task 1: Strip ChangeNotifier from GameController

## Summary
Remove the `ChangeNotifier` base class and all notification calls from `GameController`, making it a plain Dart class.

## Implementation Steps

1. **Remove the `extends ChangeNotifier`** in `lib/game/game_controller.dart` (line 10):
   - Change `class GameController extends ChangeNotifier {` → `class GameController {`

2. **Remove all `notifyListeners()` calls** in `lib/game/game_controller.dart`:
   - Line 39 (inside `onTap`, idle → playing branch)
   - Line 42 (inside `onTap`, playing branch)
   - Line 65 (inside `update`)

3. **Remove the `foundation.dart` import** (line 3):
   - Delete `import 'package:flutter/foundation.dart';`

## Dependencies
- None. This task is independent and must be done **before** Task 2 (GameScreen update).

## Test Plan
- After this task, `game_controller_test.dart` will fail on the `dispose()` call (line 174). That is expected and fixed in Task 3.
- All other tests in `game_controller_test.dart` should still pass since they test logic, not notifications.

## Notes
- No new code is added — this task is purely deletions.
