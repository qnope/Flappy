enum GamePhase {
  idle,     // before first tap, bird bobs at center
  playing,  // game loop active, gravity on
  dying,    // bird hit a pipe, falling to ground, no input
  gameOver, // bird on ground, game over overlay shown
}
