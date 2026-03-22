# Task 5: Unit Tests for ScoreRepository

## Summary
Write unit tests for ScoreRepository covering add, top 10 maintenance, sort order, new high score detection, last score retrieval, and graceful handling of edge cases.

## Implementation Steps

1. **Create `test/score_repository_test.dart`**

2. **Test setup**:
   - Use `Hive.init()` with a temporary directory for each test
   - Register `ScoreEntryAdapter` in `setUpAll`
   - Open a fresh box per test, close and delete after each test

3. **Test cases**:

   | Group | Test | What is verified |
   |-------|------|------------------|
   | **addScore** | Add single score | Entry stored with correct score and date |
   | **addScore** | Add 12 scores | Only top 10 retained after pruning |
   | **getTopScores** | Empty box | Returns empty list |
   | **getTopScores** | Multiple scores | Returns sorted descending by score |
   | **getTopScores** | Tie-breaking | Same-score entries sorted by date descending |
   | **getLastScore** | Empty box | Returns null |
   | **getLastScore** | Multiple scores | Returns most recently dated entry |
   | **isNewHighScore** | Fewer than 10 entries | Always returns true |
   | **isNewHighScore** | 10 entries, score higher than lowest | Returns true |
   | **isNewHighScore** | 10 entries, score equal to lowest | Returns false |
   | **isNewHighScore** | 10 entries, score lower than lowest | Returns false |
   | **clear** | Clear with entries | Box is empty after clear |

## File Paths
- `test/score_repository_test.dart` (new)

## Dependencies
- Task 3 (ScoreRepository must exist)
- Task 2 (ScoreEntry model must exist)

## Test Plan
- `flutter test test/score_repository_test.dart` — all tests pass
