# Dependency Graph — add_images

## Task List

| # | Task | Depends On |
|---|------|------------|
| 01 | Initialize Flutter Project | — |
| 02 | Create Background SVG | 01 |
| 03 | Create Ground SVG | 01 |
| 04 | Create Bird SVGs (3 frames) | 01 |
| 05 | Create Pipe SVGs | 01 |
| 06 | Create Asset Preview Screen | 01, 02, 03, 04, 05 |
| 07 | Write Tests | 01, 02, 03, 04, 05 |

## Execution Order

```
Task 01 (Initialize Flutter Project)
   │
   ├──▶ Task 02 (Background SVG)  ──┐
   ├──▶ Task 03 (Ground SVG)      ──┤
   ├──▶ Task 04 (Bird SVGs)       ──┼──▶ Task 06 (Preview Screen)
   └──▶ Task 05 (Pipe SVGs)       ──┤
                                     └──▶ Task 07 (Tests)
```

## Parallelization

- **Wave 1**: Task 01 (sequential, must complete first)
- **Wave 2**: Tasks 02, 03, 04, 05 (all parallelizable)
- **Wave 3**: Tasks 06, 07 (parallelizable, after wave 2 completes)
