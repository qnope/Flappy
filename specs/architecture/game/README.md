# Game Layer (`lib/game/`)

## Overview

The game layer implements the core Flappy Bird gameplay: a ticker-driven game
loop, bird physics, sprite animation, and user input handling. All files live
in `lib/game/`.

## Game Loop

`GameScreen` is a `StatefulWidget` using `SingleTickerProviderStateMixin`.
A `Ticker` fires every frame (~60fps) and calls `setState` to re-render.

```
Ticker (every frame)
  │
  ├─ idle phase:  sinusoidal bobbing, wing animation cycling
  │
  └─ playing phase:
       ├─ BirdPhysics.update(dt, gravity)
       ├─ BirdPhysics.clampToGround(...)
       └─ wing animation (cycle when rising, freeze when falling)
```

## Game Phases

The `GamePhase` enum drives two distinct states:

| Phase | Gravity | Input | Bird Behavior |
|-------|---------|-------|---------------|
| `idle` | Off | First tap starts game | Bobs up/down at center, wings animate |
| `playing` | On | Each tap triggers jump | Falls with gravity, taps give upward impulse |

## Bird Physics (`bird_physics.dart`)

A plain Dart class (no Flutter dependency) with three operations:

- **`update(dt, gravity)`** -- applies gravity to velocity, then velocity to
  position (Euler integration)
- **`jump(jumpVelocity)`** -- replaces current velocity with a fixed upward
  value
- **`clampToGround(groundTopY, birdHeight)`** -- prevents bird from falling
  below ground; zeroes velocity on contact

## Bird Rendering (`bird_widget.dart`)

Stateless widget that takes a `rotation` (degrees) and a `spritePath`. Renders
the SVG at fixed dimensions and applies `Transform.rotate`.

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
limits, and wing frame duration.
