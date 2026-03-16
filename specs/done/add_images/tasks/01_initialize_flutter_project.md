# Task 01: Initialize Flutter Project

## Summary

Set up the Flutter project scaffold and add the `flutter_svg` dependency. This is the foundation task — all other tasks depend on it.

## Implementation Steps

1. **Create Flutter project**
   - Run `flutter create --project-name flappy .` in the project root
   - This generates `pubspec.yaml`, `lib/main.dart`, `test/`, `android/`, `ios/`, `web/`, etc.

2. **Add `flutter_svg` dependency**
   - Run `flutter pub add flutter_svg`
   - Verify it appears in `pubspec.yaml` under `dependencies`

3. **Create asset directory**
   - Create `assets/images/` directory

4. **Declare assets in `pubspec.yaml`**
   - Add the following under the `flutter:` section:
     ```yaml
     flutter:
       assets:
         - assets/images/
     ```

5. **Run `flutter pub get`** to resolve dependencies

6. **Verify project builds**
   - Run `flutter analyze` to check for issues

## Files Modified

- `pubspec.yaml` (created + modified)
- `lib/main.dart` (created by flutter create)
- `assets/images/` (directory created)

## Dependencies

- None (first task)

## Test Plan

- `flutter pub get` completes without errors
- `flutter analyze` reports no issues
- `assets/images/` directory exists

## Notes

- The default `main.dart` counter app will be replaced in task 07 with the asset preview screen.
- Project name: `flappy`
