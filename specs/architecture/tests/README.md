# Test Architecture

## Overview

Tests are organized in three tiers: unit tests for pure logic, widget tests
for rendering and interaction, and integration tests for full game flows. No
mocking is used; tests operate on actual assets and the real Flutter renderer.

## Test Files

### `test/bird_physics_test.dart` (Unit)

Tests `BirdPhysics` as a plain Dart class, no Flutter needed.

| Group | What is verified |
|---|---|
| **Gravity** | Velocity increases and position moves downward per frame |
| **Jump** | Velocity resets to fixed upward value |
| **Ground collision** | Position clamped, velocity zeroed on contact |
| **Initial state** | Position and velocity match constructor args |

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
flutter test                                  # all tests
flutter test test/bird_physics_test.dart      # unit only
flutter test test/game_screen_test.dart       # widget only
flutter test test/game_flow_integration_test.dart  # integration only
```
