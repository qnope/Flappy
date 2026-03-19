# Assets Layer

## Overview

All visual assets are SVG files stored in `assets/images/` and declared in
`pubspec.yaml` under `flutter > assets`. The project uses exclusively SVG
(no raster images) loaded at runtime via the `flutter_svg` package with
`SvgPicture.asset('assets/images/<file>.svg')`.

## Asset Inventory

| File | ViewBox | Purpose |
|------|---------|---------|
| `background.svg` | 0 0 288 512 | Sky gradient (static, no clouds) |
| `clouds.svg` | 0 0 576 200 | Tileable clouds (transparent background) |
| `ground.svg` | 0 0 336 112 | Tileable ground strip with grass |
| `bird_up.svg` | 0 0 34 24 | Bird with wings raised |
| `bird_mid.svg` | 0 0 34 24 | Bird with wings horizontal |
| `bird_down.svg` | 0 0 34 24 | Bird with wings lowered |
| `pipe.svg` | 0 0 52 320 | Vertical pipe body (stretchable) |
| `pipe_top.svg` | 0 0 60 26 | Pipe cap (flipped for bottom) |

**Color palette:** sky blues (#87CEEB), bird yellows (#FFC107), ground
browns (#6D4C41), pipe greens (#388E3C). Cartoon style with rounded shapes.

## Composition

### Bird Animation

Three frames cycle in order: `bird_up` -> `bird_mid` -> `bird_down` ->
`bird_mid` (repeat). All three share the same 34x24 viewBox so swapping
frames requires no layout change.

### Pipe Assembly

A single pipe obstacle is composed of three parts stacked vertically:

1. `pipe_top.svg` -- cap on top of the upper pipe
2. `pipe.svg` -- stretched body filling the gap to screen edge
3. `pipe_top.svg` flipped vertically -- cap on top of the lower pipe

The body (`pipe.svg`) is stretched to the required height; the cap keeps its
fixed 60x26 size.

### Parallax Scrolling

Both `ground.svg` and `clouds.svg` are designed for seamless horizontal
tiling. `ScrollingLayerWidget` renders two adjacent copies and translates
them leftward, wrapping via modulo to create infinite scrolling.

Parallax depth is achieved through different scroll speeds:
- **Ground:** 120 px/s (foreground, fastest)
- **Clouds:** 30 px/s (mid-ground, slowest)
- **Background:** static sky (no scrolling)

## Adding a New Asset

1. Create an SVG file in `assets/images/`.
2. Keep the cartoon style and matching color palette.
3. Use a meaningful `viewBox` (no fixed `width`/`height` attributes) so
   Flutter can scale it freely.
4. The directory `assets/images/` is already declared in `pubspec.yaml`,
   so no pubspec change is needed.
5. Load it in code: `SvgPicture.asset('assets/images/<name>.svg')`.
6. Add a corresponding rendering test in `test/asset_rendering_test.dart`.
