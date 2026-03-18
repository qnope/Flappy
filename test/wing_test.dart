import 'package:flutter_test/flutter_test.dart';
import 'package:flappy/game/wing.dart';

void main() {
  group('Wing enum', () {
    test('Wing.up.assetPath returns correct path', () {
      expect(Wing.up.assetPath, equals('assets/images/bird_up.svg'));
    });

    test('Wing.mid.assetPath returns correct path', () {
      expect(Wing.mid.assetPath, equals('assets/images/bird_mid.svg'));
    });

    test('Wing.down.assetPath returns correct path', () {
      expect(Wing.down.assetPath, equals('assets/images/bird_down.svg'));
    });

    test('animationSequence has 4 entries in correct order', () {
      expect(Wing.animationSequence, hasLength(4));
      expect(Wing.animationSequence[0], equals(Wing.up));
      expect(Wing.animationSequence[1], equals(Wing.mid));
      expect(Wing.animationSequence[2], equals(Wing.down));
      expect(Wing.animationSequence[3], equals(Wing.mid));
    });
  });
}
