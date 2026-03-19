import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ScrollingLayerWidget extends StatelessWidget {
  final String assetPath;
  final double scrollOffset;
  final BoxFit fit;

  const ScrollingLayerWidget({
    super.key,
    required this.assetPath,
    required this.scrollOffset,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final tileWidth = constraints.maxWidth;
        final wrappedOffset = scrollOffset % tileWidth;

        final tile1 = SvgPicture.asset(
          assetPath,
          width: tileWidth,
          fit: fit,
        );

        final sizedTile1 = SizedBox(width: tileWidth, child: tile1);

        final tile2 = SvgPicture.asset(
          assetPath,
          width: tileWidth,
          fit: fit,
        );

        final sizedTile2 = SizedBox(width: tileWidth, child: tile2);

        final row = Row(
          children: [sizedTile1, sizedTile2],
        );

        final translated = Transform.translate(
          offset: Offset(-wrappedOffset, 0),
          child: row,
        );

        final clipped = ClipRect(child: translated);

        return clipped;
      },
    );
  }
}
