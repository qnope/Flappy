import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flappy/game/game_constants.dart';
import 'package:flappy/game/pipe_widget.dart';

Widget createTestWidget() {
  return MaterialApp(
    home: Scaffold(
      body: Stack(
        children: [
          PipeWidget(
            gapCenterY: 250,
            gapSize: 140,
            screenHeight: 600,
          ),
        ],
      ),
    ),
  );
}

void main() {
  group('PipeWidget', () {
    testWidgets('renders without error', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      expect(find.byType(PipeWidget), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('contains pipe SVG assets', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      final svgFinder = find.byType(SvgPicture);
      // 4 SvgPicture widgets: top body + top cap + bottom cap + bottom body
      expect(svgFinder, findsNWidgets(4));

      final svgWidgets = tester.widgetList<SvgPicture>(svgFinder).toList();
      final assetNames = svgWidgets
          .map((svg) => svg.bytesLoader)
          .whereType<SvgAssetLoader>()
          .map((loader) => loader.assetName)
          .toList();

      expect(assetNames, contains('assets/images/pipe.svg'));
      expect(assetNames, contains('assets/images/pipe_top.svg'));
    });

    testWidgets('top pipe positioned from top', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      const gapTop = 250.0 - 140.0 / 2; // 180.0

      final positionedFinder = find.byType(Positioned);
      final positionedWidgets =
          tester.widgetList<Positioned>(positionedFinder).toList();

      final topPositioned = positionedWidgets.firstWhere(
        (p) => p.top == 0 && p.height == gapTop,
      );

      expect(topPositioned.top, equals(0));
      expect(topPositioned.height, equals(gapTop));
    });

    testWidgets('bottom pipe positioned correctly', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      const gapBottom = 250.0 + 140.0 / 2; // 320.0

      final positionedFinder = find.byType(Positioned);
      final positionedWidgets =
          tester.widgetList<Positioned>(positionedFinder).toList();

      final bottomPositioned = positionedWidgets.firstWhere(
        (p) => p.top == gapBottom && p.bottom == 0,
      );

      expect(bottomPositioned.top, equals(gapBottom));
      expect(bottomPositioned.bottom, equals(0));
    });

    testWidgets('widget has correct overall width', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      final sizedBoxFinder = find.byWidgetPredicate(
        (widget) =>
            widget is SizedBox &&
            widget.width == GameConstants.pipeCapWidth &&
            widget.height == 600,
      );

      expect(sizedBoxFinder, findsOneWidget);
    });
  });
}
