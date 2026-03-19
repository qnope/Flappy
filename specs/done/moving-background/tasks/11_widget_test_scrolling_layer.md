# Task 11: Widget Tests for ScrollingLayerWidget

## Summary

Create `test/scrolling_layer_widget_test.dart` with widget tests verifying the `ScrollingLayerWidget` renders correctly with tiling and offset behavior.

## Implementation Steps

1. **Create `test/scrolling_layer_widget_test.dart`**

   - **Test: renders without error**
     ```dart
     testWidgets('renders with valid SVG asset', (tester) async {
       final widget = ScrollingLayerWidget(
         assetPath: GameAssets.ground,
         scrollOffset: 0.0,
         fit: BoxFit.fitWidth,
       );
       // Wrap in MaterialApp + SizedBox with constraints
       await tester.pumpWidget(MaterialApp(
         home: SizedBox(width: 400, height: 100, child: widget),
       ));
       expect(find.byType(ScrollingLayerWidget), findsOneWidget);
     });
     ```

   - **Test: contains two SvgPicture tiles**
     ```dart
     testWidgets('renders two SVG tiles', (tester) async {
       // ... pump widget ...
       expect(find.byType(SvgPicture), findsNWidgets(2));
     });
     ```

   - **Test: has ClipRect for overflow clipping**
     ```dart
     testWidgets('clips overflow with ClipRect', (tester) async {
       // ... pump widget ...
       expect(find.byType(ClipRect), findsOneWidget);
     });
     ```

   - **Test: renders with non-zero offset**
     ```dart
     testWidgets('renders with non-zero scroll offset', (tester) async {
       final widget = ScrollingLayerWidget(
         assetPath: GameAssets.ground,
         scrollOffset: 50.0,
       );
       // ... pump and verify no errors ...
     });
     ```

   - Use `GameAssets.ground` (existing asset) for test reliability.

## Dependencies

- Task 04 (ScrollingLayerWidget)

## Test Plan

- Run: `flutter test test/scrolling_layer_widget_test.dart`
- All tests pass.

## Design Notes

- Test with existing SVG assets (ground.svg) to avoid dependency on clouds.svg for the widget test.
- Focus on structural verification (widget tree), not visual correctness (which requires manual testing).
