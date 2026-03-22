# Test Architecture

## Overview

Tests are organized in three tiers: unit tests for pure logic, widget tests
for rendering and interaction, and integration tests for full game flows.
`ScoreRepository` tests use a temporary Hive directory for isolation.
A shared `test/test_helpers.dart` provides Hive setup utilities.

## Test Files

### `test/wing_test.dart` (Unit)

Tests the `Wing` enum and animation sequence.

| Group | What is verified |
|---|---|
| **Asset paths** | Each wing variant maps to the correct SVG path |
| **Animation sequence** | 4-frame cycle: up -> mid -> down -> mid |

### `test/bird_test.dart` (Unit)

Tests the `Bird` entity as a plain Dart class, no Flutter needed.

| Group | What is verified |
|---|---|
| **Gravity** | Velocity increases and position moves downward per frame |
| **Jump** | Velocity resets to fixed upward value |
| **Ground collision** | Position clamped, velocity zeroed on contact |
| **Rotation** | Proportional to velocity: nose up when rising, nose down when falling |
| **Wing state** | Current wing can be set and read |

### `test/game_controller_test.dart` (Unit)

Tests `GameController` logic without Flutter widgets.

| Group | What is verified |
|---|---|
| **Initial state** | Phase is idle, bird centered vertically |
| **Idle bobbing** | Bird oscillates vertically over time |
| **Tap to start** | Phase transitions from idle to playing |
| **Playing physics** | Gravity applied, jump on tap |
| **Scroll offsets** | Start at zero, update each frame, skip large dt, ground faster than clouds |
| **Wing animation** | Sprite cycles during idle and rising; freezes on dying/gameOver |
| **Pipe integration** | Pool created on init, pipes move at ground speed, reset on idle->playing, no reset on jump |
| **Collision detection** | Pipe and ground collisions transition to dying/gameOver phases |
| **Score tracking** | Score increments when bird passes pipe, uses scored flag to prevent duplicates |
| **Game over reset** | Tap during gameOver resets all state (phase, bird, score, pipes) to idle |

### `test/pipe_test.dart` (Unit)

Tests the `Pipe` data model.

| Group | What is verified |
|---|---|
| **Gap computations** | `gapTop` and `gapBottom` derived correctly from center and size |
| **Field storage** | Constructor stores posX, gapCenterY, gapSize |
| **Scored flag** | Defaults to false, can be set to true |

### `test/pipe_pool_test.dart` (Unit)

Tests `PipePool` with a seeded `Random(42)` for determinism.

| Group | What is verified |
|---|---|
| **Initialization** | Correct pipe count, spacing, and starting position |
| **Gap bounds** | Gap size within min/max, center within safe margins |
| **Update** | Pipes move left by given distance |
| **Recycling** | Off-screen pipes repositioned to right with new gaps and correct spacing |
| **Reset** | All pipes regenerated at initial layout positions |
| **Scored reset** | Scored flag cleared on pipe recycling and pool reset |

### `test/pipe_widget_test.dart` (Widget)

| Group | What is verified |
|---|---|
| **Rendering** | PipeWidget renders without error |
| **SVG assets** | Contains 4 SvgPicture widgets (top body, top cap, bottom cap, bottom body) |
| **Top pipe** | Positioned from Y=0 with correct height |
| **Bottom pipe** | Positioned at gapBottom extending to bottom |
| **Width** | Overall width equals pipeCapWidth (60px) |

### `test/background_widget_test.dart` (Widget)

| Group | What is verified |
|---|---|
| **Rendering** | BackgroundWidget renders SvgPicture with correct asset |
| **Fit** | Uses BoxFit.cover to fill parent |

### `test/ground_widget_test.dart` (Widget)

| Group | What is verified |
|---|---|
| **Rendering** | GroundWidget renders scrolling tiles with correct asset |
| **ScrollOffset** | Accepts scrollOffset parameter for horizontal scrolling |

### `test/clouds_widget_test.dart` (Widget)

| Group | What is verified |
|---|---|
| **Rendering** | CloudsWidget renders with scrollOffset without errors |
| **Composition** | Contains ScrollingLayerWidget with two SVG tiles |

### `test/scrolling_layer_widget_test.dart` (Widget)

