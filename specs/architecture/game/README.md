# Game Layer (`lib/game/`)

## Overview

The game layer implements the core Flappy Bird gameplay: a ticker-driven game
loop, bird physics, sprite animation, and user input handling. All files live
in `lib/game/`.

## Game Loop

`GameScreen` is a thin `StatefulWidget` shell using `SingleTickerProviderStateMixin`.
A `Ticker` fires every frame (~60fps) and calls `GameController.update(dt)`,
which calls `notifyListeners()`. A `ListenableBuilder` listening to
`GameController` triggers the rebuild automatically -- no manual `setState`.

```
Ticker (every frame)
  │
  └─ GameController.update(dt)
       │
       ├─ idle phase:  sinusoidal bobbing, wing animation cycling
       │
       ├─ playing phase:
       │    ├─ Bird.update(dt, gravity)
       │    ├─ Bird.clampToGround(...)
       │    └─ wing animation (cycle when rising, freeze when falling)
       │
       └─ notifyListeners()
            └─ ListenableBuilder rebuilds widget tree
```

## Game Phases

The `GamePhase` enum drives two distinct states:

| Phase | Gravity | Input | Bird Behavior |
|-------|---------|-------|---------------|
| `idle` | Off | First tap starts game | Bobs up/down at center, wings animate |
| `playing` | On | Each tap triggers jump | Falls with gravity, taps give upward impulse |

## GameController (`game_controller.dart`)

A `ChangeNotifier` that owns all game logic:
- Game phase transitions (idle -> playing)
- Bird instance and physics updates
- Idle bobbing animation
- Wing animation timing
- Bird rotation computation

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
pipe, pipeTop).

## Widget Components

- **`BackgroundWidget`** -- Stateless widget rendering background SVG with
  `BoxFit.cover`.
- **`GroundWidget`** -- Stateless widget rendering ground SVG with
  `BoxFit.fitWidth`.
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
limits, and wing frame duration.
