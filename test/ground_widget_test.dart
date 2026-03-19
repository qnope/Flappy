import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flappy/game/ground_widget.dart';

void main() {
  group('GroundWidget', () {
    testWidgets('renders SvgPicture widgets for scrolling ground tiles', (tester) async {
      final app = MaterialApp(
        home: Scaffold(
          body: const GroundWidget(scrollOffset: 0.0),
        ),
      );

      await tester.pumpWidget(app);
      await tester.pump();

      final svgFinder = find.byType(SvgPicture);
      expect(svgFinder, findsAtLeastNWidgets(1));

      final svgWidget = tester.widget<SvgPicture>(svgFinder.first);
      final bytesLoader = svgWidget.bytesLoader;
      expect(bytesLoader, isA<SvgAssetLoader>());
      expect(
        (bytesLoader as SvgAssetLoader).assetName,
        equals('assets/images/ground.svg'),
      );
    });

    testWidgets('renders without error inside a constrained container',
        (tester) async {
      final constrainedGround = SizedBox(
        width: 300,
        height: 100,
        child: const GroundWidget(scrollOffset: 0.0),
      );

      final app = MaterialApp(
        home: Scaffold(
          body: Center(child: constrainedGround),
        ),
      );

      await tester.pumpWidget(app);
      await tester.pump();

      expect(find.byType(GroundWidget), findsOneWidget);
      expect(find.byType(SvgPicture), findsAtLeastNWidgets(1));
      expect(tester.takeException(), isNull);
    });
  });
}
