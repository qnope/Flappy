# Task 1 — Remove `posX` from Bird model

## Summary

Remove the `posX` property from the `Bird` class. The bird is always horizontally centered via `Alignment(0, ...)` in the widget tree, so `posX` is dead code.

## Implementation Steps

### Step 1: Remove `posX` from `Bird` constructor and class body

**File:** `lib/game/bird.dart`

- Remove the `double posX;` field (line 5)
- Remove `required this.posX,` from the constructor (line 11)
- The constructor becomes: `Bird({required this.posY, ...})`

### Step 2: Remove `birdX` parameter from `GameController.initialize()`

**File:** `lib/game/game_controller.dart`

- Remove `required double birdX,` parameter from `initialize()` (line 23)
- Remove `posX: birdX` from the `Bird(...)` constructor call (line 27)
- The Bird instantiation becomes: `bird = Bird(posY: birdStartY);`

### Step 3: Remove `birdX` calculation and parameter from `GameScreen`

**File:** `lib/game/game_screen.dart`

- Remove `final birdX = (screenWidth - GameConstants.birdWidth) / 2;` (line 64)
- Remove `birdX: birdX,` from the `_controller.initialize(...)` call (line 67)

### Step 4: Update `bird_test.dart`

**File:** `test/bird_test.dart`

- Remove all `posX: 50` named arguments from every `Bird(...)` constructor call
- Remove the `expect(bird.posX, equals(50.0));` assertion (line 10)
- Every `Bird(posX: 50, posY: ...)` becomes `Bird(posY: ...)`

### Step 5: Update `game_controller_test.dart`

**File:** `test/game_controller_test.dart`

- Remove `birdX: 100,` from the `controller.initialize(...)` call in `setUp()` (line 13)

## Dependencies

- None. This task is self-contained.

## Test Plan

- Run `flutter test test/bird_test.dart` — all tests pass with `posX` removed
- Run `flutter test test/game_controller_test.dart` — all tests pass with `birdX` removed
- Run `flutter test test/game_screen_test.dart` — bird still centered, all rendering tests pass
- Run `flutter test test/game_flow_integration_test.dart` — full flow unchanged
- Run `flutter test` — all tests green

## Notes

- The `birdWidth` constant in `game_constants.dart` is still used by `BirdWidget` for rendering dimensions, so it stays.
- The `Alignment(0, alignedY)` in `GameScreen` already hardcodes horizontal centering, confirming `posX` was never used for positioning in the widget tree.
