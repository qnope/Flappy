# High Score Persistence - Feature Specification

## 1. Feature Overview

Keep track of the top 10 high scores with dates, display them on the Game Over and Ready (idle) screens, and persist them to local storage so they survive app restarts. As part of this work, refactor `game_screen.dart` by extracting each game phase (idle, playing, dying, gameOver) into its own dedicated widget, simplifying the main game screen to a phase switcher.

## 2. User Stories

### US-1: Score is saved after each game
- **As a** player
- **I want** my score to be automatically saved when the game ends
- **So that** I can track my performance over time
- **Acceptance criteria:**
  - When the game transitions to the `gameOver` phase, the current score and date/time are persisted
  - The top 10 scores are retained; lower scores are discarded
  - Scores persist across app restarts (on Chrome, iOS, and Android)

### US-2: Game Over screen shows current score and full leaderboard
- **As a** player
- **I want** to see my current score and the top 10 leaderboard when the game ends
- **So that** I know how I performed relative to my best games
- **Acceptance criteria:**
  - The Game Over overlay displays the score just achieved prominently
  - Below the current score, the full top 10 leaderboard is shown (rank, score, date)
  - If the current score is a new high score (entered the top 10), a "New High Score!" indicator is displayed
  - Tap to restart remains available

### US-3: Ready screen shows last score and leaderboard
- **As a** player
- **I want** to see my last score and the top 10 leaderboard on the ready screen
- **So that** I can see my history before starting a new game
- **Acceptance criteria:**
  - The idle/ready screen displays the last achieved score (if any)
  - The top 10 leaderboard is shown (rank, score, date)
  - "Tap to start" prompt remains visible
  - On first launch with no scores, only "Tap to start" is shown (no empty leaderboard)

### US-4: Phase widgets simplify game_screen
- **As a** developer
- **I want** each game phase to have its own dedicated widget
- **So that** `game_screen.dart` is simpler and each phase's UI is self-contained
- **Acceptance criteria:**
  - A dedicated widget exists for each phase: idle, playing, dying, gameOver
  - Each widget owns its full rendering stack (background, clouds, pipes, bird, ground, overlays)
  - `game_screen.dart` acts as a phase switcher, delegating rendering to the appropriate phase widget
  - Shared visual elements (background, bird, pipes, ground, clouds) are reused across phase widgets via composition

### US-5: Persistence uses Hive (with web support)
- **As a** player on any platform
- **I want** my scores to persist reliably
- **So that** I can see them again on Chrome, iOS, and Android
- **Acceptance criteria:**
  - Scores are stored using Hive (which supports web, iOS, and Android)
  - If Hive web support proves problematic, fall back to SharedPreferences
  - Storage is initialized before the game starts
  - Corrupted or missing storage is handled gracefully (start fresh)

## 3. Testing and Validation

- **Unit tests:** Score persistence logic (add score, maintain top 10, sort order, date storage, graceful handling of corrupted data)
- **Unit tests:** Leaderboard display logic (correct ranking, "New High Score!" detection, empty state handling)
- **Widget tests:** Each phase widget renders correctly with appropriate content
- **Widget tests:** Game Over screen shows current score, leaderboard, and new high score indicator when applicable
- **Widget tests:** Ready screen shows last score and leaderboard, or just "Tap to start" when no scores exist
- **Integration tests:** Score survives simulated app restart
- **Cross-platform:** Manual verification on Chrome, iOS, and Android
