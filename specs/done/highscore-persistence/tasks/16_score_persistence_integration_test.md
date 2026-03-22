# Task 16: Score Persistence Integration Test

## Summary
Write an integration test verifying that scores persist across simulated app restarts and that the full flow (play → game over → score saved → restart → leaderboard shows score) works end-to-end.

## Implementation Steps

1. **Create `test/score_persistence_integration_test.dart`**

2. **Test cases**:

   | Test | What is verified |
   |------|------------------|
   | Score saved on game over | Play game to game over, verify score appears in repository |
   | Score survives restart | Save score, create new GameScreen with same repository, verify leaderboard shows saved score |
   | Top 10 maintained | Add 12 scores, verify only top 10 retained |
   | New high score detected | Play and achieve top-10 score, verify "New High Score!" shown |
   | Leaderboard on idle | After restart, idle screen shows previous scores |
   | First launch empty | Fresh repository, idle screen shows only "Tap to start" |

3. **Test setup**:
   - Use test ScoreRepository (from test_helpers.dart)
   - Use `tester.pumpWidget()` with real game rendering
   - Simulate gameplay: tap to start, pump frames until game over (let bird fall)
   - Verify score saved
   - Recreate widget with same repository to simulate restart

4. **Run full test suite** at the end: `flutter test` — all tests pass (existing + new).

## File Paths
- `test/score_persistence_integration_test.dart` (new)

## Dependencies
- Task 13 (game_screen fully wired)
- Task 14 (test helpers exist)

## Test Plan
- `flutter test test/score_persistence_integration_test.dart` — all tests pass
- `flutter test` — full suite passes (no regressions)
