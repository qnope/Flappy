class BirdPhysics {
  double posY; // vertical position (pixels from top)
  double velocityY; // vertical velocity (pixels/sec, negative = up)

  BirdPhysics({required this.posY, this.velocityY = 0.0});

  /// Apply gravity and update position for the given delta time
  void update(double dt, double gravity) {
    velocityY += gravity * dt;
    posY += velocityY * dt;
  }

  /// Set velocity to jump value (replaces current velocity)
  void jump(double jumpVelocity) {
    velocityY = jumpVelocity;
  }

  /// Clamp bird to stay above ground
  /// Returns true if bird hit the ground
  bool clampToGround(double groundTopY, double birdHeight) {
    final birdBottom = posY + birdHeight;
    if (birdBottom >= groundTopY) {
      posY = groundTopY - birdHeight;
      velocityY = 0.0;
      return true;
    }
    return false;
  }
}
