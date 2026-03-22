# Task 3: Create ScoreRepository

## Summary
Create a `ScoreRepository` class that uses Hive to persist and retrieve the top 10 scores. It manages a single Hive box and exposes simple CRUD operations.

## Implementation Steps

1. **Create `lib/game/score_repository.dart`**

2. **Class `ScoreRepository`**:
   - Field: `Box<ScoreEntry> _box` (injected or opened internally)
   - **Constructor**: `ScoreRepository(this._box)` — takes an already-opened box for testability
   - **`Future<void> addScore(int score, DateTime date)`**:
     - Create a `ScoreEntry(score: score, date: date)`
     - Add to box
     - If box length > 10, remove the lowest-scoring entries to keep only top 10
     - Sort by score descending, then by date descending for ties
   - **`List<ScoreEntry> getTopScores()`**:
     - Read all entries from box
     - Sort by score descending (date descending for ties)
     - Return up to 10 entries
   - **`ScoreEntry? getLastScore()`**:
     - Return the most recently added score (by date), or null if empty
   - **`bool isNewHighScore(int score)`**:
     - Return true if score would enter the top 10 (fewer than 10 entries, or score > lowest in top 10)
   - **`Future<void> clear()`**:
     - Clear all entries from the box

3. **Static factory** for production use:
   ```dart
   static Future<ScoreRepository> create() async {
     final box = await Hive.openBox<ScoreEntry>('scores');
     return ScoreRepository(box);
   }
   ```

## File Paths
- `lib/game/score_repository.dart` (new)

## Dependencies
- Task 2 (ScoreEntry model must exist)

## Test Plan
- Tested in Task 5
