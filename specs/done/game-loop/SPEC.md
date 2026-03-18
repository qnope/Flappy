# Game Loop - Feature Specification

## 1. Feature Overview

Create the core gameplay screen for the Flappy Bird clone. This feature introduces:
- A **GameScreen** widget that becomes the app's home screen
- A **game loop** driven by a Ticker with setState updates
- A **bird** rendered using SVG sprites with wing animation and gravity physics
- **Tap-to-jump** input that gives the bird an upward impulse

The GameScreen displays the background and ground as static scenery, with the bird as the sole interactive element.

## 2. User Stories

### US-1: Game Screen Display
**As a** player,
**I want** to see the game screen with a background and ground,
**so that** I have a visual context for the game.

**Acceptance Criteria:**
- The GameScreen replaces AssetPreviewScreen as the MaterialApp home
- `background.svg` fills the entire screen as the backdrop
- `ground.svg` is displayed at the bottom of the screen, fixed (no scrolling)
- The bird is displayed on screen

### US-2: Idle State (Before Start)
**As a** player,
**I want** the bird to float at the center of the screen before I tap,
**so that** I know the game is ready to start.

**Acceptance Criteria:**
- On screen load, the bird is positioned at the vertical center of the screen
- The bird displays a continuous wing animation (sprite cycle) while idle
- Gravity is NOT active yet
- A visual hint indicates the player should tap (e.g. the bird gently bobs up and down, or a "Tap to start" text)

### US-3: Tap to Start
**As a** player,
**I want** to tap the screen to start the game,
**so that** I control when the action begins.

**Acceptance Criteria:**
- The first tap starts the game loop (gravity activates)
- The first tap also gives the bird its initial upward impulse
- The entire screen is the tap target (GestureDetector wrapping the full screen)

### US-4: Gravity
**As a** player,
**I want** gravity to pull the bird downward,
**so that** I need to keep tapping to stay airborne.

**Acceptance Criteria:**
- After the game starts, a constant downward acceleration is applied to the bird each frame
- The bird's vertical velocity increases downward over time when no tap occurs
- The bird falls naturally and accelerates (not a fixed speed descent)

### US-5: Tap to Jump
**As a** player,
**I want** to tap the screen to make the bird jump,
**so that** I can control its altitude.

**Acceptance Criteria:**
- Each tap sets the bird's vertical velocity to a fixed upward value (replaces current velocity, not additive)
- Gravity resumes immediately after the impulse
- Rapid tapping gives consistent, predictable jumps

### US-6: Bird Wing Animation
**As a** player,
**I want** to see the bird flapping its wings,
**so that** it looks alive and animated.

**Acceptance Criteria:**
- When the bird is rising or idle: cycle through `bird_up.svg` -> `bird_mid.svg` -> `bird_down.svg` -> `bird_mid.svg` (continuous loop)
- When the bird is descending: display `bird_mid.svg` (wings level, no flapping)
- The animation cycle speed is visually pleasant (approximately 150ms per frame)

### US-7: Bird Rotation
**As a** player,
**I want** the bird to tilt based on its movement direction,
**so that** the flight feels dynamic and responsive.

**Acceptance Criteria:**
- When the bird has upward velocity: tilt upward (negative rotation, approx -25 degrees max)
- When the bird has downward velocity: tilt downward (positive rotation, approx +70 degrees max)
- The rotation transitions smoothly, not abruptly
- Rotation is proportional to velocity (faster = more tilt)

### US-8: Ground Collision
**As a** player,
**I want** the bird to stop at the ground,
**so that** it doesn't disappear off screen.

**Acceptance Criteria:**
- The bird cannot descend below the top of the ground sprite
- When the bird hits the ground, its vertical velocity is set to zero
- The bird can freely exit through the top of the screen (no upper boundary)

## 3. Testing and Validation

### Unit Tests
- Bird physics: verify gravity increases downward velocity each frame
- Bird physics: verify tap impulse sets velocity to fixed upward value
- Bird physics: verify ground collision stops the bird
- Bird position: verify initial centered position

### Widget Tests
- GameScreen renders background, ground, and bird
- Tap gesture triggers jump (bird velocity changes)
- Bird sprite changes based on animation cycle
- Bird rotation reflects velocity direction

### Integration Tests
- Full game flow: screen loads -> bird idle at center -> tap to start -> bird jumps -> gravity pulls down -> tap again -> bird jumps again
- Ground collision: let bird fall, verify it stops at ground level

### Success Criteria
- Smooth 60fps game loop with no jank
- Responsive tap input with no perceptible delay
- Bird physics feel natural and fun to control
- Works on Chrome, iOS, and Android
