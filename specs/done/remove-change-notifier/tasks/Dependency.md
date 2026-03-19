# Task Dependencies — remove-change-notifier

```
Task 1: Strip ChangeNotifier from GameController
  │
  ├──▶ Task 2: Update GameScreen to use setState
  │
  └──▶ Task 3: Update tests
```

## Dependency Summary

| Task | Depends On | Reason |
|------|-----------|--------|
| 1 — Strip ChangeNotifier | None | Independent starting point |
| 2 — Update GameScreen | Task 1 | GameScreen must stop using ListenableBuilder after GameController drops ChangeNotifier |
| 3 — Update tests | Task 1 | Tests call dispose() which no longer exists after Task 1 |

## Execution Order
1. Task 1 first (breaks the build until Tasks 2 and 3 are done)
2. Tasks 2 and 3 can run in parallel after Task 1
