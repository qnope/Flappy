import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'game_constants.dart';
import 'wing.dart';

class BirdWidget extends StatelessWidget {
  final double rotation; // in degrees
  final Wing wing;

  const BirdWidget({
    super.key,
    required this.rotation,
    required this.wing,
  });

  @override
  Widget build(BuildContext context) {
    final svgImage = SvgPicture.asset(
      wing.assetPath,
      width: GameConstants.birdWidth,
      height: GameConstants.birdHeight,
    );

    return Transform.rotate(
      angle: rotation * pi / 180,
      child: svgImage,
    );
  }
}
