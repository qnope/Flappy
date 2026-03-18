# Flappy - Architecture

## Overview

Flappy is a Flappy Bird-style game built with Flutter and Dart. It targets
Chrome, iOS, and Android. All image assets are SVG. The project is built
incrementally, feature by feature.

## Architecture Layers

```
┌─────────────────────────────────────────┐
│              App Layer (lib/)            │
│                                         │
│  main.dart ──▶ GameScreen               │
│  MaterialApp     (main gameplay screen) │
└──────────────────┬──────────────────────┘
                   │
┌──────────────────▼──────────────────────┐
│          Game Layer (lib/game/)          │
│                                         │
│  game_screen.dart   (60fps game loop)   │
│  bird_physics.dart  (gravity & jump)    │
│  bird_widget.dart   (SVG sprite render) │
│  game_constants.dart (tuning values)    │
│  game_state.dart    (idle / playing)    │
└──────────────────┬──────────────────────┘
                   │ loads via flutter_svg
┌──────────────────▼──────────────────────┐
│         Assets Layer (assets/images/)   │
│                                         │
│  background.svg   ground.svg            │
│  bird_up.svg  bird_mid.svg  bird_down.svg│
│  pipe.svg     pipe_top.svg              │
└─────────────────────────────────────────┘

┌─────────────────────────────────────────┐
│              Tests (test/)              │
│                                         │
│  bird_physics_test.dart (unit tests)    │
│  game_screen_test.dart  (widget tests)  │
│  game_flow_integration_test.dart        │
│  asset_existence_test.dart              │
│  asset_rendering_test.dart              │
└─────────────────────────────────────────┘
```

## Component Details

| Layer | Path | Description |
|-------|------|-------------|
| App | `lib/main.dart` | Entry point. Creates `MaterialApp` with `GameScreen` as home. |
| App | `lib/asset_preview_screen.dart` | Scrollable screen previewing all 7 SVG sprites. |
| Game | `lib/game/game_screen.dart` | Main gameplay screen with 60fps ticker-driven game loop. |
| Game | `lib/game/bird_physics.dart` | Bird physics model (gravity, jump, ground collision). |
| Game | `lib/game/bird_widget.dart` | Stateless SVG bird renderer with rotation. |
| Game | `lib/game/game_constants.dart` | Physics, dimensions, and animation tuning values. |
| Game | `lib/game/game_state.dart` | `GamePhase` enum: `idle` and `playing`. |
| Assets | `assets/images/` | 7 SVG game sprites registered in `pubspec.yaml`. |
| Tests | `test/bird_physics_test.dart` | Unit tests for gravity, jump, and ground collision. |
| Tests | `test/game_screen_test.dart` | Widget tests for rendering, interaction, and animation. |
| Tests | `test/game_flow_integration_test.dart` | Integration tests for full game flow. |
| Tests | `test/asset_existence_test.dart` | Unit tests for file existence and SVG validity. |
| Tests | `test/asset_rendering_test.dart` | Widget tests for rendering, dimensions, and transforms. |

## Key Dependencies

- **Flutter SDK** ^3.11.0
- **flutter_svg** ^2.2.4 -- renders SVG assets as widgets

## Design Principles

1. **No nested widget construction.** Widgets are declared as local variables
   and passed as arguments to parent widgets (see `asset_preview_screen.dart`).
2. **SVG-only images.** No raster graphics; every visual asset is an SVG file
   with a `viewBox` attribute.
3. **Incremental development.** Each feature is added as a self-contained step
   with its own tests and assets.
4. **Multi-platform.** The app targets Chrome, iOS, and Android from the same
   codebase.

## Subdirectory Documentation

- [App Layer](app/README.md) -- entry point and preview screen in `lib/`
- [Game Layer](game/README.md) -- game loop, physics, and bird rendering in `lib/game/`
- [Assets Layer](assets/README.md) -- SVG sprites in `assets/images/`
- [Tests](tests/README.md) -- unit, widget, and integration test coverage
