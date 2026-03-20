# Add Pipe Feature Specification

## 1. Feature Overview

Add scrolling pipe obstacles to the Flappy Bird game. Pipes consist of pairs (top and bottom) with a gap in between for the bird to fly through. Pipes scroll at the same speed as the ground so they appear anchored to it. Pipes are visible during both idle and playing phases, but the pipe set is reset when the game transitions from idle to playing.

This feature is visual only — collision detection between the bird and pipes will be handled in a separate project.

## 2. User Stories

### US-1: Pipes scroll with the ground
**As a** player,
**I want** to see pipe pairs scrolling from right to left at the same speed as the ground,
**So that** pipes appear fixed to the ground and create a consistent world.

**Acceptance criteria:**
- Pipes move at the same horizontal speed as the ground (currently 120 px/s).
- Pipes never drift relative to the ground layer.
- Pipes scroll continuously in both idle and playing phases.

### US-2: Pipe pairs have a random gap
**As a** player,
**I want** each pipe pair to have a randomly sized and positioned gap,
**So that** the game feels varied and challenging.

**Acceptance criteria:**
- Each pipe pair has a vertical gap whose size is randomized within a defined min/max range.
- The vertical position (center) of the gap is randomized within safe bounds so neither pipe segment is too short or clips outside the visible play area (above sky, below ground).
- Top pipe extends from the top of the screen down to the gap.
- Bottom pipe extends from the gap down to the top of the ground.

### US-3: Pipes are evenly spaced
**As a** player,
**I want** pipes to appear at regular horizontal intervals,
**So that** the rhythm of the game is predictable and fair.

**Acceptance criteria:**
- Pipe pairs are separated by a fixed horizontal distance.
- Enough pipe pairs exist off-screen to the right to fill the screen as they scroll in.

### US-4: Pipes are recycled for performance
**As a** player,
**I want** the game to run smoothly without frame drops,
**So that** the experience is pleasant.

**Acceptance criteria:**
- When a pipe pair scrolls completely off the left edge of the screen, it is repositioned to the right side with new random gap values.
- No new pipe objects are created or destroyed during gameplay — a fixed pool is reused.

### US-5: Pipes reset on game start
**As a** player,
**I want** pipes to reset when I tap to start a new game,
**So that** I always begin with a fresh, fair set of obstacles.

**Acceptance criteria:**
- When transitioning from idle to playing, all pipe positions and gap values are regenerated.
- The first pipe is placed far enough to the right of the screen that the player has time to react.

## 3. Testing and Validation

### Unit tests
- **Pipe model**: verify gap size is within the configured min/max range.
- **Pipe model**: verify gap center position stays within safe vertical bounds.
- **Pipe pool**: verify pipes are recycled (repositioned with new values) when they exit the screen.
- **Pipe pool**: verify regular horizontal spacing between pipe pairs.
- **Game controller**: verify pipes reset when game transitions from idle to playing.
- **Game controller**: verify pipe scroll offset advances at the same rate as the ground scroll offset.

### Widget tests
- **PipeWidget**: renders top and bottom pipe segments at correct positions given a gap center and gap size.
- **Game screen**: pipe widgets are present in the widget tree during both idle and playing phases.

### Criteria for success
- Pipes scroll seamlessly with the ground in both phases.
- Gap randomization produces visually varied pipe pairs.
- No frame drops from pipe management (recycling works correctly).
- All unit and widget tests pass.
