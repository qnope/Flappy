# Task 1: Add Hive Dependencies

## Summary
Add `hive`, `hive_flutter`, and `build_runner`/`hive_generator` to the project so we can persist scores using Hive.

## Implementation Steps

1. **Edit `pubspec.yaml`**
   - Add under `dependencies`:
     ```yaml
     hive: ^2.2.3
     hive_flutter: ^1.1.0
     ```
   - Add under `dev_dependencies`:
     ```yaml
     hive_generator: ^2.0.1
     build_runner: ^2.4.8
     ```

2. **Run `flutter pub get`** to fetch the new packages.

3. **Verify** no dependency conflicts or analyzer errors.

## Dependencies
- None (first task)

## Test Plan
- `flutter pub get` completes without errors
- `flutter analyze` passes
