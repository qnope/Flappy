# Task 7: Widget Tests for LeaderboardWidget

## Summary
Write widget tests verifying LeaderboardWidget renders correctly in all states.

## Implementation Steps

1. **Create `test/leaderboard_widget_test.dart`**

2. **Test cases**:

   | Group | Test | What is verified |
   |-------|------|------------------|
   | **Empty state** | Empty scores list | Renders empty SizedBox, no text visible |
   | **Single score** | One entry | Shows rank #1, score, and date |
   | **Multiple scores** | 5 entries | All 5 rows shown with correct ranking |
   | **Full leaderboard** | 10 entries | All 10 rows rendered |
   | **Sort order** | Scores in descending order | Rank #1 has highest score |
   | **Date format** | Date displayed | Shows dd/MM/yyyy format |
   | **New high score** | highlightIndex = 0 | "New High Score!" text is visible |
   | **No highlight** | highlightIndex = null | "New High Score!" text not present |
   | **Highlight style** | highlightIndex = 2 | Highlighted row has distinct style |

3. **Test setup**: Wrap widget in `MaterialApp` for theme/directionality.

## File Paths
- `test/leaderboard_widget_test.dart` (new)

## Dependencies
- Task 6 (LeaderboardWidget must exist)

## Test Plan
- `flutter test test/leaderboard_widget_test.dart` — all tests pass
