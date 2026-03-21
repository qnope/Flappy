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
      screenWidth: 360,
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

  group('Pipe integration', () {
    test('pipe pool is created on initialize', () {
      expect(controller.pipePool.pipes.length, equals(GameConstants.pipePoolSize));
    });

    test('pipes move at ground scroll speed', () {
      final initialPosX = controller.pipePool.pipes[0].posX;
      controller.update(0.05);
      final expectedDistance = GameConstants.groundScrollSpeed * 0.05;
      expect(controller.pipePool.pipes[0].posX, closeTo(initialPosX - expectedDistance, 0.001));
    });

    test('pipes reset when transitioning from idle to playing', () {
      for (int i = 0; i < 50; i++) {
        controller.update(0.016);
      }
      final posXBeforeReset = controller.pipePool.pipes[0].posX;

      controller.onTap(); // idle -> playing, triggers reset
      final posXAfterReset = controller.pipePool.pipes[0].posX;

      expect(posXAfterReset, greaterThan(posXBeforeReset));
    });

    test('pipes do not reset on subsequent taps (jumps)', () {
      controller.onTap(); // idle -> playing
      controller.update(0.016);
      final posXBefore = controller.pipePool.pipes[0].posX;
      controller.onTap(); // jump
      final posXAfter = controller.pipePool.pipes[0].posX;
      expect(posXAfter, equals(posXBefore));
    });
  });

  group('Collision detection', () {
    test('pipe collision triggers dying', () {
      controller.onTap(); // idle -> playing
      // Position bird above the gap so it collides with the top pipe.
      // Bird is centered at x=180 (screenWidth/2).
      // Place pipe at x=180 so horizontal overlap occurs.
      // Set gap well below the bird so the bird is above gapTop.
      final pipe = controller.pipePool.pipes[0];
      pipe.posX = 180;
      pipe.gapCenterY = 350;
      pipe.gapSize = 60;
      // bird.posY = 200, birdBottom = 236, gapTop = 320 -> bird is above gap

      controller.update(0.016);
      expect(controller.gamePhase, equals(GamePhase.dying));
    });

    test('no collision when bird is in gap', () {
      controller.onTap(); // idle -> playing
      // Place pipe at bird's x, with gap encompassing the bird's y range.
      // bird.posY ~ 200 after jump+one frame, birdBottom ~ 236
      // Set gap large enough to contain bird.
      final pipe = controller.pipePool.pipes[0];
      pipe.posX = 180;
      pipe.gapCenterY = 218; // gap center near bird center
      pipe.gapSize = 180; // gapTop = 128, gapBottom = 308 -> bird (200-236) is inside

      controller.update(0.016);
      expect(controller.gamePhase, equals(GamePhase.playing));
    });

    test('ground collision during playing triggers gameOver', () {
      controller.onTap(); // idle -> playing
      // Move all pipes far away so no pipe collision interferes.
      for (final pipe in controller.pipePool.pipes) {
        pipe.posX = 9999;
      }
      // Give bird a very high downward velocity to hit ground quickly.
      controller.bird.velocityY = 10000;
      controller.update(0.05);
      expect(controller.gamePhase, equals(GamePhase.gameOver));
    });

    test('dying bird falls to ground then gameOver', () {
      controller.onTap(); // idle -> playing
      controller.gamePhase = GamePhase.dying;
      controller.bird.velocityY = 0;
      controller.bird.posY = 200;

      // Update enough frames for bird to fall to ground (groundTopY=400)
      for (int i = 0; i < 200; i++) {
        controller.update(0.016);
        if (controller.gamePhase == GamePhase.gameOver) break;
      }
      expect(controller.gamePhase, equals(GamePhase.gameOver));
      expect(
        controller.bird.posY + GameConstants.birdHeight,
        closeTo(controller.groundTopY, 0.001),
      );
    });

    test('dying phase stops scrolling', () {
      controller.onTap(); // idle -> playing
      controller.update(0.016); // one frame of playing
      final offsetBefore = controller.groundScrollOffset;

      controller.gamePhase = GamePhase.dying;
      controller.update(0.016);

      expect(controller.groundScrollOffset, equals(offsetBefore));
    });

    test('tap ignored during dying', () {
      controller.onTap(); // idle -> playing
      controller.gamePhase = GamePhase.dying;

      controller.onTap();
      expect(controller.gamePhase, equals(GamePhase.dying));
    });
  });

  group('Game over reset', () {
    test('tap during gameOver resets to idle', () {
      controller.onTap(); // idle -> playing
      controller.gamePhase = GamePhase.gameOver;

      controller.onTap();
      expect(controller.gamePhase, equals(GamePhase.idle));
    });

    test('bird position resets after gameOver', () {
      controller.onTap(); // idle -> playing
      controller.bird.posY = 350;
      controller.bird.velocityY = 500;
      controller.gamePhase = GamePhase.gameOver;

      controller.onTap();
      expect(controller.bird.posY, equals(200));
      expect(controller.bird.velocityY, equals(0));
    });

    test('score resets after gameOver', () {
      controller.onTap(); // idle -> playing
      controller.score = 10;
      controller.gamePhase = GamePhase.gameOver;

      controller.onTap();
      expect(controller.score, equals(0));
    });

    test('pipes reset after gameOver', () {
      controller.onTap(); // idle -> playing
      // Move pipes by updating a few frames
      for (int i = 0; i < 50; i++) {
        controller.update(0.016);
        if (controller.gamePhase != GamePhase.playing) break;
      }
      controller.gamePhase = GamePhase.gameOver;

      controller.onTap();
      // First pipe should be at screenWidth + firstPipeOffset = 360 + 350 = 710
      expect(controller.pipePool.pipes[0].posX, equals(710));
    });

    test('full cycle: idle -> playing -> dying -> gameOver -> idle', () {
      expect(controller.gamePhase, equals(GamePhase.idle));

      controller.onTap(); // idle -> playing
      expect(controller.gamePhase, equals(GamePhase.playing));

      controller.gamePhase = GamePhase.dying; // simulate collision
      controller.bird.posY = 350;
      controller.bird.velocityY = 500;

      // Update until bird hits ground and transitions to gameOver
      for (int i = 0; i < 200; i++) {
        controller.update(0.016);
        if (controller.gamePhase == GamePhase.gameOver) break;
      }
      expect(controller.gamePhase, equals(GamePhase.gameOver));

      controller.onTap(); // gameOver -> idle
      expect(controller.gamePhase, equals(GamePhase.idle));
    });
  });

  group('Score tracking', () {
    test('score starts at 0', () {
      expect(controller.score, equals(0));
    });

    test('score increments when bird passes pipe', () {
      controller.onTap(); // idle -> playing
      // Move all pipes far away so no collision interferes.
      for (final pipe in controller.pipePool.pipes) {
        pipe.posX = 9999;
        pipe.gapCenterY = 218;
        pipe.gapSize = 180;
      }
      // Place first pipe so its right edge is left of bird center (180).
      // posX=100 -> right edge = 100 + 30 = 130 < 180
      final pipe = controller.pipePool.pipes[0];
      pipe.posX = 100;

      controller.update(0.016);
      expect(controller.score, equals(1));
    });

    test('pipe scored only once', () {
      controller.onTap(); // idle -> playing
      // Move all pipes far away so no collision interferes.
      for (final pipe in controller.pipePool.pipes) {
        pipe.posX = 9999;
        pipe.gapCenterY = 218;
        pipe.gapSize = 180;
      }
      // Place first pipe so its right edge is left of bird center.
      final pipe = controller.pipePool.pipes[0];
      pipe.posX = 100;

      controller.update(0.016);
      expect(controller.score, equals(1));

      // Multiple updates should not increment score again.
      controller.update(0.016);
      controller.update(0.016);
      controller.update(0.016);
      expect(controller.score, equals(1));
    });

    test('score resets on new game', () {
      controller.onTap(); // idle -> playing
      controller.gamePhase = GamePhase.idle;
      controller.score = 5;

      controller.onTap(); // idle -> playing again
      expect(controller.score, equals(0));
    });
  });
}
