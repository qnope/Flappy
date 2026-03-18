# Test Architecture

## Overview

Tests are organized in three tiers: unit tests for pure logic, widget tests
for rendering and interaction, and integration tests for full game flows. No
mocking is used; tests operate on actual assets and the real Flutter renderer.

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
| **Initial state** | Phase is idle, bird centered |
| **Idle bobbing** | Bird oscillates vertically over time |
| **Tap to start** | Phase transitions from idle to playing |
| **Playing physics** | Gravity applied, jump on tap |
| **Wing animation** | Sprite cycles during idle and rising |

### `test/background_widget_test.dart` (Widget)

| Group | What is verified |
|---|---|
| **Rendering** | BackgroundWidget renders SvgPicture with correct asset |
| **Fit** | Uses BoxFit.cover to fill parent |

### `test/ground_widget_test.dart` (Widget)

| Group | What is verified |
|---|---|
| **Rendering** | GroundWidget renders SvgPicture with correct asset |
| **Fit** | Uses BoxFit.fitWidth to scale to width |

### `test/game_screen_test.dart` (Widget)

Tests `GameScreen` via `tester.pumpWidget()` with real SVG rendering.

| Group | What is verified |
|---|---|
| **Rendering** | Background, ground, bird, and "Tap to start" text present |
| **Tap interaction** | First tap starts game (removes idle text) |
| **Wing animation** | Sprite changes over time when idle |
| **Bird rotation** | Rotation applied after tap and gravity |

### `test/game_flow_integration_test.dart` (Integration)

Tests the complete gameplay sequence end-to-end.

| Group | What is verified |
|---|---|
| **Full game flow** | Idle -> tap -> bird jumps -> gravity pulls down -> tap again |
| **Ground collision** | Bird stops at ground level after sustained fall |

### `test/asset_existence_test.dart` (Unit)

| Group | What is verified |
|---|---|
| **SVG existence** | All 7 SVG files exist in `assets/images/` |
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
flutter test test/bird_test.dart                    # unit only
flutter test test/game_controller_test.dart         # unit only
flutter test test/game_screen_test.dart             # widget only
flutter test test/game_flow_integration_test.dart   # integration only
```
