import 'package:flutter/material.dart';

import 'game_assets.dart';
import 'scrolling_layer_widget.dart';

class GroundWidget extends StatelessWidget {
  final double scrollOffset;

  const GroundWidget({super.key, required this.scrollOffset});

  @override
  Widget build(BuildContext context) {
    return ScrollingLayerWidget(
      assetPath: GameAssets.ground,
      scrollOffset: scrollOffset,
      fit: BoxFit.fitWidth,
    );
  }
}
