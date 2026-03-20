# Game Layer (`lib/game/`)

## Overview

The game layer implements the core Flappy Bird gameplay: a ticker-driven game
loop, bird physics, sprite animation, and user input handling. All files live
in `lib/game/`.

## Game Loop

`GameScreen` is a thin `StatefulWidget` shell using `SingleTickerProviderStateMixin`.
A `Ticker` fires every frame (~60fps) and calls `GameController.update(dt)`.
`GameScreen` then calls `setState()` to trigger a rebuild with the updated state.

```
Ticker (every frame)
  │
  └─ GameController.update(dt)
       │
       ├─ scroll offsets: ground and clouds advance continuously
       │
       ├─ pipe pool: pipes move left at ground speed, recycle off-screen
       │
       ├─ idle phase:  sinusoidal bobbing, wing animation cycling
       │
       ├─ playing phase:
       │    ├─ Bird.update(dt, gravity)
       │    ├─ Bird.clampToGround(...)
       │    └─ wing animation (cycle when rising, freeze when falling)
       │
       └─ GameScreen calls setState() to rebuild widget tree
```

## Game Phases

The `GamePhase` enum drives two distinct states:

| Phase | Gravity | Input | Bird Behavior |
|-------|---------|-------|---------------|
| `idle` | Off | First tap starts game | Bobs up/down at center, wings animate |
| `playing` | On | Each tap triggers jump | Falls with gravity, taps give upward impulse |

## GameController (`game_controller.dart`)

A plain Dart class that owns all game logic:
- Game phase transitions (idle -> playing)
- Bird instance and physics updates
- Idle bobbing animation
- Wing animation timing
- Bird rotation computation
- Scroll offsets (`groundScrollOffset`, `cloudsScrollOffset`) updated every frame
- `PipePool` instance: pipes advance by the same distance as ground each frame

On tap (idle -> playing), the pipe pool is reset to starting positions. Scroll
offsets advance continuously in both idle and playing phases. Large `dt` values
(> 0.1s) are skipped to avoid visual jumps.

Fully unit-testable without Flutter widgets.

## Bird Entity (`bird.dart`)

A plain Dart class encapsulating:
- **Position** (`posY`) and velocity (`velocityY`)
- **Wing state** (`currentWing`) for current animation frame
- **`update(dt, gravity)`** -- Euler integration for gravity
- **`jump(jumpVelocity)`** -- replaces current velocity
- **`clampToGround(groundTopY, birdHeight)`** -- ground collision
- **`rotation`** getter -- computed from velocity

## Wing Enum (`wing.dart`)

Enum with three values (`up`, `mid`, `down`), each carrying an `assetPath`.
Defines `animationSequence` as a static const list.

## GameAssets (`game_assets.dart`)

Centralized named constants for non-bird SVG asset paths (background, ground,
pipe, pipeTop, clouds).

## Pipe System

### Pipe Model (`pipe.dart`)

A plain Dart class with `posX`, `gapCenterY`, and `gapSize` fields. Computed
getters `gapTop` and `gapBottom` derive the gap edges from center and size.

### PipePool (`pipe_pool.dart`)

Manages a fixed pool of `Pipe` objects (pool size: 6). Key behaviors:
- **`reset()`** -- Reinitializes all pipes at starting positions with random gaps
- **`update(distance)`** -- Moves all pipes left; recycles any that exit the
  left edge by repositioning them to the right with new random gaps
- Gap sizes are randomized between 120-180px, centers stay within safe margins

Accepts an optional `Random` for deterministic testing.

### PipeWidget (`pipe_widget.dart`)

Stateless widget rendering a single pipe pair (top + bottom) using SVG assets.
Takes `gapCenterY`, `gapSize`, and `screenHeight`. Each pipe is a `Column`
with a stretchable body and a fixed cap. The bottom cap is flipped vertically.

### Rendering Order

Pipes are rendered between clouds and the bird in `GameScreen`'s Stack:
`background -> clouds -> pipes -> bird -> ground`

## Widget Components

- **`BackgroundWidget`** -- Stateless widget rendering static sky SVG with
  `BoxFit.cover`.
- **`ScrollingLayerWidget`** -- Reusable stateless widget for infinite
  horizontal scrolling. Takes an `assetPath`, `scrollOffset`, and `BoxFit`.
  Renders two adjacent SVG tiles in a `Row`, wrapped in `Transform.translate`
  with modulo wrapping, and clipped via `UnconstrainedBox(clipBehavior: Clip.hardEdge)`.
- **`GroundWidget`** -- Wrapper around `ScrollingLayerWidget` with ground asset
  and `BoxFit.fitWidth`. Takes a `scrollOffset` parameter.
- **`CloudsWidget`** -- Wrapper around `ScrollingLayerWidget` with clouds asset
  and `BoxFit.cover`. Takes a `scrollOffset` parameter.
- **`BirdWidget`** -- Stateless widget taking `Wing` and `rotation` (degrees).
  Renders SVG at fixed dimensions with `Transform.rotate`.

## Wing Animation

Four-frame sprite cycle: `bird_up` -> `bird_mid` -> `bird_down` -> `bird_mid`.
Each frame lasts 150ms. Animation runs when idle or rising; freezes to
`bird_mid` when falling.

## Bird Rotation

Rotation is proportional to vertical velocity:
- Rising: up to -25 degrees (nose up)
- Falling: up to +70 degrees (nose down)
- Idle: 0 degrees

## Constants (`game_constants.dart`)

All tuning values are centralized: gravity (1200 px/s²), jump velocity
(-400 px/s), bird dimensions (51x36), bob amplitude/frequency, rotation
limits, wing frame duration, parallax scroll speeds (ground: 120 px/s,
clouds: 30 px/s), and pipe parameters (dimensions, gap bounds, pool size,
spacing).
