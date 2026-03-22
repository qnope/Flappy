# Dependency Graph — highscore-persistence

## Overview

```
Phase 1: Persistence Foundation
  Task 1 (Hive deps)
    └─▶ Task 2 (ScoreEntry model)
         └─▶ Task 3 (ScoreRepository)
              ├─▶ Task 4 (Initialize Hive in main.dart)
              └─▶ Task 5 (ScoreRepository tests)

Phase 2: Leaderboard UI
  Task 2 (ScoreEntry model)
    └─▶ Task 6 (LeaderboardWidget)
         └─▶ Task 7 (LeaderboardWidget tests)

Phase 3: Phase Widget Extraction
  Task 8 (GameLayersWidget) ── no dependencies, can start anytime
    ├─▶ Task 9 (IdlePhaseWidget)      ── also needs Task 6
    ├─▶ Task 10 (PlayingPhaseWidget)
    ├─▶ Task 11 (DyingPhaseWidget)
    └─▶ Task 12 (GameOverPhaseWidget) ── also needs Task 6

Phase 4: Integration
  Tasks 4, 9, 10, 11, 12
    └─▶ Task 13 (Refactor game_screen + wire persistence)
         └─▶ Task 14 (Update existing tests)
         └─▶ Task 15 (Phase widget tests)
         └─▶ Task 16 (Score persistence integration test)
```

## Dependency Table

| Task | Depends On | Blocks |
|------|-----------|--------|
| 1. Add Hive dependencies | — | 2 |
| 2. ScoreEntry model | 1 | 3, 6 |
| 3. ScoreRepository | 2 | 4, 5 |
| 4. Initialize Hive in main.dart | 3 | 13 |
| 5. ScoreRepository tests | 3 | — |
| 6. LeaderboardWidget | 2 | 7, 9, 12 |
| 7. LeaderboardWidget tests | 6 | — |
| 8. GameLayersWidget | — | 9, 10, 11, 12 |
| 9. IdlePhaseWidget | 6, 8 | 13 |
| 10. PlayingPhaseWidget | 8 | 13 |
| 11. DyingPhaseWidget | 8 | 13 |
| 12. GameOverPhaseWidget | 6, 8 | 13 |
| 13. Refactor game_screen | 4, 9, 10, 11, 12 | 14, 15, 16 |
| 14. Update existing tests | 13 | — |
| 15. Phase widget tests | 8, 9, 10, 11, 12 | — |
| 16. Score persistence integration test | 13, 14 | — |

## Parallelism Opportunities

- **Tasks 5 and 4** can run in parallel (both depend only on Task 3)
- **Tasks 6 and 8** can run in parallel (Task 6 needs Task 2; Task 8 has no deps)
- **Tasks 7 and 9-12** can run in parallel once their deps are met
- **Tasks 10 and 11** can run in parallel (both depend only on Task 8)
- **Tasks 14, 15, and 16** can partially overlap

## Recommended Execution Order

1. Task 1 → Task 2 → Task 3 (sequential, each builds on previous)
2. Task 4 + Task 5 + Task 8 (parallel)
3. Task 6 (needs Task 2, likely ready by now)
4. Task 7 + Task 9 + Task 10 + Task 11 (parallel, once deps met)
5. Task 12 (needs Task 6 + Task 8)
6. Task 13 (needs Tasks 4, 9, 10, 11, 12)
7. Task 14 + Task 15 (parallel)
8. Task 16 (final integration)
