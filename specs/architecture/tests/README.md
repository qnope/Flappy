# Test Architecture

## Overview

All tests target the SVG image assets located in `assets/images/`. The suite
is split into two files: one for file-level validation (existence, structure)
and one for Flutter widget-level rendering. No mocking is used; tests operate
on the actual asset files and the real `flutter_svg` renderer.

## Test Files

### `test/asset_existence_test.dart`

Covers SVG files on disk without the Flutter widget layer.

| Group | Tests | What is verified |
|---|---|---|
| **SVG asset existence** | 7 (one per SVG) | File exists in `assets/images/` |
| **SVG validity** | 14 (2 per SVG) | Content is parseable XML with an `<svg>` root element; `viewBox` attribute is present and non-empty |

Tested assets: `background.svg`, `ground.svg`, `bird_up.svg`, `bird_mid.svg`,
`bird_down.svg`, `pipe.svg`, `pipe_top.svg`.

### `test/asset_rendering_test.dart`

Covers widget-level rendering via `tester.pumpWidget()` inside a `MaterialApp` /
`Scaffold` wrapper.

| Group | Tests | What is verified |
|---|---|---|
| **SVG rendering** | 7 (one per SVG) | Each SVG renders as an `SvgPicture` (100x100) without exceptions |
| **Bird frame consistency** | 1 | All 3 bird SVGs load at 50x50 in a `Column`; exactly 3 `SvgPicture` widgets are found with matching dimensions |
| **Pipe assembly** | 2 | Pipe body + pipe top render together in a `Column`; `pipe_top` can be flipped vertically via `Transform.flip(flipY: true)` |

## Running Tests

```bash
flutter test
```

To run a single file:

```bash
flutter test test/asset_existence_test.dart
flutter test test/asset_rendering_test.dart
```
