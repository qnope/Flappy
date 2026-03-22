# Task 12: Create GameOverPhaseWidget

## Summary
Create a widget for the gameOver phase showing the game layers, a dark overlay with "Game Over", the current score, the full leaderboard, a "New High Score!" indicator if applicable, and "Tap to restart".

## Implementation Steps

1. **Create `lib/game/game_over_phase_widget.dart`**

2. **Class `GameOverPhaseWidget`** (StatelessWidget):
   - **Parameters**:
     - `double cloudsScrollOffset`
     - `double groundScrollOffset`
     - `List<Pipe> pipes`
     - `double birdPosY`
     - `Wing birdWing`
     - `double birdRotation`
     - `double screenHeight`
     - `double screenWidth`
     - `int score` — the score just achieved
     - `List<ScoreEntry> topScores` — top 10 for leaderboard
     - `bool isNewHighScore` — whether to show "New High Score!" indicator
     - `int? highlightIndex` — which leaderboard row to highlight (null if not in top 10)
   - **Build**:
     - Use `GameLayersWidget` for base rendering
     - Overlay: full-screen semi-transparent dark background (Colors.black54)
     - Content (centered Column):
       - "Game Over" text (fontSize 48, bold, white, shadow)
       - Current score prominently: "Score: X" (fontSize 32)
       - If `isNewHighScore`: "New High Score!" text (golden color)
       - `LeaderboardWidget(scores: topScores, highlightIndex: highlightIndex)`
       - "Tap to restart" (fontSize 20, white70)
     - The overlay should be wrapped in `AnimatedOpacity` for fade-in (500ms, same as current)

3. **Follow no-nested-construction rule.**

## File Paths
- `lib/game/game_over_phase_widget.dart` (new)

## Dependencies
- Task 8 (GameLayersWidget)
- Task 6 (LeaderboardWidget)
- Task 2 (ScoreEntry model)

## Test Plan
- Tested in Task 15
