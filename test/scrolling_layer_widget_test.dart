import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flappy/game/game_assets.dart';
import 'package:flappy/game/scrolling_layer_widget.dart';

void main() {
  group('ScrollingLayerWidget', () {
    testWidgets('renders with valid SVG asset', (tester) async {
      final widget = ScrollingLayerWidget(
        assetPath: GameAssets.ground,
        scrollOffset: 0.0,
        fit: BoxFit.fitWidth,
      );
      await tester.pumpWidget(MaterialApp(
        home: SizedBox(width: 400, height: 100, child: widget),
      ));
      expect(find.byType(ScrollingLayerWidget), findsOneWidget);
    });

    testWidgets('renders two SVG tiles', (tester) async {
      final widget = ScrollingLayerWidget(
        assetPath: GameAssets.ground,
        scrollOffset: 0.0,
        fit: BoxFit.fitWidth,
      );
      await tester.pumpWidget(MaterialApp(
        home: SizedBox(width: 400, height: 100, child: widget),
      ));
      expect(find.byType(SvgPicture), findsNWidgets(2));
    });

    testWidgets('clips overflow with UnconstrainedBox clipBehavior',
        (tester) async {
      final widget = ScrollingLayerWidget(
        assetPath: GameAssets.ground,
        scrollOffset: 0.0,
        fit: BoxFit.fitWidth,
      );
      await tester.pumpWidget(MaterialApp(
        home: SizedBox(width: 400, height: 100, child: widget),
      ));
      final box = tester.widget<UnconstrainedBox>(
        find.byType(UnconstrainedBox),
      );
      expect(box.clipBehavior, equals(Clip.hardEdge));
    });

    testWidgets('renders with non-zero scroll offset', (tester) async {
      final widget = ScrollingLayerWidget(
        assetPath: GameAssets.ground,
        scrollOffset: 50.0,
      );
      await tester.pumpWidget(MaterialApp(
        home: SizedBox(width: 400, height: 100, child: widget),
      ));
      expect(find.byType(ScrollingLayerWidget), findsOneWidget);
    });
  });
}
