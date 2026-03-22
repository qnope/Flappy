# Task 13: Refactor game_screen.dart to Phase Switcher + Wire Score Persistence

## Summary
Replace the monolithic build method in `game_screen.dart` with a phase switcher that delegates to the appropriate phase widget. Wire score saving: when transitioning to gameOver, save the score via ScoreRepository.

## Implementation Steps

1. **Edit `lib/game/game_screen.dart`**

2. **State changes**:
   - Add fields:
     - `List<ScoreEntry> _topScores = []`
     - `int? _lastScore`
     - `bool _isNewHighScore = false`
     - `int? _highlightIndex`
     - `GamePhase? _previousPhase` — to detect gameOver transition
   - In `initState` or after initialization, load scores from repository:
     - `_topScores = widget.scoreRepository.getTopScores()`
     - `_lastScore = widget.scoreRepository.getLastScore()?.score`

3. **Score saving logic** in `_onTick` or `setState`:
   - After `_controller.update(dt)`, check if phase just changed to `gameOver`:
     ```dart
     if (_controller.gamePhase == GamePhase.gameOver && _previousPhase != GamePhase.gameOver) {
       _isNewHighScore = widget.scoreRepository.isNewHighScore(_controller.score);
       await widget.scoreRepository.addScore(_controller.score, DateTime.now());
       _topScores = widget.scoreRepository.getTopScores();
       _highlightIndex = _isNewHighScore ? _findHighlightIndex(_controller.score) : null;
       _lastScore = _controller.score;
     }
     _previousPhase = _controller.gamePhase;
     ```

4. **Refactor `build` method** to phase switcher:
   - Compute `screenWidth`, `screenHeight`, `groundTopY` via LayoutBuilder (same as current)
   - Initialize controller if needed (same as current)
   - Extract common data: scroll offsets, pipes, bird position/wing/rotation
   - Switch on `_controller.gamePhase`:
     - `GamePhase.idle` → `IdlePhaseWidget(...)`
     - `GamePhase.playing` → `PlayingPhaseWidget(...)`
     - `GamePhase.dying` → `DyingPhaseWidget(...)`
     - `GamePhase.gameOver` → `GameOverPhaseWidget(...)`
   - Wrap in `GestureDetector(onTap: _onTap)` (same as current)

5. **Remove** all the inline overlay/score/tap-text logic from the current build method.

6. **When transitioning from gameOver to idle** (tap to restart):
   - Reset `_isNewHighScore = false` and `_highlightIndex = null`

## File Paths
- `lib/game/game_screen.dart` (edit — major refactor)

## Dependencies
- Task 4 (Hive initialized, ScoreRepository passed to GameScreen)
- Task 9 (IdlePhaseWidget)
- Task 10 (PlayingPhaseWidget)
- Task 11 (DyingPhaseWidget)
- Task 12 (GameOverPhaseWidget)

## Test Plan
- App runs and all 4 phases display correctly
- Score saves on game over
- Leaderboard shown on idle and gameOver screens
- Verified in Tasks 14-16
