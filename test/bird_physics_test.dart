import 'package:flutter_test/flutter_test.dart';
import 'package:flappy/game/bird_physics.dart';
import 'package:flappy/game/game_constants.dart';

void main() {
  group('BirdPhysics', () {
    test('initial state has zero velocity', () {
      final bird = BirdPhysics(posY: 100);
      expect(bird.velocityY, equals(0.0));
    });

    test('gravity increases downward velocity', () {
      final bird = BirdPhysics(posY: 100);
      bird.update(0.016, GameConstants.gravity);
      expect(bird.velocityY, greaterThan(0));
    });

    test('gravity moves bird downward', () {
      final bird = BirdPhysics(posY: 100);
      bird.update(0.016, GameConstants.gravity);
      expect(bird.posY, greaterThan(100));
    });

    test('jump sets upward velocity', () {
      final bird = BirdPhysics(posY: 100);
      bird.jump(GameConstants.jumpVelocity);
      expect(bird.velocityY, equals(GameConstants.jumpVelocity));
    });

    test('jump replaces velocity, not additive', () {
      final bird = BirdPhysics(posY: 100, velocityY: 200);
      bird.jump(GameConstants.jumpVelocity);
      expect(bird.velocityY, equals(GameConstants.jumpVelocity));
    });

    test('ground collision clamps position', () {
      final bird = BirdPhysics(posY: 450);
      bird.clampToGround(460, 36);
      expect(bird.posY, closeTo(424, 0.001));
      expect(bird.velocityY, equals(0.0));
    });

    test('ground collision returns true when at or below ground', () {
      final bird = BirdPhysics(posY: 450);
      final hit = bird.clampToGround(460, 36);
      expect(hit, isTrue);
    });

    test('no collision returns false when above ground', () {
      final bird = BirdPhysics(posY: 100);
      final hit = bird.clampToGround(460, 36);
      expect(hit, isFalse);
    });

    test('multiple frames accumulate velocity', () {
      final bird = BirdPhysics(posY: 100);
      double previousVelocity = 0;
      for (int i = 0; i < 10; i++) {
        bird.update(0.016, GameConstants.gravity);
        expect(bird.velocityY, greaterThan(previousVelocity));
        previousVelocity = bird.velocityY;
      }
    });
  });
}
