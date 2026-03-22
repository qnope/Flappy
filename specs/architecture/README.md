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
│  MaterialApp     (Hive init + routing)  │
└──────────────────┬──────────────────────┘
                   │
┌──────────────────▼──────────────────────┐
│          Game Layer (lib/game/)          │
│                                         │
│  game_screen.dart      (phase switcher) │
│  game_controller.dart  (game logic)     │
│  game_layers_widget.dart (shared stack) │
│  idle_phase_widget.dart    (idle UI)    │
│  playing_phase_widget.dart (play UI)    │
│  dying_phase_widget.dart   (dying UI)   │
│  game_over_phase_widget.dart (GO UI)    │
│  leaderboard_widget.dart (top 10 list)  │
│  score_repository.dart (Hive CRUD)      │
│  score_entry.dart      (Hive model)     │
│  bird.dart / bird_widget.dart           │
│  pipe.dart / pipe_pool.dart             │
│  pipe_widget.dart                       │
│  background_widget.dart                 │
│  ground_widget.dart / clouds_widget.dart│
│  scrolling_layer_widget.dart            │
│  wing.dart / game_assets.dart           │
│  game_constants.dart / game_state.dart  │
└──────────────────┬──────────────────────┘
                   │ loads via flutter_svg
┌──────────────────▼──────────────────────┐
│         Assets Layer (assets/images/)   │
│                                         │
│  background.svg   ground.svg            │
│  clouds.svg                             │
│  bird_up.svg  bird_mid.svg  bird_down.svg│
│  pipe.svg     pipe_top.svg              │
└─────────────────────────────────────────┘

┌─────────────────────────────────────────┐
│              Tests (test/)              │
│                                         │
│  wing_test / bird_test / pipe_test      │
│  pipe_pool_test / game_controller_test  │
│  score_repository_test  (unit tests)    │
│  pipe_widget_test / background_widget.. │
│  ground_widget_test / clouds_widget..   │
│  scrolling_layer_widget_test            │
│  game_layers_widget_test                │
│  idle_phase_widget_test                 │
│  playing_phase_widget_test              │
│  dying_phase_widget_test                │
│  game_over_phase_widget_test            │
│  leaderboard_widget_test  (widget)      │
│  game_screen_test         (widget)      │
│  game_flow_integration_test             │
│  score_persistence_integration_test     │
│  asset_existence / asset_rendering      │
└─────────────────────────────────────────┘
```

## Component Details

| Layer | Path | Description |
|-------|------|-------------|
| App | `lib/main.dart` | Entry point. Initializes Hive, creates `ScoreRepository`, launches `GameScreen`. |
| App | `lib/asset_preview_screen.dart` | Scrollable screen previewing all 7 SVG sprites. |
| Game | `lib/game/game_screen.dart` | Phase switcher: Ticker, LayoutBuilder, delegates to phase widgets. |
| Game | `lib/game/game_controller.dart` | Plain Dart class owning all game logic and state. |
| Game | `lib/game/game_layers_widget.dart` | Shared visual stack (background, clouds, pipes, bird, ground + overlays). |
| Game | `lib/game/idle_phase_widget.dart` | Idle phase: "Tap to start", last score, leaderboard. |
| Game | `lib/game/playing_phase_widget.dart` | Playing phase: live score display. |
| Game | `lib/game/dying_phase_widget.dart` | Dying phase: score display, bird falling. |
| Game | `lib/game/game_over_phase_widget.dart` | Game over: final score, leaderboard, new high score indicator. |
| Game | `lib/game/leaderboard_widget.dart` | Top 10 scores table with rank, score, date, and highlight. |
| Game | `lib/game/score_repository.dart` | Hive-backed CRUD for top 10 scores. |
| Game | `lib/game/score_entry.dart` | Hive `@HiveType` model: score + date. |
| Game | `lib/game/bird.dart` | Bird entity: vertical position, physics, wing state, rotation. |
| Game | `lib/game/bird_widget.dart` | Stateless SVG bird renderer with rotation. |
| Game | `lib/game/pipe.dart` | Pipe data model: position, gap center, gap size, computed edges. |
| Game | `lib/game/pipe_pool.dart` | Fixed-size pool of pipes with recycling and random gap generation. |
| Game | `lib/game/pipe_widget.dart` | Stateless SVG pipe pair renderer (top pipe + bottom pipe). |
| Game | `lib/game/background_widget.dart` | Stateless background SVG renderer. |
| Game | `lib/game/ground_widget.dart` | Scrolling ground layer using ScrollingLayerWidget. |
| Game | `lib/game/clouds_widget.dart` | Scrolling clouds layer using ScrollingLayerWidget. |
| Game | `lib/game/scrolling_layer_widget.dart` | Reusable infinite horizontal scrolling widget. |
| Game | `lib/game/wing.dart` | `Wing` enum with asset paths and animation sequence. |
| Game | `lib/game/game_assets.dart` | Centralized SVG asset path constants. |
| Game | `lib/game/game_constants.dart` | Physics, dimensions, and animation tuning values. |
| Game | `lib/game/game_state.dart` | `GamePhase` enum: `idle`, `playing`, `dying`, `gameOver`. |
| Assets | `assets/images/` | 8 SVG game sprites registered in `pubspec.yaml`. |

## Key Dependencies

- **Flutter SDK** ^3.11.0
- **flutter_svg** ^2.2.4 -- renders SVG assets as widgets
- **hive** ^2.2.3 / **hive_flutter** ^1.1.0 -- local key-value storage for scores
- **hive_generator** / **build_runner** (dev) -- code generation for Hive TypeAdapters

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
