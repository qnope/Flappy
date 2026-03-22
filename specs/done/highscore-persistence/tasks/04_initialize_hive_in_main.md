# Task 4: Initialize Hive in main.dart

## Summary
Initialize Hive and register the ScoreEntry adapter before the app starts. Pass the ScoreRepository down to GameScreen.

## Implementation Steps

1. **Edit `lib/main.dart`**:
   - Make `main()` async
   - Call `await Hive.initFlutter()` before `runApp()`
   - Register adapter: `Hive.registerAdapter(ScoreEntryAdapter())`
   - Create repository: `final scoreRepo = await ScoreRepository.create()`
   - Pass `scoreRepo` to `MyApp` and down to `GameScreen`

2. **Edit `lib/game/game_screen.dart`** (minimal change):
   - Add `ScoreRepository` as a required constructor parameter to `GameScreen`
   - Store it in state for later use (wired fully in Task 13)

3. **Add `WidgetsFlutterBinding.ensureInitialized()`** before Hive init (required for async main).

## File Paths
- `lib/main.dart` (edit)
- `lib/game/game_screen.dart` (edit — add constructor param only)

## Dependencies
- Task 3 (ScoreRepository must exist)

## Test Plan
- App launches without errors on Chrome
- `flutter analyze` passes
- No runtime errors in console related to Hive initialization
