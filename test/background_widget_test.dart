import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flappy/game/background_widget.dart';

void main() {
  group('BackgroundWidget', () {
    testWidgets('renders an SvgPicture with the background asset',
        (WidgetTester tester) async {
      final app = MaterialApp(
        home: const Scaffold(body: BackgroundWidget()),
      );

      await tester.pumpWidget(app);
      await tester.pump();

      final svgFinder = find.byType(SvgPicture);
      expect(svgFinder, findsOneWidget);

      final svgWidget = tester.widget<SvgPicture>(svgFinder);
      final bytesLoader = svgWidget.bytesLoader;
      expect(bytesLoader, isA<SvgAssetLoader>());
      expect(
        (bytesLoader as SvgAssetLoader).assetName,
        equals('assets/images/background.svg'),
      );
    });

    testWidgets('can be placed inside a SizedBox and renders without error',
        (WidgetTester tester) async {
      final sizedBox = SizedBox(
        width: 300,
        height: 500,
        child: const BackgroundWidget(),
      );

      final app = MaterialApp(
        home: Scaffold(body: Center(child: sizedBox)),
      );

      await tester.pumpWidget(app);
      await tester.pump();

      expect(find.byType(BackgroundWidget), findsOneWidget);
      expect(find.byType(SvgPicture), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
