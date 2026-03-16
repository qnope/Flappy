# Task 07: Write Tests

## Summary

Write unit tests for asset existence/validity and widget tests for SVG rendering, as specified in the SPEC.

## Implementation Steps

1. **Create `test/asset_existence_test.dart`** (unit tests)
   - Test that all 7 SVG files exist in `assets/images/`:
     - `background.svg`
     - `ground.svg`
     - `bird_up.svg`
     - `bird_mid.svg`
     - `bird_down.svg`
     - `pipe.svg`
     - `pipe_top.svg`
   - Test that each file is valid SVG:
     - Parseable as XML
     - Has `<svg>` root element
     - Has a `viewBox` attribute

2. **Create `test/asset_rendering_test.dart`** (widget tests)
   - Test that each SVG renders without errors via `SvgPicture.asset()`
   - Test bird frame consistency: all 3 bird SVGs load with the same expected dimensions
   - Test pipe assembly: pipe body + pipe top render together, and pipe_top can be flipped with `Transform.flip`

3. **Add `flutter_test` dependency** (should already be in dev_dependencies from `flutter create`)

## Files Created

- `test/asset_existence_test.dart`
- `test/asset_rendering_test.dart`

## Dependencies

- Task 01 (Flutter project initialized)
- Task 02 (background.svg)
- Task 03 (ground.svg)
- Task 04 (bird SVGs)
- Task 05 (pipe SVGs)

## Test Plan

- Run `flutter test` — all tests pass
- `flutter analyze` reports no issues in test files

## Notes

- Asset existence tests use `dart:io` `File` class to check file presence.
- SVG validity tests parse files with `dart:convert` and `xml` package or simple string checks.
- Widget tests use `WidgetTester` to pump widgets with `SvgPicture.asset()`.
