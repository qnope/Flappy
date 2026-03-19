import 'game_constants.dart';
import 'wing.dart';

class Bird {
  double posY;
  double velocityY;
  Wing currentWing;

  Bird({
    required this.posY,
    this.velocityY = 0.0,
    this.currentWing = Wing.mid,
  });

  void update(double dt, double gravity) {
    velocityY += gravity * dt;
    posY += velocityY * dt;
  }

  void jump(double jumpVelocity) {
    velocityY = jumpVelocity;
  }

  bool clampToGround(double groundTopY, double birdHeight) {
    final birdBottom = posY + birdHeight;
    if (birdBottom >= groundTopY) {
      posY = groundTopY - birdHeight;
      velocityY = 0.0;
      return true;
    }
    return false;
  }

  double get rotation {
    if (velocityY <= 0) {
      final ratio = (velocityY / GameConstants.jumpVelocity).clamp(0.0, 1.0);
      return GameConstants.maxUpRotation * ratio;
    } else {
      final ratio =
          (velocityY / GameConstants.maxFallVelocity).clamp(0.0, 1.0);
      return GameConstants.maxDownRotation * ratio;
    }
  }
}
