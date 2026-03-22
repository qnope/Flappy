# Task 9: Create IdlePhaseWidget

## Summary
Create a widget for the idle phase that shows the game layers, "Tap to start" text, and the leaderboard with last score (if any scores exist).

## Implementation Steps

1. **Create `lib/game/idle_phase_widget.dart`**

2. **Class `IdlePhaseWidget`** (StatelessWidget):
   - **Parameters**:
     - `double cloudsScrollOffset`
     - `double groundScrollOffset`
     - `List<Pipe> pipes`
     - `double birdPosY`
     - `Wing birdWing`
     - `double screenHeight`
     - `double screenWidth`
     - `int? lastScore` — last achieved score, null on first launch
     - `List<ScoreEntry> topScores` — top 10 scores for leaderboard
   - **Build**:
     - Use `GameLayersWidget` for base rendering (birdRotation = 0.0 for idle)
     - Overlays:
       - "Tap to start" text (Aligned at y=-0.5, same style as current)
       - If `lastScore` is not null: "Last Score: X" text above leaderboard
       - If `topScores` is not empty: `LeaderboardWidget(scores: topScores)` positioned below center
     - On first launch (no scores): only "Tap to start" shown (per US-3 acceptance criteria)

3. **Follow no-nested-construction rule.**

## File Paths
- `lib/game/idle_phase_widget.dart` (new)

## Dependencies
- Task 8 (GameLayersWidget)
- Task 6 (LeaderboardWidget)
- Task 2 (ScoreEntry model)

## Test Plan
- Tested in Task 15
