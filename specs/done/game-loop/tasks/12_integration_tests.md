# Task 12: Integration Tests

## Summary

Write integration tests that verify the full game flow: screen loads, bird idles, tap to start, gravity pulls bird down, tap to jump, and ground collision.

## Implementation Steps

### Step 1: Create `test/game_flow_integration_test.dart`

Use Flutter's widget test framework (integration_test package is for device testing; widget tests suffice here for flow verification):

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flappy/game/game_screen.dart';
```

### Test Cases

#### Test 1: Full game flow
1. Pump `MaterialApp(home: GameScreen())`
2. Verify "Tap to start" text is visible
3. Verify bird is at approximately center Y position
4. Tap the screen
5. Pump one frame (16ms) — verify bird has moved upward (Y decreased)
6. Pump several more frames (~500ms) — bird should be falling (Y increasing)
7. Tap again — bird should jump (Y decreases next frame)
8. Verify "Tap to start" text is NOT visible

#### Test 2: Ground collision
1. Pump `MaterialApp(home: GameScreen())`
2. Tap to start
3. Pump many frames (e.g., 3 seconds worth) without tapping — bird should fall to ground
4. Record bird Y position
5. Pump more frames — bird Y should NOT increase further (stays at ground level)

#### Test 3: Bird can exit top of screen
1. Pump `MaterialApp(home: GameScreen())`
2. Tap rapidly many times to send bird very high
3. Verify bird Y position goes negative (above screen)

### Helper: Getting bird position

To verify bird position in tests, you may need to:
- Find the `Positioned` widget containing the bird SVG
- Read its `top` property
- Or use a `Key` on the bird widget for easier finding

Consider adding a `ValueKey('bird')` to the `BirdWidget` to make test finding easier.

## Dependencies

- Task 11 (widget tests — ensures basic rendering works)
- All implementation tasks (01-10)

## Test Plan

- Run: `flutter test test/game_flow_integration_test.dart`
- All 3 tests should pass

## Notes

- These tests verify end-to-end behavior, not individual components
- Use `tester.binding.setSurfaceSize(Size(288, 512))` for consistent test dimensions matching the background SVG viewBox
- The integration tests complement unit tests (Task 02) and widget tests (Task 11)
- Adding a `Key` to BirdWidget makes position assertions much easier
