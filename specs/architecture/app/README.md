# App Layer (`lib/`)

## Overview

The app layer contains the Flutter widget code that bootstraps the application
and renders its screens. It currently has two files:

| File                      | Widget              | Type              |
|---------------------------|---------------------|-------------------|
| `main.dart`               | `MyApp`             | StatelessWidget   |
| `asset_preview_screen.dart` | `AssetPreviewScreen` | StatelessWidget |

## Widget Tree

```
MyApp (MaterialApp)
 └─ AssetPreviewScreen
     └─ Scaffold
         ├─ AppBar ("Asset Preview")
         └─ SingleChildScrollView
             └─ Column
                 ├─ backgroundSection   (full-width SvgPicture + label)
                 ├─ groundSection       (full-width SvgPicture + label)
                 ├─ birdSection         (title + Row of 3 labeled birds)
                 │   └─ Row [birdUp, birdMid, birdDown]  (each height: 60)
                 └─ pipeSection         (title + pipe assembly Column)
                     └─ Column [pipeTop, pipeBody, flipped pipeBottomCap]
```

## Entry Point (`main.dart`)

`MyApp` creates a `MaterialApp` with:

- **Title:** `'Flappy'`
- **Theme:** `ColorScheme.fromSeed(seedColor: Colors.deepPurple)`
- **Home:** `AssetPreviewScreen()`

## Screen: `AssetPreviewScreen`

Displays all 7 SVG assets from `assets/images/` in a scrollable layout.
Uses `flutter_svg`'s `SvgPicture.asset()` for rendering.

Layout sections top-to-bottom:

1. **Background** -- full-width (`BoxFit.fitWidth`) with label.
2. **Ground** -- full-width (`BoxFit.fitWidth`) with label.
3. **Bird frames** -- three sprites side-by-side in a `Row`
   (`bird_up`, `bird_mid`, `bird_down`), each at height 60.
4. **Pipe assembly** -- vertical stack: top cap (width 60), body
   (width 60, height 150, `BoxFit.fill`), and bottom cap produced by
   `Transform.flip(flipY: true)` on the top cap asset.

## No-Nested-Construction Pattern

Per project rules, widgets are never nested inline. Each element is
declared as a local variable, then passed as an argument to its parent.

```dart
// Declare leaf widget
final backgroundImage = SvgPicture.asset(
  'assets/images/background.svg',
  fit: BoxFit.fitWidth,
);

// Declare container, referencing the leaf
final backgroundContainer = SizedBox(
  width: double.infinity,
  child: backgroundImage,
);

// Compose into a section
final backgroundSection = Column(
  children: [backgroundContainer, backgroundLabel],
);
```

This keeps each constructor call flat and readable. All widgets in the
project follow this convention.
