import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flappy/game/game_assets.dart';
import 'package:flappy/game/scrolling_layer_widget.dart';

void main() {
  group('ScrollingLayerWidget', () {
    Widget buildTestApp({
      required double scrollOffset,
      BoxFit? fit,
    }) {
      final layer = ScrollingLayerWidget(
        assetPath: GameAssets.ground,
        scrollOffset: scrollOffset,
        fit: fit ?? BoxFit.cover,
      );
      final sizedWidget = SizedBox(width: 400, height: 100, child: layer);
      return MaterialApp(
        home: Scaffold(body: Center(child: sizedWidget)),
      );
    }

    // The widget uses a Row with two full-width tiles that intentionally
    // overflows, clipped by ClipRect. We consume the expected overflow error.
    void consumeOverflowError(WidgetTester tester) {
      final exception = tester.takeException();
      if (exception != null) {
        expect(exception, isA<FlutterError>());
        expect(
          (exception as FlutterError).message,
          contains('overflowed'),
        );
      }
    }

    testWidgets('renders with valid SVG asset', (tester) async {
      await tester.pumpWidget(buildTestApp(
        scrollOffset: 0.0,
        fit: BoxFit.fitWidth,
      ));
      await tester.pump();
      consumeOverflowError(tester);
      expect(find.byType(ScrollingLayerWidget), findsOneWidget);
    });

    testWidgets('renders two SVG tiles', (tester) async {
      await tester.pumpWidget(buildTestApp(
        scrollOffset: 0.0,
        fit: BoxFit.fitWidth,
      ));
      await tester.pump();
      consumeOverflowError(tester);
      expect(find.byType(SvgPicture), findsNWidgets(2));
    });

    testWidgets('clips overflow with ClipRect', (tester) async {
      await tester.pumpWidget(buildTestApp(
        scrollOffset: 0.0,
        fit: BoxFit.fitWidth,
      ));
      await tester.pump();
      consumeOverflowError(tester);
      expect(find.byType(ClipRect), findsOneWidget);
    });

    testWidgets('renders with non-zero scroll offset', (tester) async {
      await tester.pumpWidget(buildTestApp(scrollOffset: 50.0));
      await tester.pump();
      consumeOverflowError(tester);
      expect(find.byType(ScrollingLayerWidget), findsOneWidget);
    });
  });
}
