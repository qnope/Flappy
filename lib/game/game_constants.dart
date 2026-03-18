class GameConstants {
  // Bird physics
  static const double gravity = 1200.0; // pixels/sec² downward
  static const double jumpVelocity = -400.0; // pixels/sec upward (negative = up)
  static const double maxFallVelocity = 600.0; // terminal velocity

  // Bird dimensions (based on SVG viewBox 34x24, scaled up)
  static const double birdWidth = 51.0;
  static const double birdHeight = 36.0;

  // Bird rotation
  static const double maxUpRotation = -25.0; // degrees when rising
  static const double maxDownRotation = 70.0; // degrees when falling

  // Ground height (based on SVG viewBox 336x112, proportional)
  static const double groundHeightRatio = 0.2; // ground takes 20% of screen height

  // Idle bobbing
  static const double bobAmplitude = 8.0; // pixels up/down
  static const double bobFrequency = 2.0; // cycles per second

  // Wing animation
  static const Duration wingFrameDuration = Duration(milliseconds: 150);
}
