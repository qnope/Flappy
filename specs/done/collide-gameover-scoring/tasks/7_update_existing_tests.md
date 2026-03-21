# Task 7: Update Existing Tests for New Game Phases

## Summary
Update existing test files to account for the new `dying` and `gameOver` phases, and add integration tests for the full game cycle (idle → playing → dying → gameOver → idle).

## Implementation Steps

### Step 1: Update `test/game_screen_test.dart`

Review all existing tests. Tests that check `GamePhase` values or verify game behavior may need updates:

1. Any test that checks for `GamePhase.playing` after ground collision should now expect `GamePhase.gameOver` instead (ground collision during playing now triggers gameOver).
2. Verify that existing rendering tests still pass — the addition of the score and overlay widgets should not break existing widget-finding tests.

### Step 2: Update `test/game_flow_integration_test.dart`

Add new integration tests for the full cycle:

1. **full game cycle test**:
   - Start in idle (verify "Tap to start" visible)
   - Tap to start playing (verify "Tap to start" gone)
   - Simulate collision (let bird fall to ground or into pipe)
   - Verify game over overlay appears
   - Tap to restart
   - Verify back in idle ("Tap to start" visible again)

2. **score persists through dying**:
   - Start playing, earn some score
   - Collide with pipe (dying)
   - Verify score is still visible during dying
   - Bird falls to ground (gameOver)
   - Verify final score shown in overlay

### Step 3: Update `test/game_controller_test.dart`

Review existing tests for any that may be affected:

1. Tests that verify `bird.clampToGround` behavior during playing — now this triggers `gameOver` instead of just clamping. Update expectations.
2. Tests that check `groundScrollOffset` changes — verify they still work since scrolling now stops during dying/gameOver.

### Step 4: Run all tests

Run `flutter test` and fix any failures caused by the new phase transitions or UI changes.

## Dependencies
- Task 1 through 6 (all implementation tasks complete)

## Test Plan
- **Files**: `test/game_screen_test.dart`, `test/game_flow_integration_test.dart`, `test/game_controller_test.dart`
- All existing tests pass (with necessary updates)
- 2+ new integration tests for full game cycle
- Full `flutter test` passes with 0 failures

## Notes
- This task is intentionally last — it verifies and stabilizes all previous work.
- Focus on fixing broken tests first, then adding new integration coverage.
- Ground collision during `playing` now transitions to `gameOver` directly (not `dying` then `gameOver`), which is the expected behavior per the spec: "il passe directement en game over".
