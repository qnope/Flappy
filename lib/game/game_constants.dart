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

  // Parallax scroll speeds (pixels per second)
  static const double groundScrollSpeed = 120.0;
  static const double cloudsScrollSpeed = 30.0;

  // Pipe dimensions (based on SVG viewBox: pipe 52x320, pipe_top 60x26)
  static const double pipeWidth = 52.0;
  static const double pipeCapWidth = 60.0;
  static const double pipeCapHeight = 26.0;

  // Pipe gap
  static const double gapMinSize = 120.0;
  static const double gapMaxSize = 180.0;
  static const double gapMinCenterMargin = 60.0;

  // Pipe pool and spacing
  static const int pipePoolSize = 4;
  static const double pipeSpacing = 200.0;
  static const double firstPipeOffset = 350.0;
}
