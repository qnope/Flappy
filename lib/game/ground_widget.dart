import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'game_assets.dart';

class GroundWidget extends StatelessWidget {
  const GroundWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      GameAssets.ground,
      fit: BoxFit.fitWidth,
    );
  }
}
