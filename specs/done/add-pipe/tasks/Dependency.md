# Add Pipe — Task Dependencies

## Dependency Graph

```
Task 1: Add Pipe Constants
  └─► Task 2: Create Pipe Model
        └─► Task 3: Create PipePool
              └─► Task 4: Integrate into GameController
                    └─► Task 6: Integrate into GameScreen
              └─► Task 5: Create PipeWidget
                    └─► Task 6: Integrate into GameScreen
```

## Summary

| Task | Depends On | Blocks |
|------|-----------|--------|
| 1 — Add Pipe Constants | — | 2, 3, 4, 5, 6 |
| 2 — Create Pipe Model | 1 | 3, 4 |
| 3 — Create PipePool | 1, 2 | 4, 6 |
| 4 — Integrate into GameController | 1, 2, 3 | 6 |
| 5 — Create PipeWidget | 1 | 6 |
| 6 — Integrate into GameScreen | 1, 2, 3, 4, 5 | — |

## Parallel Opportunities

- **Tasks 4 and 5** can be developed in parallel after task 3 completes (they are independent of each other).
- All other tasks are strictly sequential.

## Execution Order

1. Task 1 → 2. Task 2 → 3. Task 3 → 4. Tasks 4 & 5 (parallel) → 5. Task 6
