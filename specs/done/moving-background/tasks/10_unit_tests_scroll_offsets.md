# Task 10: Unit Tests for Scroll Offsets

## Summary

Add unit tests in `test/game_controller_test.dart` to verify that scroll offsets update correctly in `GameController`.

## Implementation Steps

1. **Edit `test/game_controller_test.dart`**

   - Add a new test group `'Scroll offsets'` with the following tests:

   - **Test: offsets start at zero**
     ```dart
     test('scroll offsets start at zero', () {
       expect(controller.groundScrollOffset, 0.0);
       expect(controller.cloudsScrollOffset, 0.0);
     });
     ```

   - **Test: offsets update after one second**
     ```dart
     test('scroll offsets update after update', () {
       controller.initialize(birdStartY, groundTopY);
       controller.update(1.0);  // dt > 0.1 skipped, use 0.05
       // Actually use dt = 0.05:
       controller.update(0.05);
       expect(controller.groundScrollOffset, GameConstants.groundScrollSpeed * 0.05);
       expect(controller.cloudsScrollOffset, GameConstants.cloudsScrollSpeed * 0.05);
     });
     ```

   - **Test: offsets update in idle phase**
     ```dart
     test('scroll offsets update during idle phase', () {
       controller.initialize(birdStartY, groundTopY);
       controller.update(0.016); // ~1 frame
       expect(controller.groundScrollOffset, greaterThan(0.0));
       expect(controller.cloudsScrollOffset, greaterThan(0.0));
     });
     ```

   - **Test: offsets update in playing phase**
     ```dart
     test('scroll offsets update during playing phase', () {
       controller.initialize(birdStartY, groundTopY);
       controller.onTap(); // transition to playing
       controller.update(0.016);
       expect(controller.groundScrollOffset, greaterThan(0.0));
       expect(controller.cloudsScrollOffset, greaterThan(0.0));
     });
     ```

   - **Test: offsets do not update when dt > 0.1**
     ```dart
     test('scroll offsets unchanged when dt > 0.1', () {
       controller.initialize(birdStartY, groundTopY);
       controller.update(0.2); // skipped
       expect(controller.groundScrollOffset, 0.0);
       expect(controller.cloudsScrollOffset, 0.0);
     });
     ```

   - **Test: ground scrolls faster than clouds**
     ```dart
     test('ground scrolls faster than clouds', () {
       controller.initialize(birdStartY, groundTopY);
       controller.update(0.016);
       expect(controller.groundScrollOffset, greaterThan(controller.cloudsScrollOffset));
     });
     ```

## Dependencies

- Task 05 (scroll offsets in GameController)

## Test Plan

- Run: `flutter test test/game_controller_test.dart`
- All new and existing tests pass.

## Design Notes

- Use `dt = 0.016` (one frame at 60fps) or `dt = 0.05` for tests — stay under the 0.1 skip threshold.
- Test exact values where possible using `GameConstants` values for expected calculations.
