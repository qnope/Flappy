# Task 5: Create PipeWidget + Widget Tests

## Summary
Create a stateless widget that renders a single pipe pair (top pipe + bottom pipe) given the pipe's gap parameters and screen dimensions.

## Implementation Steps

### Step 1: Create `lib/game/pipe_widget.dart`

The widget renders a single pipe pair as a `SizedBox` containing a `Stack` with two `Positioned` children (top pipe and bottom pipe).

Each pipe segment (top or bottom) is composed of:
- A pipe body (`pipe.svg`) stretched to fill the segment height
- A pipe cap (`pipe_top.svg`) at the edge closest to the gap

**Top pipe**: extends from Y=0 down to `gapTop`. Cap is at the bottom, body fills above.
**Bottom pipe**: extends from `gapBottom` down to `groundTopY`. Cap is at the top (flipped vertically), body fills below.

```dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'game_assets.dart';
import 'game_constants.dart';

class PipeWidget extends StatelessWidget {
  final double gapCenterY;
  final double gapSize;
  final double screenHeight;
  final double groundTopY;

  const PipeWidget({
    super.key,
    required this.gapCenterY,
    required this.gapSize,
    required this.screenHeight,
    required this.groundTopY,
  });

  @override
  Widget build(BuildContext context) {
    final gapTop = gapCenterY - gapSize / 2;
    final gapBottom = gapCenterY + gapSize / 2;

    final topPipe = _buildTopPipe(gapTop);
    final bottomPipe = _buildBottomPipe(gapBottom);

    final topPositioned = Positioned(
      top: 0,
      left: 0,
      right: 0,
      height: gapTop,
      child: topPipe,
    );

    final bottomPositioned = Positioned(
      top: gapBottom,
      left: 0,
      right: 0,
      height: groundTopY - gapBottom,
      child: bottomPipe,
    );

    return SizedBox(
      width: GameConstants.pipeCapWidth,
      height: screenHeight,
      child: Stack(
        children: [topPositioned, bottomPositioned],
      ),
    );
  }

  Widget _buildTopPipe(double height) {
    // Top pipe: body fills most of height, cap at bottom
    // The entire segment is flipped vertically so pipe body grows upward
    // and cap appears at the bottom edge
    final bodyHeight = height - GameConstants.pipeCapHeight;

    final body = SvgPicture.asset(
      GameAssets.pipe,
      width: GameConstants.pipeWidth,
      height: bodyHeight > 0 ? bodyHeight : 0,
      fit: BoxFit.fill,
    );

    final cap = SvgPicture.asset(
      GameAssets.pipeTop,
      width: GameConstants.pipeCapWidth,
      height: GameConstants.pipeCapHeight,
      fit: BoxFit.fill,
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(child: Center(child: body)),
        cap,
      ],
    );
  }

  Widget _buildBottomPipe(double gapBottom) {
    // Bottom pipe: cap at top (flipped), body fills below
    final segmentHeight = groundTopY - gapBottom;
    final bodyHeight = segmentHeight - GameConstants.pipeCapHeight;

    final body = SvgPicture.asset(
      GameAssets.pipe,
      width: GameConstants.pipeWidth,
      height: bodyHeight > 0 ? bodyHeight : 0,
      fit: BoxFit.fill,
    );

    final flippedCap = Transform.flip(
      flipY: true,
      child: SvgPicture.asset(
        GameAssets.pipeTop,
        width: GameConstants.pipeCapWidth,
        height: GameConstants.pipeCapHeight,
        fit: BoxFit.fill,
      ),
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        flippedCap,
        Expanded(child: Center(child: body)),
      ],
    );
  }
}
```

### Step 2: Create `test/pipe_widget_test.dart`

Test cases:
- **Renders without error**: pump `PipeWidget` with valid params, no exceptions
- **Contains pipe SVG assets**: verify `SvgPicture` widgets exist in the tree (find by type)
- **Top pipe positioned from top**: verify a `Positioned` with `top: 0` and correct height exists
- **Bottom pipe positioned correctly**: verify a `Positioned` with `top: gapBottom` and correct height exists
- **Widget has correct overall width**: verify `SizedBox` width equals `pipeCapWidth`

## Dependencies
- Task 1 (GameConstants — pipe dimensions)
- Task 2 (Pipe — for understanding gap parameters, though widget takes raw doubles)

## Test Plan
- **File**: `test/pipe_widget_test.dart`
- ~5 widget tests
- Uses `flutter_test` with `pumpWidget`

## Notes
- The widget takes raw doubles rather than a `Pipe` object to keep it a pure rendering component.
- Following project rules: no nested construction — each sub-widget is declared as a variable before being passed.
- The pipe body SVG is stretched with `BoxFit.fill` to cover the full segment height.
- The top pipe cap sits at the bottom of the top segment (closest to gap). The bottom pipe cap sits at the top of the bottom segment (closest to gap) and is flipped vertically.
- Width is `pipeCapWidth` (60px) since the cap is wider than the body (52px) and the cap overhangs.
