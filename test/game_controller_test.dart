import 'package:flutter_test/flutter_test.dart';
import 'package:flappy/game/game_controller.dart';
import 'package:flappy/game/game_constants.dart';
import 'package:flappy/game/game_state.dart';
import 'package:flappy/game/wing.dart';

void main() {
  late GameController controller;

  setUp(() {
    controller = GameController();
    controller.initialize(
      birdStartY: 200,
      groundTopY: 400,
    );
  });

  group('State transitions', () {
    test('starts in idle phase', () {
      expect(controller.gamePhase, equals(GamePhase.idle));
    });

    test('onTap during idle transitions to playing', () {
      controller.onTap();
      expect(controller.gamePhase, equals(GamePhase.playing));
    });

    test('onTap during playing triggers jump', () {
      controller.onTap(); // idle -> playing
      final velocityAfterStart = controller.bird.velocityY;
      controller.update(0.016);
      controller.update(0.016);
      controller.update(0.016);
      // Velocity should have changed due to gravity
      final velocityBeforeJump = controller.bird.velocityY;
      expect(velocityBeforeJump, isNot(equals(velocityAfterStart)));

      controller.onTap(); // jump again
      expect(controller.bird.velocityY, equals(GameConstants.jumpVelocity));
    });
  });

  group('Idle behavior', () {
    test('update during idle oscillates bird Y (bobbing)', () {
      final initialY = controller.bird.posY;
      final yValues = <double>{};
      for (int i = 0; i < 100; i++) {
        controller.update(0.016);
        yValues.add(controller.bird.posY);
      }
      // Bird should move to different Y positions (bobbing)
      expect(yValues.length, greaterThan(1));
      // Should stay near initial position
      for (final y in yValues) {
        expect((y - initialY).abs(), lessThanOrEqualTo(GameConstants.bobAmplitude + 0.1));
      }
    });

    test('wing cycles through animation sequence during idle', () {
      final wings = <Wing>{};
      for (int i = 0; i < 100; i++) {
        controller.update(0.016);
        wings.add(controller.bird.currentWing);
      }
      expect(wings.length, greaterThan(1));
    });

    test('birdRotation returns 0.0 during idle', () {
      controller.update(0.016);
      expect(controller.birdRotation, equals(0.0));
    });
  });

  group('Playing behavior', () {
    test('update during playing applies gravity', () {
      controller.onTap();
      final initialY = controller.bird.posY;
      // Let gravity pull bird down over many frames
      for (int i = 0; i < 60; i++) {
        controller.update(0.016);
      }
      expect(controller.bird.posY, greaterThan(initialY));
    });

    test('wing cycles when rising, freezes to mid when falling', () {
      controller.onTap();
      // Right after jump, velocity is negative (rising)
      controller.update(0.016);
      expect(controller.bird.velocityY, lessThan(0));

      // Let bird start falling but not hit ground (use fewer frames)
      for (int i = 0; i < 30; i++) {
        controller.update(0.016);
      }
      expect(controller.bird.velocityY, greaterThan(0));
      expect(controller.bird.currentWing, equals(Wing.mid));
    });

    test('birdRotation is negative when rising, positive when falling', () {
      controller.onTap();
      controller.update(0.016);
      expect(controller.birdRotation, lessThan(0));

      // Let bird start falling but not hit ground
      for (int i = 0; i < 30; i++) {
        controller.update(0.016);
      }
      expect(controller.birdRotation, greaterThan(0));
    });
  });

  group('Ground collision', () {
    test('bird reaches ground and stops after many updates', () {
      controller.onTap();
      for (int i = 0; i < 200; i++) {
        controller.update(0.016);
      }
      final groundedY = controller.bird.posY;
      // Should be at ground level
      expect(
        groundedY + GameConstants.birdHeight,
        closeTo(controller.groundTopY, 0.001),
      );
      // More updates shouldn't change position
      for (int i = 0; i < 30; i++) {
        controller.update(0.016);
      }
      expect(controller.bird.posY, closeTo(groundedY, 0.001));
    });
  });

  group('Scroll offsets', () {
    test('scroll offsets start at zero', () {
      expect(controller.groundScrollOffset, 0.0);
      expect(controller.cloudsScrollOffset, 0.0);
    });

    test('scroll offsets update after update', () {
      controller.update(0.05);
      expect(controller.groundScrollOffset, GameConstants.groundScrollSpeed * 0.05);
      expect(controller.cloudsScrollOffset, GameConstants.cloudsScrollSpeed * 0.05);
    });

    test('scroll offsets update during idle phase', () {
      controller.update(0.016);
      expect(controller.groundScrollOffset, greaterThan(0.0));
      expect(controller.cloudsScrollOffset, greaterThan(0.0));
    });

    test('scroll offsets update during playing phase', () {
      controller.onTap(); // transition to playing
      controller.update(0.016);
      expect(controller.groundScrollOffset, greaterThan(0.0));
      expect(controller.cloudsScrollOffset, greaterThan(0.0));
    });

    test('scroll offsets unchanged when dt > 0.1', () {
      controller.update(0.2);
      expect(controller.groundScrollOffset, 0.0);
      expect(controller.cloudsScrollOffset, 0.0);
    });

    test('ground scrolls faster than clouds', () {
      controller.update(0.016);
      expect(controller.groundScrollOffset, greaterThan(controller.cloudsScrollOffset));
    });
  });

  group('Edge cases', () {
    test('update before initialize is a no-op', () {
      final freshController = GameController();
      // Should not throw
      freshController.update(0.016);
    });

    test('update with dt > 0.1 is skipped', () {
      final initialY = controller.bird.posY;
      controller.onTap();
      controller.update(0.2); // should be skipped
      expect(controller.bird.posY, equals(initialY));
    });
  });
}
