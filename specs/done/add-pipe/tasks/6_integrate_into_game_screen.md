# Task 6: Integrate Pipes into GameScreen + Widget Tests

## Summary
Add pipe rendering to `GameScreen` by iterating over the `PipePool` and positioning `PipeWidget` instances in the render Stack. Pipes are layered behind the bird and behind the ground.

## Implementation Steps

### Step 1: Modify `lib/game/game_screen.dart`

1. Add import:
   ```dart
   import 'pipe_widget.dart';
   ```

2. Inside `build()`, after creating the `clouds` widget and before creating the `bird` widget, generate pipe widgets from the pool:

   ```dart
   final pipeWidgets = <Widget>[];
   for (final pipe in _controller.pipePool.pipes) {
     final pipeWidget = PipeWidget(
       gapCenterY: pipe.gapCenterY,
       gapSize: pipe.gapSize,
       screenHeight: screenHeight,
       groundTopY: groundTopY,
     );

     final positionedPipe = Positioned(
       left: pipe.posX - GameConstants.pipeCapWidth / 2,
       top: 0,
       bottom: 0,
       width: GameConstants.pipeCapWidth,
       child: pipeWidget,
     );

     pipeWidgets.add(positionedPipe);
   }
   ```

3. Update the children list to insert pipes between clouds and bird:
   ```dart
   final children = <Widget>[
     background,
     clouds,
     ...pipeWidgets,
     bird,
     groundPositioned,
   ];
   ```

### Step 2: Add pipe import for GameConstants (if not already imported)

The `game_screen.dart` already imports `game_constants.dart`. No extra import needed beyond `pipe_widget.dart`.

### Step 3: Update `test/game_screen_test.dart`

Add test cases:
- **Pipe widgets present during idle**: pump `GameScreen`, verify `PipeWidget` instances exist in the widget tree
- **Pipe widgets present during playing**: tap to start, verify `PipeWidget` still present
- **Correct number of pipe widgets**: verify `find.byType(PipeWidget)` count equals `GameConstants.pipePoolSize`

### Step 4: Verify existing game_screen tests still pass

Run all existing tests to ensure nothing is broken by the new widgets in the tree.

## Dependencies
- Task 1 (GameConstants)
- Task 2 (Pipe)
- Task 3 (PipePool)
- Task 4 (GameController integration — provides `pipePool` on controller)
- Task 5 (PipeWidget)

## Test Plan
- **File**: `test/game_screen_test.dart` (add to existing file)
- ~3 new widget tests
- All existing game_screen tests must still pass

## Notes
- Pipes are positioned using `Positioned(left: pipe.posX - capWidth/2)` to center the pipe on its X coordinate.
- Z-order: pipes go between clouds and bird, behind ground (as confirmed by user).
- Following project rules: no nested construction — `PipeWidget` is created as a variable, wrapped in `Positioned`, then added to the list.
- Pipes render during both idle and playing phases (per SPEC US-1).
- The `pipe.posX` represents the center of the pipe; `left` offset accounts for half the cap width.
