# Task 2: Create Pipe Model + Unit Tests

## Summary
Create a `Pipe` data class representing a single pipe pair (top + bottom) with its horizontal position and random gap parameters.

## Implementation Steps

### Step 1: Create `lib/game/pipe.dart`

```dart
class Pipe {
  double posX;       // horizontal center position in pixels
  double gapCenterY; // vertical center of the gap in pixels
  double gapSize;    // vertical gap size in pixels

  Pipe({
    required this.posX,
    required this.gapCenterY,
    required this.gapSize,
  });

  /// Top of the gap (upper edge of the opening)
  double get gapTop => gapCenterY - gapSize / 2;

  /// Bottom of the gap (lower edge of the opening)
  double get gapBottom => gapCenterY + gapSize / 2;
}
```

### Step 2: Create `test/pipe_test.dart`

Test cases:
- **gapTop computed correctly**: `Pipe(posX: 100, gapCenterY: 300, gapSize: 140)` → `gapTop == 230`
- **gapBottom computed correctly**: same pipe → `gapBottom == 370`
- **gapSize is stored**: verify constructor stores all fields

## Dependencies
- Task 1 (constants exist but not directly used by Pipe — Pipe is a plain data class)

## Test Plan
- **File**: `test/pipe_test.dart`
- 3 unit tests verifying computed getters and field storage

## Notes
- `Pipe` is a plain Dart class with no Flutter dependency — fully unit-testable.
- Random generation of gap values is handled by `PipePool` (task 3), not by `Pipe` itself. This keeps `Pipe` a simple data holder.
