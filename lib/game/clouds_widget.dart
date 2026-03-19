import 'package:flutter/material.dart';
import 'game_assets.dart';
import 'scrolling_layer_widget.dart';

class CloudsWidget extends StatelessWidget {
  final double scrollOffset;

  const CloudsWidget({super.key, required this.scrollOffset});

  @override
  Widget build(BuildContext context) {
    return ScrollingLayerWidget(
      assetPath: GameAssets.clouds,
      scrollOffset: scrollOffset,
      fit: BoxFit.cover,
    );
  }
}
