# Game Layer (`lib/game/`)

## Overview

The game layer implements the core Flappy Bird gameplay: a ticker-driven game
loop, bird physics, sprite animation, and user input handling. All files live
in `lib/game/`.

## Game Loop

`GameScreen` is a `StatefulWidget` acting as a **phase switcher**. It uses
`SingleTickerProviderStateMixin` with a `Ticker` firing every frame (~60fps).
Each tick calls `GameController.update(dt)`, then `setState()` triggers a
rebuild that delegates rendering to the phase widget matching the current
`GamePhase`.

```
Ticker (every frame)
  │
  └─ GameController.update(dt)
       │
       ├─ scroll offsets: ground and clouds advance continuously
       ├─ pipe pool: pipes move left at ground speed, recycle off-screen
       ├─ idle phase:  sinusoidal bobbing, wing animation cycling
       ├─ playing phase: Bird.update(dt, gravity), collision checks
       │
       └─ GameScreen.setState()
            └─ switch (gamePhase)
                 ├─ idle    → IdlePhaseWidget
                 ├─ playing → PlayingPhaseWidget
                 ├─ dying   → DyingPhaseWidget
                 └─ gameOver → GameOverPhaseWidget
```

## Game Phases

The `GamePhase` enum drives four distinct states forming a cycle:

```
idle ──tap──▶ playing ──collision──▶ dying ──ground hit──▶ gameOver ──tap──▶ idle
```

| Phase | Gravity | Scrolling | Input | Bird Behavior |
|-------|---------|-----------|-------|---------------|
| `idle` | Off | Yes | First tap starts game | Bobs up/down at center, wings animate |
| `playing` | On | Yes | Each tap triggers jump | Falls with gravity, collision checks active |
| `dying` | On | No | Ignored | Bird falls to ground after pipe collision |
| `gameOver` | Off | No | Tap restarts to idle | Frozen, game over overlay shown |

## GameController (`game_controller.dart`)

A plain Dart class that owns all game logic:
- Game phase transitions (`idle` → `playing` → `dying` → `gameOver` → `idle`)
- Bird instance and physics updates
- Idle bobbing animation
- Wing animation timing
- Bird rotation computation
- Scroll offsets (`groundScrollOffset`, `cloudsScrollOffset`) updated every frame
- `PipePool` instance: pipes advance by the same distance as ground each frame
- **Collision detection**: AABB check of bird rect against all pipe solid areas
- **Score tracking**: increments when bird center passes a pipe's right edge
- **Game over reset**: restores all state (bird, score, pipes, phase) to initial

On tap (idle → playing), the pipe pool is reset to starting positions. Scroll
offsets advance continuously in idle and playing phases. Large `dt` values
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

A plain Dart class with `posX`, `gapCenterY`, `gapSize`, and `scored` fields.
Computed getters `gapTop` and `gapBottom` derive the gap edges from center and
size. The `scored` flag prevents double-counting when the bird passes a pipe.

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

Layers are rendered via `GameLayersWidget`'s Stack from back to front:
`background → clouds → pipes → bird → ground → overlays`

Each phase widget passes its own overlays (score text, leaderboard, etc.)
to `GameLayersWidget` via the `overlays` parameter.

## Phase Widgets

Each game phase has its own dedicated widget. All compose `GameLayersWidget`
(the shared visual stack) and add phase-specific overlays.

| Widget | Overlays |
|--------|----------|
| `IdlePhaseWidget` | "Tap to start", last score, leaderboard (if scores exist) |
| `PlayingPhaseWidget` | Live score counter |
| `DyingPhaseWidget` | Score counter (frozen) |
| `GameOverPhaseWidget` | "Game Over", final score, "New High Score!" indicator, leaderboard, "Tap to restart" |

### GameLayersWidget

Reusable stateless widget that builds the shared rendering stack:
`background → clouds → pipes → bird → ground → overlays`. All phase
widgets pass their scroll offsets, bird state, pipes, and overlay widgets
to `GameLayersWidget` via constructor parameters.

### LeaderboardWidget

Displays the top 10 scores in a styled table (rank, score, date). Supports
an optional `highlightIndex` to gold-highlight a new high score entry.
Returns an empty `SizedBox` when the score list is empty.

## Score Persistence

### ScoreEntry (`score_entry.dart`)

A Hive `@HiveType(typeId: 0)` with two fields: `score` (int) and `date`
(DateTime). Code-generated adapter via `hive_generator`.

### ScoreRepository (`score_repository.dart`)

Hive-backed repository managing the top 10 scores:
- **`addScore(score, date)`** -- Inserts entry, prunes beyond top 10
- **`getTopScores()`** -- Returns up to 10 entries sorted by score desc
- **`getLastScore()`** -- Most recent entry by date
- **`isNewHighScore(score)`** -- True if score exceeds the current #1
- **`clear()`** -- Wipes all entries (used in tests)

Constructor takes a `Box<ScoreEntry>` for testability. The static `create()`
factory opens the Hive box for production use.

## Other Widget Components

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