| Group | What is verified |
|---|---|
| **Rendering** | Renders with valid SVG asset |
| **Tiling** | Renders two adjacent SVG tiles |
| **Clipping** | Uses UnconstrainedBox with Clip.hardEdge |
| **Scroll offset** | Renders correctly with non-zero offset |

### `test/score_repository_test.dart` (Unit)

Tests `ScoreRepository` with a temp Hive directory per test.

| Group | What is verified |
|---|---|
| **addScore** | Entries stored and retrievable |
| **Top 10 limit** | Excess entries pruned, keeping highest scores |
| **Sort order** | Scores sorted descending; ties broken by date |
| **getLastScore** | Returns most recent entry by date |
| **isNewHighScore** | True when score exceeds current #1, true when empty |
| **clear** | All entries removed |

### `test/leaderboard_widget_test.dart` (Widget)

| Group | What is verified |
|---|---|
| **Rendering** | Table with rank, score, and date columns |
| **Empty state** | Returns empty SizedBox when no scores |
| **Highlight** | Gold styling applied to highlighted index |
| **New High Score** | "New High Score!" banner shown when highlightIndex set |

### `test/game_layers_widget_test.dart` (Widget)

| Group | What is verified |
|---|---|
| **Rendering** | Background, clouds, bird, ground, and pipes present |
| **Overlays** | Custom overlay widgets rendered on top |

### `test/idle_phase_widget_test.dart` (Widget)

| Group | What is verified |
|---|---|
| **Rendering** | "Tap to start" text, last score, leaderboard |
| **Empty state** | No score section when no scores exist |

### `test/playing_phase_widget_test.dart` (Widget)

| Group | What is verified |
|---|---|
| **Rendering** | Live score counter displayed |

### `test/dying_phase_widget_test.dart` (Widget)

| Group | What is verified |
|---|---|
| **Rendering** | Score counter displayed (frozen) |

### `test/game_over_phase_widget_test.dart` (Widget)

| Group | What is verified |
|---|---|
| **Rendering** | Game over text, final score, leaderboard, restart hint |
| **New high score** | "New High Score!" indicator and highlight |

### `test/game_screen_test.dart` (Widget)

Tests `GameScreen` via `tester.pumpWidget()` with real SVG rendering.

| Group | What is verified |
|---|---|
| **Rendering** | Background, ground, clouds, bird, and "Tap to start" text present |
| **Tap interaction** | First tap starts game (removes idle text) |
| **Wing animation** | Sprite changes over time when idle |
| **Bird rotation** | Rotation applied after tap and gravity |
| **Pipes** | Pipe widgets present during idle and playing |
| **Score display** | Score visible during playing/dying |
| **Game over overlay** | Overlay with final score and restart hint shown on gameOver |

### `test/game_flow_integration_test.dart` (Integration)

Tests the complete gameplay sequence end-to-end.

| Group | What is verified |
|---|---|
| **Full game flow** | Idle → tap → bird jumps → gravity pulls down → tap again |
| **Ground collision** | Ground hit during playing triggers gameOver phase |
| **Full lifecycle** | idle → playing → dying → gameOver → idle (tap to restart) |
| **Score persistence** | Score maintained through dying phase, cleared on restart |

### `test/score_persistence_integration_test.dart` (Integration)

| Group | What is verified |
|---|---|
| **Persistence** | Scores survive simulated app restart (close + reopen Hive box) |

### `test/asset_existence_test.dart` (Unit)

| Group | What is verified |
|---|---|
| **SVG existence** | All 8 SVG files exist in `assets/images/` |
| **SVG validity** | Each file has `<svg>` root element and `viewBox` attribute |

### `test/asset_rendering_test.dart` (Widget)

| Group | What is verified |
|---|---|
| **SVG rendering** | Each SVG renders as `SvgPicture` without exceptions |
| **Bird consistency** | All 3 bird frames have matching dimensions |
| **Pipe assembly** | Pipe body + cap render; cap flips vertically |

## Running Tests

```bash
flutter test                                        # all tests
flutter test test/score_repository_test.dart        # unit only
flutter test test/leaderboard_widget_test.dart      # widget only
flutter test test/game_screen_test.dart             # widget only
flutter test test/game_flow_integration_test.dart   # integration only
```
