# Task 04: Create Bird SVGs (3 Frames)

## Summary

Create the 3 bird animation frames: `bird_up.svg`, `bird_mid.svg`, `bird_down.svg`. All 3 must share consistent dimensions and body alignment — only the wing position changes between frames.

## Implementation Steps

1. **Design the base bird shape**
   - SVG dimensions: `viewBox="0 0 34 24"` (small sprite, consistent across all 3)
   - **Body**: Yellow/orange round body (#FFC107, #FF9800)
   - **Eye**: White circle with black pupil
   - **Beak**: Orange/red triangular beak (#FF5722)
   - **Outline**: Dark outline stroke for cartoon look
   - **Style**: Rounded, cute, cartoon Flappy Bird style

2. **Create `assets/images/bird_up.svg`**
   - Wing positioned **up** (above the body midline)
   - Wing is a small curved shape on the bird's side

3. **Create `assets/images/bird_mid.svg`**
   - Wing positioned **mid** (at the body midline, horizontal)

4. **Create `assets/images/bird_down.svg`**
   - Wing positioned **down** (below the body midline)

5. **Verify consistency**
   - All 3 files have identical `viewBox`
   - Body, eye, and beak are identical across all 3 frames
   - Only the wing path differs

## Files Created

- `assets/images/bird_up.svg`
- `assets/images/bird_mid.svg`
- `assets/images/bird_down.svg`

## Dependencies

- Task 01 (Flutter project initialized, `assets/images/` directory exists)

## Test Plan

- All 3 files exist in `assets/images/`
- All 3 are valid SVG
- All 3 have the same `viewBox` dimensions
- Visual check: body aligns when overlaying frames, only wing moves
- Animation cycle (up → mid → down → mid) looks smooth

## Notes

- Consistency is critical. Build one base bird, then duplicate and modify only the wing for each frame.
- The animation cycle is: up → mid → down → mid → up → ...
