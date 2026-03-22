# Task 6: Create LeaderboardWidget

## Summary
Create a shared, reusable `LeaderboardWidget` that displays the top 10 scores with rank, score value, and date. Supports highlighting a "New High Score!" entry.

## Implementation Steps

1. **Create `lib/game/leaderboard_widget.dart`**

2. **Class `LeaderboardWidget`** (StatelessWidget):
   - **Parameters**:
     - `List<ScoreEntry> scores` — the top scores to display
     - `int? highlightIndex` — optional index to highlight as new high score (null = no highlight)
   - **Build**:
     - If `scores` is empty, return an empty `SizedBox`
     - For each score entry, build a row: `#rank  score  date`
     - Date formatted as `dd/MM/yyyy`
     - If `highlightIndex` is not null, show "New High Score!" text above the list
     - Highlighted row gets a distinct color (e.g., golden/yellow)
     - Text style: white with shadow for readability over game background
     - Follow no-nested-construction rule: declare each element as variable, compose

3. **Styling**:
   - Contained in a semi-transparent dark background container for readability
   - Compact layout suitable for overlay use
   - Fixed width (not full screen) centered horizontally

## File Paths
- `lib/game/leaderboard_widget.dart` (new)

## Dependencies
- Task 2 (ScoreEntry model)

## Test Plan
- Tested in Task 7
