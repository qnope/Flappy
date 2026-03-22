# Task 2: Create ScoreEntry Model with Hive TypeAdapter

## Summary
Create a `ScoreEntry` data class that stores a score (int) and a date (DateTime). Annotate it for Hive code generation.

## Implementation Steps

1. **Create `lib/game/score_entry.dart`**
   - Class `ScoreEntry` with two fields:
     - `int score`
     - `DateTime date`
   - Annotate with `@HiveType(typeId: 0)`
   - Annotate fields with `@HiveField(0)` and `@HiveField(1)`
   - Add a constructor: `ScoreEntry({required this.score, required this.date})`

2. **Run code generation**:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```
   This generates `score_entry.g.dart` with the `ScoreEntryAdapter`.

3. **Verify** generated adapter file exists and has no analyzer errors.

## File Paths
- `lib/game/score_entry.dart` (new)
- `lib/game/score_entry.g.dart` (generated)

## Dependencies
- Task 1 (Hive dependencies must be installed)

## Test Plan
- `dart run build_runner build` completes successfully
- `flutter analyze` passes
- Generated adapter contains `ScoreEntryAdapter` class
