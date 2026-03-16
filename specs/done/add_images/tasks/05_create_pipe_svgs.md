# Task 05: Create Pipe SVGs

## Summary

Create `assets/images/pipe.svg` (pipe body) and `assets/images/pipe_top.svg` (pipe cap). The pipe body is vertically stretchable. The pipe_top serves as the cap and will be flipped vertically in code for the bottom pipe.

## Implementation Steps

1. **Create `assets/images/pipe.svg`** (pipe body)
   - SVG dimensions: `viewBox="0 0 52 320"` (narrow and tall)
   - **Shape**: Simple vertical rectangle with rounded-ish edges
   - **Color**: Green (#4CAF50) with darker green (#388E3C) shading/highlight strips
   - **Style**: Cartoon — visible outlines, subtle 3D shading
   - Must look correct when stretched vertically (avoid patterns that distort)

2. **Create `assets/images/pipe_top.svg`** (pipe cap)
   - SVG dimensions: `viewBox="0 0 60 26"` (wider than pipe body, short)
   - **Shape**: Rectangular cap with rounded corners, slightly wider than pipe body
   - **Color**: Same green palette as pipe body
   - **Width**: Must be wider than `pipe.svg` (60 vs 52) to create the cap overhang effect
   - **Alignment**: Centered horizontally relative to the pipe body

3. **Verify width relationship**
   - `pipe_top.svg` width (60) > `pipe.svg` width (52)
   - Cap overhangs evenly on both sides: (60 - 52) / 2 = 4 units per side

## Files Created

- `assets/images/pipe.svg`
- `assets/images/pipe_top.svg`

## Dependencies

- Task 01 (Flutter project initialized, `assets/images/` directory exists)

## Test Plan

- Both files exist in `assets/images/`
- Both are valid SVG
- `pipe_top.svg` is wider than `pipe.svg`
- Pipe body looks correct when height is scaled
- Flipping `pipe_top.svg` vertically produces a valid bottom cap
- Pipe + cap render together with proper alignment

## Notes

- `pipe_top.svg` is flipped vertically in code to serve as the bottom pipe cap. No separate bottom cap asset needed.
- The pipe body should be designed to look good at any height (no fixed patterns that break when stretched).
