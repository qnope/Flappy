# Task 14: Update Existing Tests

## Summary
Update `game_screen_test.dart` and `game_flow_integration_test.dart` to work with the refactored GameScreen that now requires a ScoreRepository parameter.

## Implementation Steps

1. **Create a test helper** in `test/test_helpers.dart`:
   - Function to create a mock/in-memory ScoreRepository for tests:
     ```dart
     Future<ScoreRepository> createTestScoreRepository() async {
       Hive.init(Directory.systemTemp.createTempSync().path);
       if (!Hive.isAdapterRegistered(0)) {
         Hive.registerAdapter(ScoreEntryAdapter());
       }
       final box = await Hive.openBox<ScoreEntry>('test_scores_${DateTime.now().millisecondsSinceEpoch}');
       return ScoreRepository(box);
     }
     ```

2. **Edit `test/game_screen_test.dart`**:
   - Import test helper
   - In setUp, create test ScoreRepository
   - Pass `scoreRepository` to `GameScreen` constructor in all `pumpWidget` calls
   - Verify all existing tests still pass (rendering, tap interaction, wing animation, pipes, score display, game over overlay)

3. **Edit `test/game_flow_integration_test.dart`**:
   - Same changes: create test ScoreRepository and pass to GameScreen
   - Verify all existing tests still pass

4. **Run full test suite**: `flutter test` — all tests pass.

## File Paths
- `test/test_helpers.dart` (new)
- `test/game_screen_test.dart` (edit)
- `test/game_flow_integration_test.dart` (edit)

## Dependencies
- Task 13 (game_screen refactored with ScoreRepository param)

## Test Plan
- `flutter test` — all existing tests pass with no regressions
