# Moving Background - Feature Specification

## 1. Feature Overview

- Add a parallax scrolling background to the Flappy Bird game, giving an illusion of horizontal movement and depth.
- The background is composed of 3 layers that scroll at different speeds, creating a parallax effect.
- The scrolling runs continuously (both in idle and playing phases), looping seamlessly without visible seams.
- The ground also scrolls as the fastest layer, matching the original Flappy Bird behavior.

## 2. User Stories

### US-1: Parallax background scrolling
**As a** player,
**I want** to see the background scroll horizontally with a parallax effect,
**So that** I feel the bird is flying forward through the world.

**Acceptance Criteria:**
- The background is composed of 3 distinct layers:
  1. **Sky layer** (back): Fixed or very slow-moving sky gradient. Serves as the static backdrop.
  2. **Clouds layer** (middle): Simple white/light gray clouds that scroll at medium speed. Flappy Bird classic style.
  3. **Ground layer** (front): The ground scrolls at the fastest speed, closest to the viewer.
- Each layer scrolls at a different speed, with the ground being the fastest and the sky the slowest, creating a depth effect.
- The scrolling is continuous and infinite — each layer tiles seamlessly with no visible cut or jump.
- The scrolling runs at all times: during idle phase and during playing phase, at the same constant speed.

### US-2: Seamless looping
**As a** player,
**I want** the background to loop without any visible seam or stutter,
**So that** the world feels infinite and immersive.

**Acceptance Criteria:**
- Each scrolling layer (clouds, ground) repeats seamlessly — when one copy exits the screen on the left, the next copy follows without any gap.
- The SVG assets for clouds and ground are designed to be tileable (the right edge connects smoothly to the left edge).
- No visible jump, flicker, or gap during the loop transition.

### US-3: SVG assets for layers
**As a** developer,
**I want** dedicated SVG assets for each parallax layer,
**So that** each layer can be rendered and scrolled independently.

**Acceptance Criteria:**
- A new SVG asset is created for the clouds layer (tileable, simple white clouds on a transparent background).
- The existing `ground.svg` is adapted or a new tileable version is created so it loops seamlessly.
- The existing `background.svg` is adapted to serve as the static sky gradient layer (no clouds embedded in it — clouds are in their own layer).
- All assets are SVG as required by project rules.

## 3. Testing and Validation

- **Unit tests:** Verify that the scroll offset updates correctly over time for each layer.
- **Widget tests:** Verify that each scrolling layer widget renders without errors and that the parallax layers are present in the widget tree.
- **Visual validation:** Manual check on Chrome, iOS, and Android that:
  - The parallax effect is visible and smooth.
  - No seams or gaps appear during looping.
  - Performance remains smooth (no jank or dropped frames).
- **Criteria for success:**
  - All 3 layers are visible and scroll at different speeds.
  - The scrolling is continuous and seamless.
  - The game remains performant on all target platforms.
