import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  const assetDir = 'assets/images';

  const svgFiles = [
    'background.svg',
    'ground.svg',
    'clouds.svg',
    'bird_up.svg',
    'bird_mid.svg',
    'bird_down.svg',
    'pipe.svg',
    'pipe_top.svg',
  ];

  group('SVG asset existence', () {
    for (final fileName in svgFiles) {
      test('$fileName exists in $assetDir', () {
        final file = File('$assetDir/$fileName');
        expect(file.existsSync(), isTrue,
            reason: '$fileName should exist in $assetDir');
      });
    }
  });

  group('SVG validity', () {
    for (final fileName in svgFiles) {
      group(fileName, () {
        late String content;

        setUp(() {
          final file = File('$assetDir/$fileName');
          content = file.readAsStringSync();
        });

        test('is parseable as XML with <svg> root element', () {
          // Check that the content contains an opening <svg tag
          final svgTagPattern = RegExp(r'<svg[\s>]');
          expect(svgTagPattern.hasMatch(content), isTrue,
              reason: '$fileName should contain an <svg> root element');

          // Check that the content contains a closing </svg> tag
          expect(content.contains('</svg>'), isTrue,
              reason: '$fileName should contain a closing </svg> tag');

          // Verify the <svg is the first element (ignoring XML declarations)
          final trimmed = content.trimLeft();
          final firstElementMatch = RegExp(r'^(<\?[^?]*\?>[\s]*)*<svg[\s>]');
          expect(firstElementMatch.hasMatch(trimmed), isTrue,
              reason: '$fileName should have <svg> as its root element');
        });

        test('has a viewBox attribute', () {
          final viewBoxPattern = RegExp(r'viewBox\s*=\s*"[^"]*"');
          final match = viewBoxPattern.firstMatch(content);
          expect(match, isNotNull,
              reason: '$fileName should have a viewBox attribute');

          // Extract the viewBox value and ensure it's not empty
          final viewBoxValuePattern =
              RegExp(r'viewBox\s*=\s*"([^"]+)"');
          final valueMatch = viewBoxValuePattern.firstMatch(content);
          expect(valueMatch, isNotNull,
              reason: '$fileName viewBox should not be empty');
          expect(valueMatch!.group(1)!.trim(), isNotEmpty,
              reason: '$fileName viewBox value should not be blank');
        });
      });
    }
  });
}
