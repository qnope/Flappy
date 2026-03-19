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
│  game_screen.dart      (layout shell)   │
│  game_controller.dart  (game logic)     │
│  bird.dart             (entity model)   │
│  bird_widget.dart      (SVG renderer)   │
│  background_widget.dart (BG renderer)   │
│  ground_widget.dart    (ground render)  │
│  wing.dart             (wing enum)      │
│  game_assets.dart      (asset paths)    │
│  game_constants.dart   (tuning values)  │
│  game_state.dart       (idle / playing) │
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
│  wing_test.dart           (unit tests)  │
│  bird_test.dart           (unit tests)  │
│  game_controller_test.dart(unit tests)  │
│  background_widget_test.dart (widget)   │
│  ground_widget_test.dart  (widget)      │
│  game_screen_test.dart    (widget)      │
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
| Game | `lib/game/game_screen.dart` | Thin layout shell: Ticker, LayoutBuilder, widget tree. |
| Game | `lib/game/game_controller.dart` | ChangeNotifier owning all game logic and state. |
| Game | `lib/game/bird.dart` | Bird entity: vertical position, physics, wing state, rotation. |
| Game | `lib/game/bird_widget.dart` | Stateless SVG bird renderer with rotation. |
| Game | `lib/game/background_widget.dart` | Stateless background SVG renderer. |
| Game | `lib/game/ground_widget.dart` | Stateless ground SVG renderer. |
| Game | `lib/game/wing.dart` | `Wing` enum with asset paths and animation sequence. |
| Game | `lib/game/game_assets.dart` | Centralized SVG asset path constants. |
| Game | `lib/game/game_constants.dart` | Physics, dimensions, and animation tuning values. |
| Game | `lib/game/game_state.dart` | `GamePhase` enum: `idle` and `playing`. |
| Assets | `assets/images/` | 7 SVG game sprites registered in `pubspec.yaml`. |
| Tests | `test/wing_test.dart` | Unit tests for Wing enum and animation sequence. |
| Tests | `test/bird_test.dart` | Unit tests for Bird entity (physics, rotation, wing). |
| Tests | `test/game_controller_test.dart` | Unit tests for GameController logic. |
| Tests | `test/background_widget_test.dart` | Widget tests for BackgroundWidget. |
| Tests | `test/ground_widget_test.dart` | Widget tests for GroundWidget. |
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
