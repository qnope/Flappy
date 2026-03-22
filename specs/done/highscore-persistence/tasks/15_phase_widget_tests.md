# Task 15: Widget Tests for Phase Widgets

## Summary
Write widget tests for GameLayersWidget and all four phase widgets, verifying correct rendering and content.

## Implementation Steps

1. **Create `test/game_layers_widget_test.dart`**:

   | Test | What is verified |
   |------|------------------|
   | Renders all layers | Background, clouds, ground, bird, pipe widgets present |
   | Renders overlays | Passed overlay widgets appear in stack |
   | Bird alignment | Bird positioned based on posY and screenHeight |
   | Pipe positioning | Pipes positioned at correct X coordinates |

2. **Create `test/idle_phase_widget_test.dart`**:

   | Test | What is verified |
   |------|------------------|
   | First launch | "Tap to start" visible, no leaderboard, no last score |
   | With scores | Leaderboard visible, last score shown |
   | Tap text | "Tap to start" always visible |
   | No empty leaderboard | Empty scores = no leaderboard rendered |

3. **Create `test/playing_phase_widget_test.dart`**:

   | Test | What is verified |
   |------|------------------|
   | Score display | Current score text visible |
   | Layers present | Background, bird, ground rendered |

4. **Create `test/dying_phase_widget_test.dart`**:

   | Test | What is verified |
   |------|------------------|
   | Score display | Score still visible during dying |
   | Layers present | Background, bird, ground rendered |

5. **Create `test/game_over_phase_widget_test.dart`**:

   | Test | What is verified |
   |------|------------------|
   | Game over text | "Game Over" visible |
   | Current score | Score displayed prominently |
   | Leaderboard | Top scores shown |
   | New high score | "New High Score!" shown when isNewHighScore = true |
   | No new high score | "New High Score!" not shown when isNewHighScore = false |
   | Restart hint | "Tap to restart" visible |
   | Highlight | Correct row highlighted in leaderboard |

## File Paths
- `test/game_layers_widget_test.dart` (new)
- `test/idle_phase_widget_test.dart` (new)
- `test/playing_phase_widget_test.dart` (new)
- `test/dying_phase_widget_test.dart` (new)
- `test/game_over_phase_widget_test.dart` (new)

## Dependencies
- Task 8, 9, 10, 11, 12 (all phase widgets must exist)

## Test Plan
- `flutter test test/game_layers_widget_test.dart` — pass
- `flutter test test/idle_phase_widget_test.dart` — pass
- `flutter test test/playing_phase_widget_test.dart` — pass
- `flutter test test/dying_phase_widget_test.dart` — pass
- `flutter test test/game_over_phase_widget_test.dart` — pass
