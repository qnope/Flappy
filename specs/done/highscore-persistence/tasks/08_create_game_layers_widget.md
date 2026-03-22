# Task 8: Create GameLayersWidget (Shared Visual Layers)

## Summary
Extract the common visual layers (background, clouds, pipes, bird, ground) into a reusable `GameLayersWidget`. This will be composed into each phase widget, avoiding duplication.

## Implementation Steps

1. **Create `lib/game/game_layers_widget.dart`**

2. **Class `GameLayersWidget`** (StatelessWidget):
   - **Parameters**:
     - `double cloudsScrollOffset`
     - `double groundScrollOffset`
     - `List<Pipe> pipes` — list of pipe data objects
     - `double birdPosY`
     - `Wing birdWing`
     - `double birdRotation`
     - `double screenHeight`
     - `double screenWidth`
     - `List<Widget> overlays` — additional widgets to stack on top (phase-specific content)
   - **Build**:
     - Background (Positioned.fill + BackgroundWidget)
     - Clouds (Positioned.fill + CloudsWidget)
     - Pipe widgets (Positioned for each pipe)
     - Bird (Align with computed alignment)
     - Ground (Positioned bottom)
     - Then append all `overlays` on top
     - Return a Stack with StackFit.expand
   - Follow no-nested-construction rule throughout

3. **Extract pipe rendering logic** from current `game_screen.dart` lines 94-111 into this widget.

4. **Extract bird alignment logic** from current `game_screen.dart` lines 113-125 into this widget.

## File Paths
- `lib/game/game_layers_widget.dart` (new)

## Dependencies
- None (uses existing widgets: BackgroundWidget, CloudsWidget, GroundWidget, PipeWidget, BirdWidget)

## Test Plan
- Verified through phase widget tests (Tasks 14-15)
- Visual verification: phases render identically to current game_screen
