# Task Dependencies — simplify-game-screen

```
Task 1: Wing Enum + GameAssets
  ↓
  ├──→ Task 2: BackgroundWidget
  ├──→ Task 3: GroundWidget
  └──→ Task 4: Bird Entity
           ↓
         Task 5: GameController
           ↓
         Task 6: Simplified GameScreen  (also depends on Tasks 2, 3)
           ↓
         Task 7: Update Tests & Cleanup
```

## Summary

| Task | Depends On | Can Parallelize With |
|------|-----------|---------------------|
| 1. Wing Enum + GameAssets | — | — |
| 2. BackgroundWidget | 1 | 3, 4 |
| 3. GroundWidget | 1 | 2, 4 |
| 4. Bird Entity | 1 | 2, 3 |
| 5. GameController | 1, 4 | — |
| 6. Simplified GameScreen | 1, 2, 3, 4, 5 | — |
| 7. Update Tests & Cleanup | 1–6 | — |

Tasks 2, 3, and 4 can be done in parallel after Task 1 completes.
