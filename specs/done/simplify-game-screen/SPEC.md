# Simplify Game Screen — Feature Specification

## 1. Feature Overview

Refactor `game_screen.dart` to reduce its complexity by:
- Extracting reusable widgets for each visual element (Background, Ground, Bird).
- Centralizing SVG asset management with preloaded references and a `Wing` enum.
- Separating game logic (physics, state, animation) into a `GameController` using `ChangeNotifier`.

The result is a `GameScreen` that is purely a thin layout shell, delegating visuals to dedicated widgets and logic to a controller.

## 2. User Stories

### US-1: Wing Enum with Asset Path Getter

**As a** developer,
**I want** a `Wing` enum (`up`, `mid`, `down`) where each value exposes its SVG asset path via a getter,
**so that** wing sprite selection is type-safe and self-contained.

**Acceptance Criteria:**
- `Wing.up.assetPath` returns `'assets/images/bird_up.svg'`, etc.
- The enum replaces all raw string sprite path references (`GameConstants.wingSprites` array and index-based access).
- Wing animation logic uses `Wing` values instead of integer indices.

### US-2: Centralized SVG Asset Registry

**As a** developer,
**I want** all game SVG assets (background, ground, bird sprites, pipes) preloaded and accessible from a single registry,
**so that** no widget creates its own `SvgPicture.asset()` call with a hardcoded path.

**Acceptance Criteria:**
- A `GameAssets` class (or similar) holds references to all SVG asset paths.
- Each path is a named constant (e.g., `GameAssets.background`, `GameAssets.ground`, `GameAssets.pipe`, `GameAssets.pipeTop`).
- Bird wing assets are accessed via the `Wing` enum, not from this registry.
- All widgets consume assets from this centralized source.

### US-3: BackgroundWidget

**As a** developer,
**I want** a reusable `BackgroundWidget` that renders the background SVG filling its parent,
**so that** background rendering is decoupled from `GameScreen`.

**Acceptance Criteria:**
- `BackgroundWidget` is a `StatelessWidget` in its own file (`background_widget.dart`).
- It renders the background SVG with `BoxFit.cover`, expanding to fill its parent.
- It takes no size parameters — the caller controls size via `Positioned` / `SizedBox`.

### US-4: GroundWidget

**As a** developer,
**I want** a reusable `GroundWidget` that renders the ground SVG filling its parent width,
**so that** ground rendering is decoupled from `GameScreen`.

**Acceptance Criteria:**
- `GroundWidget` is a `StatelessWidget` in its own file (`ground_widget.dart`).
- It renders the ground SVG with `BoxFit.fitWidth`.
- It takes no size parameters — the caller controls positioning.

### US-5: Bird Entity Class

**As a** developer,
**I want** a `Bird` class that encapsulates the bird's position, physics, and current wing state,
**so that** all bird-related data lives in one cohesive object.

**Acceptance Criteria:**
- `Bird` class holds: `posX`, `posY`, `velocityY`, and current `Wing` value.
- It exposes a method to compute the current rotation based on velocity.
- It delegates physics (`update`, `jump`, `clampToGround`) to the existing `BirdPhysics` logic (which can be inlined or composed).
- `BirdWidget` receives a `Bird` instance (or the relevant subset: rotation, wing) to render itself.

### US-6: GameController with ChangeNotifier

**As a** developer,
**I want** a `GameController extends ChangeNotifier` that owns all game state and logic,
**so that** `GameScreen` only handles layout and input forwarding.

**Acceptance Criteria:**
- `GameController` owns: `GamePhase`, `Bird` instance, idle time, ground Y position.
- It exposes `onTap()` for input and `update(double dt)` for the game loop tick.
- It handles all state transitions (idle -> playing), bobbing, gravity, wing animation, and rotation.
- It calls `notifyListeners()` when state changes.
- `GameScreen` creates a `GameController`, calls `controller.update(dt)` from its `Ticker`, and rebuilds on notifications.

### US-7: Simplified GameScreen

**As a** developer,
**I want** `GameScreen` to be a thin shell that wires `GameController` to the widget tree,
**so that** the file is short, readable, and contains no game logic.

**Acceptance Criteria:**
- `GameScreen` responsibilities are limited to:
  1. Creating and disposing the `Ticker` and `GameController`.
  2. Forwarding tap events to `controller.onTap()`.
  3. Calling `controller.update(dt)` each tick.
  4. Building the `Stack` layout using `BackgroundWidget`, `GroundWidget`, `BirdWidget`, and "Tap to start" text.
  5. Reading all display values from the controller.
- No physics math, no animation timers, no rotation calculations in `GameScreen`.
- The file follows the project's non-nested construction rule.

## 3. Testing and Validation

- **Unit tests** for `GameController`: verify state transitions, physics updates, wing animation cycling, and rotation calculation.
- **Unit tests** for `Bird`: verify position updates, jump behavior, ground clamping, and wing state.
- **Widget tests** for `BackgroundWidget`, `GroundWidget`: verify they render their SVG asset.
- **Widget tests** for `GameScreen`: verify the screen assembles all widgets and forwards taps to the controller.
- **Existing tests** must continue to pass or be updated to reflect the new structure.
- The game must behave identically to the current version (same physics, same visuals, same controls).
