import 'package:flutter/material.dart';
import 'asset_preview_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const home = AssetPreviewScreen();

    final theme = ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    );

    return MaterialApp(
      title: 'Flappy',
      theme: theme,
      home: home,
    );
  }
}
