import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'game_assets.dart';

class BackgroundWidget extends StatelessWidget {
  const BackgroundWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      GameAssets.background,
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.cover,
    );
  }
}
