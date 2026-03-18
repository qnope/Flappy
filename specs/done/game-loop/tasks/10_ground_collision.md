# Task 10: Ground Collision

## Summary

Ensure the bird stops at the ground level and cannot fall through it. The bird's velocity is set to zero on ground contact. No upper boundary — the bird can fly off the top of the screen.

## Implementation Steps

### Step 1: Verify ground collision in game loop

The ground collision logic was already added in `BirdPhysics.clampToGround()` (Task 01) and called in `_onTick` (Task 05). This task verifies it works correctly and makes any needed adjustments.

Verify in `_onTick`:
```dart
setState(() {
  _bird.update(dt, GameConstants.gravity);
  _bird.clampToGround(_groundTopY, GameConstants.birdHeight);
});
```

### Step 2: Ensure ground top Y is calculated correctly

Verify `_groundTopY` accounts for the actual rendered height of the ground SVG. The ground SVG has a viewBox of `0 0 336 112`, so when rendered with `fitWidth`:

```dart
// Ground height when rendered at full width
// The SVG aspect ratio is 336:112 = 3:1
// So ground height = screenWidth / 3
final groundRenderedHeight = screenWidth / 3.0;
_groundTopY = screenHeight - groundRenderedHeight;
```

**Important**: Use the actual rendered height of the ground SVG, not the ratio-based estimate from `GameConstants.groundHeightRatio`. Update the constant or remove it if not accurate.

### Step 3: No upper boundary

Verify there is NO clamping for the top of the screen. The bird should be able to fly off screen above. This is already the default behavior (no code needed to prevent it).

## Dependencies

- Task 01 (bird_physics.dart — clampToGround method)
- Task 03 (game_screen.dart — ground rendering)
- Task 05 (game loop — calls clampToGround)

## Test Plan

- Let the bird fall without tapping: bird stops at the ground level, does not fall through
- Bird sits flush on top of the ground sprite
- Tap rapidly to fly very high: bird exits top of screen, comes back down when falling
- After hitting ground, tapping makes the bird jump again

## Notes

- The ground SVG viewBox (336x112) determines the actual height when rendered
- `clampToGround` both stops the bird AND zeroes the velocity — important so gravity doesn't keep accumulating
- No game-over state in this feature — ground collision just stops the bird (game-over comes in a future feature)
