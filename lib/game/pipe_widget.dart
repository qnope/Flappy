import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'game_assets.dart';
import 'game_constants.dart';

class PipeWidget extends StatelessWidget {
  final double gapCenterY;
  final double gapSize;
  final double screenHeight;

  const PipeWidget({
    super.key,
    required this.gapCenterY,
    required this.gapSize,
    required this.screenHeight,
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
      bottom: 0,
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
    final body = SvgPicture.asset(
      GameAssets.pipe,
      width: GameConstants.pipeWidth,
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
        Expanded(child: body),
        cap,
      ],
    );
  }

  Widget _buildBottomPipe(double gapBottom) {
    final body = SvgPicture.asset(
      GameAssets.pipe,
      width: GameConstants.pipeWidth,
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
        Expanded(child: body),
      ],
    );
  }
}
