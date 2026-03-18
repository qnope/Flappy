# Task Dependencies

## Dependency Graph

```
Task 01 (Constants + Physics) ──┬──> Task 02 (Physics Tests)
                                ├──> Task 04 (Bird Widget)
                                ├──> Task 05 (Game Loop)
                                └──> Task 10 (Ground Collision)

Task 03 (GameScreen Scaffold) ──┬──> Task 04 (Bird Widget)
                                ├──> Task 05 (Game Loop)
                                └──> Task 10 (Ground Collision)

Task 04 (Bird Widget) ──────────┬──> Task 05 (Game Loop)
                                ├──> Task 08 (Wing Animation)
                                └──> Task 09 (Bird Rotation)

Task 05 (Game Loop) ────────────┬──> Task 06 (Idle State)
                                ├──> Task 07 (Tap Input)
                                ├──> Task 08 (Wing Animation)
                                ├──> Task 09 (Bird Rotation)
                                └──> Task 10 (Ground Collision)

Task 06 (Idle State) ───────────┬──> Task 07 (Tap Input)

Task 07 (Tap Input) ────────────┘

Tasks 01-10 ────────────────────┬──> Task 11 (Widget Tests)
Task 11 ────────────────────────┬──> Task 12 (Integration Tests)
```

## Execution Order

Tasks can be executed in this recommended order (respecting dependencies):

| Phase | Tasks | Can Parallelize? |
|-------|-------|-----------------|
| 1     | Task 01, Task 03 | Yes — independent foundations |
| 2     | Task 02, Task 04 | Yes — tests + widget are independent |
| 3     | Task 05 | No — needs 01, 03, 04 |
| 4     | Task 06 | No — needs 05 |
| 5     | Task 07, Task 08, Task 09, Task 10 | Partially — 07 needs 06; 08/09/10 only need 05 |
| 6     | Task 11 | No — needs all implementation |
| 7     | Task 12 | No — needs 11 |

## Summary

- **12 tasks** total
- **7 phases** of execution
- **Critical path**: 01 → 04 → 05 → 06 → 07 → 11 → 12
- **Parallelizable pairs**: (01, 03), (02, 04), (08, 09, 10)
