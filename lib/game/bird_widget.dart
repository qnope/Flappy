import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'game_constants.dart';

class BirdWidget extends StatelessWidget {
  final double rotation; // in degrees
  final String spritePath; // e.g. 'assets/images/bird_mid.svg'

  const BirdWidget({
    super.key,
    required this.rotation,
    required this.spritePath,
  });

  @override
  Widget build(BuildContext context) {
    final svgImage = SvgPicture.asset(
      spritePath,
      width: GameConstants.birdWidth,
      height: GameConstants.birdHeight,
    );

    return Transform.rotate(
      angle: rotation * pi / 180,
      child: svgImage,
    );
  }
}
