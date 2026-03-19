# Task 09: Update GameScreen to Compose Parallax Layers

## Summary

Update `GameScreen` to include the clouds layer and pass scroll offsets from `GameController` to the scrolling widgets. The Stack z-order becomes: sky (back) → clouds → bird/game elements → ground (front).

## Implementation Steps

1. **Edit `lib/game/game_screen.dart`**

   - Add import for `clouds_widget.dart`.

   - In the `ListenableBuilder` builder (inside `LayoutBuilder`), read scroll offsets from the controller:
     ```dart
     final groundOffset = controller.groundScrollOffset;
     final cloudsOffset = controller.cloudsScrollOffset;
     ```

   - Update the widget tree in the `Stack.children` list:
     ```dart
     // 1. Sky background (static, fills screen)
     final background = Positioned.fill(child: BackgroundWidget());

     // 2. Clouds layer (scrolling, full-screen overlay)
     final clouds = Positioned.fill(
       child: CloudsWidget(scrollOffset: cloudsOffset),
     );

     // 3. Bird (existing positioning logic unchanged)
     // ... existing bird Align widget ...

     // 4. Ground (scrolling, bottom-positioned)
     final ground = Positioned(
       left: 0,
       right: 0,
       bottom: 0,
       height: groundRenderedHeight,
       child: GroundWidget(scrollOffset: groundOffset),
     );
     ```

   - Stack order: `[background, clouds, birdWidget, ground, ...idleText]`

   - Pass `scrollOffset` to `GroundWidget` constructor (was previously no-arg).

2. **Follow the no-nesting rule**: Declare each `Positioned`/widget as a variable before adding to the `Stack.children` list.

## Dependencies

- Task 05 (scroll offsets in GameController)
- Task 06 (GroundWidget with scrollOffset)
- Task 07 (CloudsWidget)
- Task 08 (BackgroundWidget verification)

## Test Plan

- **`test/game_screen_test.dart`**: Updated in task 12.
  - `CloudsWidget` is present in the widget tree.
  - `GroundWidget` still renders.
  - `BackgroundWidget` still renders.
  - All three layers are in the correct Stack order.

## Design Notes

- The clouds layer is `Positioned.fill` (full-screen overlay). The transparent parts of `clouds.svg` let the sky gradient show through.
- Ground is `Positioned` at the bottom with explicit height to maintain existing layout behavior.
- The bird and idle text remain between clouds and ground in z-order, ensuring they're visible above the clouds but below the ground edge.
