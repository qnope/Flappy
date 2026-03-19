# Task 3 — Update architecture documentation

## Summary

Update the architecture docs to reflect the two simplifications: removal of `posX` from Bird and use of `ListenableBuilder` instead of manual `setState`.

## Implementation Steps

### Step 1: Update `specs/architecture/game/README.md`

- **Game Loop section:** Replace the description "then `setState` to trigger a rebuild" with a description of `ListenableBuilder` listening to `GameController`.
- **Bird Entity section:** Remove `posX` from the list of position fields. Change `Position (posX, posY)` to `Position (posY)`.
- Update the game loop diagram to show that `GameController.notifyListeners()` triggers the `ListenableBuilder` rebuild, not `setState`.

### Step 2: Update `specs/architecture/README.md`

- **Bird line** in the Component Details table: change description from "Bird entity: position, physics, wing state, rotation" to "Bird entity: vertical position, physics, wing state, rotation" (minor clarification).

### Step 3: Update `specs/architecture/tests/README.md`

- **bird_test.dart table:** Remove mention of `posX` testing from the "initial state" row if present.
- **game_controller_test.dart table:** Update "Initial state" row — bird is no longer described as having a horizontal position.

## Dependencies

- Task 1 (remove posX) and Task 2 (ListenableBuilder) must be completed first.

## Test Plan

- No code tests needed — documentation only.
- Manual review: verify that all doc references to `posX`, `birdX`, and `setState` in the game loop are removed or updated.
