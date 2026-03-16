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
│  main.dart ──▶ AssetPreviewScreen       │
│  MaterialApp     (displays all sprites) │
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
│  asset_existence_test.dart              │
│    - SVG file existence                 │
│    - SVG validity (root element,        │
│      viewBox attribute)                 │
│                                         │
│  asset_rendering_test.dart              │
│    - Widget rendering per asset         │
│    - Bird frame dimension consistency   │
│    - Pipe assembly and flip behavior    │
└─────────────────────────────────────────┘
```

## Component Details

| Layer | Path | Description |
|-------|------|-------------|
| App | `lib/main.dart` | Entry point. Creates `MaterialApp` with theme and home screen. |
| App | `lib/asset_preview_screen.dart` | Scrollable screen previewing all 7 SVG sprites. |
| Assets | `assets/images/` | 7 SVG game sprites registered in `pubspec.yaml`. |
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

- [App Layer](app/README.md) -- widgets and screens in `lib/`
- [Assets Layer](assets/README.md) -- SVG sprites in `assets/images/`
- [Tests](tests/README.md) -- unit and widget test coverage
