import 'package:flutter_test/flutter_test.dart';
import 'package:flappy/game/bird.dart';
import 'package:flappy/game/game_constants.dart';
import 'package:flappy/game/wing.dart';

void main() {
  group('Bird', () {
    test('initial state has zero velocity and correct position', () {
      final bird = Bird(posX: 50, posY: 100);
      expect(bird.posX, equals(50.0));
      expect(bird.posY, equals(100.0));
      expect(bird.velocityY, equals(0.0));
      expect(bird.currentWing, equals(Wing.mid));
    });

    test('update: gravity increases downward velocity', () {
      final bird = Bird(posX: 50, posY: 100);
      bird.update(0.016, GameConstants.gravity);
      expect(bird.velocityY, greaterThan(0));
    });

    test('update: gravity moves bird downward', () {
      final bird = Bird(posX: 50, posY: 100);
      bird.update(0.016, GameConstants.gravity);
      expect(bird.posY, greaterThan(100));
    });

    test('jump: sets upward velocity', () {
      final bird = Bird(posX: 50, posY: 100);
      bird.jump(GameConstants.jumpVelocity);
      expect(bird.velocityY, equals(GameConstants.jumpVelocity));
    });

    test('jump: replaces velocity, not additive', () {
      final bird = Bird(posX: 50, posY: 100, velocityY: 200);
      bird.jump(GameConstants.jumpVelocity);
      expect(bird.velocityY, equals(GameConstants.jumpVelocity));
    });

    test('clampToGround: clamps position and zeros velocity when at ground',
        () {
      final bird = Bird(posX: 50, posY: 450);
      bird.clampToGround(460, 36);
      expect(bird.posY, closeTo(424, 0.001));
      expect(bird.velocityY, equals(0.0));
    });

    test('clampToGround: returns true when at or below ground', () {
      final bird = Bird(posX: 50, posY: 450);
      final hit = bird.clampToGround(460, 36);
      expect(hit, isTrue);
    });

    test('clampToGround: returns false when above ground', () {
      final bird = Bird(posX: 50, posY: 100);
      final hit = bird.clampToGround(460, 36);
      expect(hit, isFalse);
    });

    test('rotation: returns negative value when rising', () {
      final bird = Bird(posX: 50, posY: 100);
      bird.jump(GameConstants.jumpVelocity);
      expect(bird.rotation, lessThan(0));
    });

    test('rotation: returns positive value when falling', () {
      final bird = Bird(posX: 50, posY: 100, velocityY: 300);
      expect(bird.rotation, greaterThan(0));
    });

    test('rotation: returns 0 when stationary', () {
      final bird = Bird(posX: 50, posY: 100);
      expect(bird.rotation, equals(0.0));
    });

    test('rotation: clamped to maxUpRotation when rising fast', () {
      final bird = Bird(posX: 50, posY: 100);
      bird.jump(GameConstants.jumpVelocity);
      expect(bird.rotation, equals(GameConstants.maxUpRotation));
    });

    test('rotation: clamped to maxDownRotation when falling fast', () {
      final bird = Bird(posX: 50, posY: 100, velocityY: 1000);
      expect(bird.rotation, equals(GameConstants.maxDownRotation));
    });

    test('currentWing: can be set to any Wing value', () {
      final bird = Bird(posX: 50, posY: 100);
      expect(bird.currentWing, equals(Wing.mid));

      bird.currentWing = Wing.up;
      expect(bird.currentWing, equals(Wing.up));

      bird.currentWing = Wing.down;
      expect(bird.currentWing, equals(Wing.down));

      bird.currentWing = Wing.mid;
      expect(bird.currentWing, equals(Wing.mid));
    });

    test('multiple frames accumulate velocity', () {
      final bird = Bird(posX: 50, posY: 100);
      double previousVelocity = 0;
      for (int i = 0; i < 10; i++) {
        bird.update(0.016, GameConstants.gravity);
        expect(bird.velocityY, greaterThan(previousVelocity));
        previousVelocity = bird.velocityY;
      }
    });
  });
}
