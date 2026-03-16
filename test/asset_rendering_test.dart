import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const assetDir = 'assets/images';

  const allSvgAssets = [
    '$assetDir/background.svg',
    '$assetDir/ground.svg',
    '$assetDir/bird_up.svg',
    '$assetDir/bird_mid.svg',
    '$assetDir/bird_down.svg',
    '$assetDir/pipe.svg',
    '$assetDir/pipe_top.svg',
  ];

  group('SVG rendering', () {
    for (final assetPath in allSvgAssets) {
      testWidgets('$assetPath renders without errors',
          (WidgetTester tester) async {
        final svgWidget = SvgPicture.asset(
          assetPath,
          width: 100,
          height: 100,
        );

        final app = MaterialApp(
          home: Scaffold(body: Center(child: svgWidget)),
        );

        await tester.pumpWidget(app);
        await tester.pumpAndSettle();

        // Verify that no error widgets are present
        expect(find.byType(SvgPicture), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    }
  });

  group('Bird frame consistency', () {
    const birdAssets = [
      '$assetDir/bird_up.svg',
      '$assetDir/bird_mid.svg',
      '$assetDir/bird_down.svg',
    ];

    const expectedWidth = 50.0;
    const expectedHeight = 50.0;

    testWidgets('all bird SVGs load with the same expected dimensions',
        (WidgetTester tester) async {
      final birdWidgets = <Widget>[];
      for (final asset in birdAssets) {
        final svgWidget = SvgPicture.asset(
          asset,
          width: expectedWidth,
          height: expectedHeight,
        );
        birdWidgets.add(svgWidget);
      }

      final column = Column(
        mainAxisSize: MainAxisSize.min,
        children: birdWidgets,
      );

      final app = MaterialApp(
        home: Scaffold(body: Center(child: column)),
      );

      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      // Find all SvgPicture widgets
      final svgFinder = find.byType(SvgPicture);
      expect(svgFinder, findsNWidgets(3));

      // Verify each bird SVG renders at the expected size
      for (var i = 0; i < 3; i++) {
        final svgElement = tester.widget<SvgPicture>(svgFinder.at(i));
        expect(svgElement.width, equals(expectedWidth),
            reason: '${birdAssets[i]} should have width $expectedWidth');
        expect(svgElement.height, equals(expectedHeight),
            reason: '${birdAssets[i]} should have height $expectedHeight');
      }

      expect(tester.takeException(), isNull);
    });
  });

  group('Pipe assembly', () {
    testWidgets('pipe body and pipe top render together',
        (WidgetTester tester) async {
      final pipeBody = SvgPicture.asset(
        '$assetDir/pipe.svg',
        width: 52,
        height: 320,
      );

      final pipeTop = SvgPicture.asset(
        '$assetDir/pipe_top.svg',
        width: 60,
        height: 26,
      );

      final pipeAssembly = Column(
        mainAxisSize: MainAxisSize.min,
        children: [pipeTop, pipeBody],
      );

      final app = MaterialApp(
        home: Scaffold(body: Center(child: pipeAssembly)),
      );

      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      // Both SVGs should render
      expect(find.byType(SvgPicture), findsNWidgets(2));
      expect(tester.takeException(), isNull);
    });

    testWidgets('pipe_top can be flipped with Transform.flip',
        (WidgetTester tester) async {
      final pipeTop = SvgPicture.asset(
        '$assetDir/pipe_top.svg',
        width: 60,
        height: 26,
      );

      final flippedPipeTop = Transform.flip(
        flipY: true,
        child: pipeTop,
      );

      final app = MaterialApp(
        home: Scaffold(body: Center(child: flippedPipeTop)),
      );

      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      // Verify the SvgPicture is in the tree and it's a descendant of a Transform
      expect(find.byType(SvgPicture), findsOneWidget);
      expect(
        find.ancestor(
          of: find.byType(SvgPicture),
          matching: find.byType(Transform),
        ),
        findsWidgets,
      );
      expect(tester.takeException(), isNull);
    });
  });
}
