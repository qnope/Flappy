# Task 6: Simplified GameScreen

## Summary

Rewrite `GameScreen` as a thin shell: it creates a `Ticker` and a `GameController`, forwards taps, calls `controller.update(dt)` each frame, and builds the layout using `BackgroundWidget`, `GroundWidget`, and `BirdWidget`. No game logic remains in this file.

Covers: US-7

## Implementation Steps

### Step 1: Rewrite `lib/game/game_screen.dart`

The new `_GameScreenState` contains only:

**State fields:**
- `late Ticker _ticker`
- `late GameController _controller`
- `Duration _lastTickTime = Duration.zero`

**initState():**
- Create `_controller = GameController()`.
- Create and start the ticker.

**dispose():**
- `_ticker.dispose()`
- `_controller.dispose()`

**_onTick(Duration elapsed):**
- Compute `dt` from elapsed and `_lastTickTime`.
- Call `_controller.update(dt)`.
- Call `setState(() {})` to trigger rebuild (the controller owns all state).

**_onTap():**
- Call `_controller.onTap()`.

**build():**
- `LayoutBuilder` to get screen dimensions.
- On first build, call `_controller.initialize(birdX: ..., birdStartY: ..., groundTopY: ...)`.
- Build the `Stack` with:
  1. `Positioned.fill(child: const BackgroundWidget())`
  2. `Positioned(bottom: 0, ..., child: const GroundWidget())`
  3. `Positioned(key: ValueKey('bird'), left: _controller.bird.posX, top: _controller.bird.posY, ..., child: birdWidget)`
  4. Conditionally, the "Tap to start" text when `_controller.gamePhase == GamePhase.idle`.
- Wrap in `GestureDetector(onTap: _onTap, ...)`.

**Key constraints:**
- The `ValueKey('bird')` on the Positioned must be preserved — existing tests rely on it.
- Follow the non-nested construction rule throughout.
- No `dart:math` import needed (moved to controller).
- No physics, animation, or rotation logic.

### Step 2: Remove dead code

- Remove from `game_screen.dart`: `_bird`, `_gamePhase`, `_initialized`, `_birdX`, `_birdStartY`, `_groundTopY`, `_idleTime`, `_wingFrameIndex`, `_wingFrameTimer`, `_calculateBirdRotation()`.
- Remove unused imports (`dart:math`, `bird_physics.dart`).

### Step 3: Clean up imports across the project

- Ensure `lib/game/game_screen.dart` imports: `game_controller.dart`, `background_widget.dart`, `ground_widget.dart`, `bird_widget.dart`, `game_constants.dart`, `game_state.dart`.
- Remove any orphan imports.

## Dependencies

- Task 1 (Wing enum, GameAssets).
- Task 2 (BackgroundWidget).
- Task 3 (GroundWidget).
- Task 4 (Bird entity, updated BirdWidget).
- Task 5 (GameController).

## Test Plan

### File: `test/game_screen_test.dart` (update)

All existing tests must continue to pass. They rely on:
- `find.byType(SvgPicture)` finding background, ground, and bird SVGs — still works since extracted widgets still render `SvgPicture`.
- `find.byKey(ValueKey('bird'))` finding the bird `Positioned` — preserved.
- `find.byType(BirdWidget)` inside the bird Positioned — preserved.
- `find.byType(GestureDetector)` for tap — preserved.
- `find.text('Tap to start')` — preserved.

If imports changed (e.g., `BirdWidget` now takes `Wing` instead of `String`), update test assertions accordingly.

### File: `test/game_flow_integration_test.dart` (update)

Same as above — all integration tests must pass. No API changes visible at the widget-tree level.

### Manual verification

- Run the app on Chrome: bird bobs in idle, tap starts game, gravity works, tap jumps, wing animation cycles, rotation follows velocity, ground collision stops bird.
- Behavior must be identical to pre-refactor.

## Notes

- The `ListenableBuilder` pattern (`ListenableBuilder(listenable: _controller, builder: ...)`) is an alternative to `setState(() {})` in `_onTick`. However, since the ticker already fires every frame and we need a rebuild each frame anyway, a simple `setState` in `_onTick` is simpler and equivalent. Choose whichever is cleaner.
- `_controller.initialize()` is called inside `LayoutBuilder.builder` on first build. This is identical to the current pattern where `_initialized` is set inside the builder.
