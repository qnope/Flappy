import 'package:flutter_test/flutter_test.dart';
import 'package:flappy/game/pipe.dart';

void main() {
  group('Pipe', () {
    test('gapTop computed correctly', () {
      final pipe = Pipe(posX: 100, gapCenterY: 300, gapSize: 140);
      expect(pipe.gapTop, equals(230));
    });

    test('gapBottom computed correctly', () {
      final pipe = Pipe(posX: 100, gapCenterY: 300, gapSize: 140);
      expect(pipe.gapBottom, equals(370));
    });

    test('constructor stores all fields', () {
      final pipe = Pipe(posX: 100, gapCenterY: 300, gapSize: 140);
      expect(pipe.posX, equals(100));
      expect(pipe.gapCenterY, equals(300));
      expect(pipe.gapSize, equals(140));
    });

    test('scored defaults to false', () {
      final pipe = Pipe(posX: 100, gapCenterY: 300, gapSize: 140);
      expect(pipe.scored, isFalse);
    });

    test('scored can be set', () {
      final pipe = Pipe(posX: 100, gapCenterY: 300, gapSize: 140);
      pipe.scored = true;
      expect(pipe.scored, isTrue);
    });
  });
}
