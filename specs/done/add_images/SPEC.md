# Add Images - API Specification

## 1. Feature Overview

Add all necessary SVG image assets for the Flappy Bird game. These images form the visual foundation of the game and must be hand-crafted SVG files in a cartoon style (rounded shapes, vivid colors, detailed).

All assets are stored in `assets/images/` and rendered at runtime using the `flutter_svg` package. The game targets Chrome, iOS, and Android.

### Asset List

| Asset | Filename | Description |
|-------|----------|-------------|
| Background | `background.svg` | Sky scene with clouds, gradient sky |
| Ground | `ground.svg` | Scrolling ground/floor strip |
| Bird (wings up) | `bird_up.svg` | Bird with wings raised |
| Bird (wings mid) | `bird_mid.svg` | Bird with wings at mid position |
| Bird (wings down) | `bird_down.svg` | Bird with wings lowered |
| Pipe body | `pipe.svg` | Vertical pipe body (stretchable) |
| Pipe top | `pipe_top.svg` | Pipe cap/embout — flipped vertically to serve as PipeBottom |

### Design Principles

- **Style**: Cartoon — rounded shapes, vivid colors, visible outlines.
- **Format**: SVG only (vector, resolution-independent across all targets).
- **Source**: Generated as SVG code (no external dependency).
- **Pipe symmetry**: `pipe_top.svg` is flipped vertically in code to create the bottom pipe cap. No separate PipeBottom asset needed.
- **Bird animation**: 3 frames cycled to simulate wing flapping (up → mid → down → mid → ...).

## 2. API Design

### User Stories

**US-1: Game displays background**
- As a player, I see a cartoon sky background behind all game elements.
- **Acceptance criteria**: `background.svg` fills the entire screen. It renders correctly on Chrome, iOS, and Android.

**US-2: Game displays scrolling ground**
- As a player, I see a ground strip at the bottom of the screen.
- **Acceptance criteria**: `ground.svg` is displayed at the bottom. It can be tiled horizontally for scrolling.

**US-3: Bird is displayed with wing animation**
- As a player, I see a bird that flaps its wings.
- **Acceptance criteria**: The bird cycles through `bird_up.svg`, `bird_mid.svg`, `bird_down.svg` to create a flapping animation. All 3 frames have consistent dimensions and the bird's body aligns across frames.

**US-4: Pipes are displayed as obstacles**
- As a player, I see vertical pipes as obstacles with caps on the opening end.
- **Acceptance criteria**: `pipe.svg` is the body, stretched vertically. `pipe_top.svg` is the cap on the opening side. The bottom pipe uses a vertically flipped `pipe_top.svg`. Pipe and cap widths match.

### File Organization

```
assets/
  images/
    background.svg
    ground.svg
    bird_up.svg
    bird_mid.svg
    bird_down.svg
    pipe.svg
    pipe_top.svg
```

### Flutter Integration

- Add `flutter_svg` dependency in `pubspec.yaml`.
- Declare `assets/images/` in `pubspec.yaml` under the `flutter.assets` section.
- Use `SvgPicture.asset('assets/images/<file>.svg')` to render each SVG.

## 3. Testing and Validation

### Visual Testing
- **Manual verification**: Each SVG renders correctly on Chrome, iOS simulator, and Android emulator.
- **Cross-platform consistency**: Colors, proportions, and alignment look consistent across platforms.

### Unit Tests
- **Asset existence**: Verify that all 7 SVG files exist in `assets/images/`.
- **SVG validity**: Each file is valid SVG (parseable XML with `<svg>` root element).

### Integration Tests
- **Rendering test**: A Flutter widget test loads each SVG via `flutter_svg` without errors.
- **Bird animation**: Verify the 3 bird frames can be cycled in sequence without visual glitches.
- **Pipe assembly**: Verify pipe body + pipe top render together correctly, and that flipping pipe_top produces a valid bottom cap.

### Success Criteria
- All 7 SVG files are present in `assets/images/`.
- All SVGs render without errors on all 3 target platforms.
- Bird frames have consistent dimensions.
- Pipe body and cap widths are aligned.
