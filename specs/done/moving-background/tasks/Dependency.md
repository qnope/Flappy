# Moving Background — Task Dependencies

## Dependency Graph

```
01 Create clouds.svg ─────────────────────────┐
                                               ├─▶ 07 Create CloudsWidget ──┐
02 Update background.svg ──▶ 08 Verify BackgroundWidget ──┐                 │
                                                           │                 │
03 Add assets & constants ──┬─▶ 04 Create ScrollingLayerWidget ─┬──┐        │
                            │                                    │  │        │
                            └─▶ 05 Add scroll offsets to ctrl ───┤  │        │
                                                                 │  │        │
                                        06 Update GroundWidget ◀─┘  │        │
                                                 │                  │        │
                                                 ▼                  ▼        ▼
                                          09 Update GameScreen ◀────────────┘
                                                 │
                            ┌────────────────────┼────────────────────┐
                            ▼                    ▼                    ▼
                   10 Unit tests        11 Widget tests       12 Update tests
                  (scroll offsets)   (ScrollingLayerWidget)   (existing + new)
```

## Parallel Execution Groups

Tasks within the same group can be executed in parallel.

| Order | Tasks | Description |
|-------|-------|-------------|
| 1 | 01, 02, 03 | Asset creation and constants — no interdependencies |
| 2 | 04, 05 | Scrolling widget + controller offsets — both depend on 03 only |
| 3 | 06, 07, 08 | Layer widgets — depend on 04/05 and assets |
| 4 | 09 | GameScreen composition — depends on all layer widgets |
| 5 | 10, 11, 12 | All tests — can run in parallel after their dependencies |

## Per-Task Dependencies

| Task | Depends On | Blocked By |
|------|-----------|------------|
| 01 Create clouds.svg | — | — |
| 02 Update background.svg | — | — |
| 03 Add assets & constants | — | — |
| 04 Create ScrollingLayerWidget | 03 | — |
| 05 Add scroll offsets to controller | 03 | — |
| 06 Update GroundWidget | 04 | — |
| 07 Create CloudsWidget | 01, 03, 04 | — |
| 08 Verify BackgroundWidget | 02 | — |
| 09 Update GameScreen | 05, 06, 07, 08 | — |
| 10 Unit tests (scroll offsets) | 05 | — |
| 11 Widget tests (ScrollingLayerWidget) | 04 | — |
| 12 Update existing tests | 06, 07, 08, 09 | — |
