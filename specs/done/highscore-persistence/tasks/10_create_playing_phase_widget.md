# Task 10: Create PlayingPhaseWidget

## Summary
Create a widget for the playing phase that shows the game layers with the current score displayed prominently at the top.

## Implementation Steps

1. **Create `lib/game/playing_phase_widget.dart`**

2. **Class `PlayingPhaseWidget`** (StatelessWidget):
   - **Parameters**:
     - `double cloudsScrollOffset`
     - `double groundScrollOffset`
     - `List<Pipe> pipes`
     - `double birdPosY`
     - `Wing birdWing`
     - `double birdRotation`
     - `double screenHeight`
     - `double screenWidth`
     - `int score`
   - **Build**:
     - Use `GameLayersWidget` for base rendering
     - Overlay: score text (same style as current — fontSize 48, white, bold, shadows)
     - Score aligned at `Alignment(0, -0.75)`

3. **Follow no-nested-construction rule.**

## File Paths
- `lib/game/playing_phase_widget.dart` (new)

## Dependencies
- Task 8 (GameLayersWidget)

## Test Plan
- Tested in Task 15
