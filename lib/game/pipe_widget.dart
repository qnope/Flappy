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
