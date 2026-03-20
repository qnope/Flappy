# Task 1: Add Pipe Constants to GameConstants

## Summary
Add all pipe-related tuning values to `GameConstants` so subsequent tasks can reference them.

## Implementation Steps

### Step 1: Add constants to `lib/game/game_constants.dart`

Add the following block after the existing constants:

```dart
// Pipe dimensions (based on SVG viewBox: pipe 52x320, pipe_top 60x26)
static const double pipeWidth = 52.0;
static const double pipeCapWidth = 60.0;
static const double pipeCapHeight = 26.0;

// Pipe gap
static const double gapMinSize = 120.0;  // minimum vertical gap between top and bottom pipe
static const double gapMaxSize = 180.0;  // maximum vertical gap
static const double gapMinCenterMargin = 60.0; // minimum distance from gap center to top of screen or ground top

// Pipe pool and spacing
static const int pipePoolSize = 4;
static const double pipeSpacing = 200.0; // horizontal distance between pipe pair centers
static const double firstPipeOffset = 350.0; // distance from right edge for first pipe on reset
```

## Dependencies
- None (first task)

## Test Plan
- No dedicated test file needed — constants are plain `static const` values.
- Verified implicitly by tasks 2–6.

## Notes
- Values are fixed pixels, consistent with existing bird/ground constants.
- `gapMinCenterMargin` ensures neither pipe segment is too short (at least 60px of pipe visible above/below the gap).
- `firstPipeOffset` gives the player ~2.9 seconds of reaction time at 120 px/s scroll speed.
