# Task 06: Create Asset Preview Screen

## Summary

Replace the default `lib/main.dart` with a preview screen that displays all 7 SVG assets. This allows visual verification across Chrome, iOS, and Android.

## Implementation Steps

1. **Create `lib/main.dart`** (replace default counter app)
   - Create a `MaterialApp` with a single `AssetPreviewScreen`
   - Follow the project rule: avoid nested construction, prefer declaring elements separately and passing as arguments

2. **Create `lib/asset_preview_screen.dart`**
   - A `StatelessWidget` that displays all 7 SVGs in a scrollable layout
   - Layout structure:
     - **Background**: Full-width `background.svg` at the top
     - **Ground**: Full-width `ground.svg`
     - **Bird frames**: Row of 3 bird SVGs side by side (up, mid, down)
     - **Pipe assembly**: Pipe top + pipe body + flipped pipe top (bottom cap) stacked vertically
   - Use `SvgPicture.asset()` from `flutter_svg` for each image
   - Add labels under each asset for identification

3. **Code structure** (following project rules)
   ```dart
   // Declare widgets separately, pass as arguments
   final backgroundImage = SvgPicture.asset('assets/images/background.svg', ...);
   final groundImage = SvgPicture.asset('assets/images/ground.svg', ...);
   // etc.
   ```

## Files Modified/Created

- `lib/main.dart` (replaced)
- `lib/asset_preview_screen.dart` (created)

## Dependencies

- Task 01 (Flutter project initialized)
- Task 02 (background.svg)
- Task 03 (ground.svg)
- Task 04 (bird SVGs)
- Task 05 (pipe SVGs)

## Test Plan

- App launches without errors on Chrome (`flutter run -d chrome`)
- All 7 SVGs render visibly on screen
- No rendering errors in console
- `flutter analyze` passes

## Notes

- This is a temporary screen for asset verification. It will be replaced by the actual game screen in a future project.
- Follow CLAUDE.md rule: avoid nested widget construction. Declare widgets as variables first, then compose.
