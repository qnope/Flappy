# Task 11: Create DyingPhaseWidget

## Summary
Create a widget for the dying phase. Visually identical to playing (score shown, bird falling) but exists as a separate widget per the spec requirement that each phase has its own widget.

## Implementation Steps

1. **Create `lib/game/dying_phase_widget.dart`**

2. **Class `DyingPhaseWidget`** (StatelessWidget):
   - **Parameters**: same as PlayingPhaseWidget
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
     - Overlay: score text (same style as playing phase)
     - Score aligned at `Alignment(0, -0.75)`

3. **Note**: This is intentionally similar to PlayingPhaseWidget. The separation enables future divergence (e.g., screen shake, different overlay effects during dying).

4. **Follow no-nested-construction rule.**

## File Paths
- `lib/game/dying_phase_widget.dart` (new)

## Dependencies
- Task 8 (GameLayersWidget)

## Test Plan
- Tested in Task 15
