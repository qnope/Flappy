# Task 11: Widget Tests

## Summary

Write widget tests for the GameScreen to verify rendering, tap interaction, sprite animation, and rotation behavior.

## Implementation Steps

### Step 1: Create `test/game_screen_test.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flappy/game/game_screen.dart';
```

### Test Cases

#### Rendering tests
1. **GameScreen renders background** — Pump `GameScreen`, find `SvgPicture` with `background.svg` asset
2. **GameScreen renders ground** — Find `SvgPicture` with `ground.svg` asset
3. **GameScreen renders bird** — Find `SvgPicture` with a bird SVG asset (any of the 3 sprites)
4. **Tap to start text visible initially** — Find `Text` widget containing "Tap to start"

#### Tap interaction tests
5. **Tap hides start text** — Pump, tap, pump again. Verify "Tap to start" text is no longer visible
6. **Tap triggers state change** — After tap, the game state transitions from idle to playing (verify by checking that gravity starts affecting bird — pump several frames and check position changes)

#### Animation tests
7. **Bird sprite changes during idle** — Pump widget, advance time by 600ms (4 frames at 150ms), verify that `SvgPicture` asset path cycles through different bird sprites
8. **Bird shows mid sprite when falling** — Tap to start, pump enough frames for bird to start falling, verify sprite is `bird_mid.svg`

#### Rotation tests
9. **Bird has no rotation in idle state** — Verify `Transform.rotate` angle is 0 during idle
10. **Bird rotates upward after tap** — Tap, pump one frame, verify rotation angle is negative (upward tilt)

### Helper: Wrapping GameScreen for tests

```dart
Widget createTestApp() {
  return const MaterialApp(home: GameScreen());
}
```

### Note on timing

Use `tester.pump(Duration(milliseconds: 16))` to advance one frame, or `tester.pump(Duration(milliseconds: 150))` to advance one wing animation frame.

## Dependencies

- Task 03 through Task 10 (all implementation tasks)

## Test Plan

- Run: `flutter test test/game_screen_test.dart`
- All 10 tests should pass

## Notes

- Widget tests use `WidgetTester` from `flutter_test`
- Use `find.byType(SvgPicture)` and inspect properties to check which SVG is rendered
- Use `tester.tap(find.byType(GestureDetector))` for tap simulation
- May need to use `tester.binding.setSurfaceSize` to set a consistent test screen size
