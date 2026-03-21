# Collide, Game Over & Scoring — Task Dependencies

## Dependency Graph

```
Task 1: Extend GamePhase + Pipe scored
  └─► Task 2: Collision detection in GameController
        └─► Task 3: Score tracking in GameController
              └─► Task 4: Game Over reset in GameController
                    └─► Task 5: Score display in GameScreen
                          └─► Task 6: Game Over overlay in GameScreen
                                └─► Task 7: Update existing tests
```

## Summary

| Task | Depends On | Blocks |
|------|-----------|--------|
| 1 — Extend GamePhase + Pipe scored | — | 2, 3 |
| 2 — Collision detection in GameController | 1 | 3, 4 |
| 3 — Score tracking in GameController | 1, 2 | 4, 5 |
| 4 — Game Over reset in GameController | 2, 3 | 6 |
| 5 — Score display in GameScreen | 2, 3 | 7 |
| 6 — Game Over overlay in GameScreen | 4, 5 | 7 |
| 7 — Update existing tests | 1–6 | — |

## Parallel Opportunities

- **Tasks 4 and 5** can be developed in parallel after tasks 2 and 3 are complete (Task 4 is backend reset logic, Task 5 is UI score display — they are independent of each other).
- All other tasks are sequential.

## Execution Order

1. Task 1 → 2. Task 2 → 3. Task 3 → 4. Tasks 4 & 5 (parallel) → 5. Task 6 → 6. Task 7
