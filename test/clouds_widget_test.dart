import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flappy/game/clouds_widget.dart';
import 'package:flappy/game/scrolling_layer_widget.dart';

void main() {
  group('CloudsWidget', () {
    testWidgets('renders with scrollOffset 0.0 without errors',
        (tester) async {
      final cloudsWidget = const CloudsWidget(scrollOffset: 0.0);
      final sizedBox = SizedBox(
        width: 400,
        height: 300,
        child: cloudsWidget,
      );
      final app = MaterialApp(home: Scaffold(body: sizedBox));

      await tester.pumpWidget(app);
      await tester.pump();

      expect(find.byType(CloudsWidget), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('contains ScrollingLayerWidget in widget tree',
        (tester) async {
      final cloudsWidget = const CloudsWidget(scrollOffset: 0.0);
      final sizedBox = SizedBox(
        width: 400,
        height: 300,
        child: cloudsWidget,
      );
      final app = MaterialApp(home: Scaffold(body: sizedBox));

      await tester.pumpWidget(app);
      await tester.pump();

      expect(find.byType(ScrollingLayerWidget), findsOneWidget);
    });

    testWidgets('renders two SvgPicture tiles', (tester) async {
      final cloudsWidget = const CloudsWidget(scrollOffset: 0.0);
      final sizedBox = SizedBox(
        width: 400,
        height: 300,
        child: cloudsWidget,
      );
      final app = MaterialApp(home: Scaffold(body: sizedBox));

      await tester.pumpWidget(app);
      await tester.pump();

      expect(find.byType(SvgPicture), findsNWidgets(2));

      final svgWidget = tester.widget<SvgPicture>(
        find.byType(SvgPicture).first,
      );
      final bytesLoader = svgWidget.bytesLoader;
      expect(bytesLoader, isA<SvgAssetLoader>());
      expect(
        (bytesLoader as SvgAssetLoader).assetName,
        equals('assets/images/clouds.svg'),
      );
    });
  });
}
