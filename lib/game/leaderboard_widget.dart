import 'package:flutter/material.dart';

import 'score_entry.dart';

class LeaderboardWidget extends StatelessWidget {
  final List<ScoreEntry> scores;
  final int? highlightIndex;

  const LeaderboardWidget({
    super.key,
    required this.scores,
    this.highlightIndex,
  });

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year;
    return '$day/$month/$year';
  }

  @override
  Widget build(BuildContext context) {
    if (scores.isEmpty) {
      return const SizedBox();
    }

    const defaultTextStyle = TextStyle(
      fontSize: 14,
      color: Colors.white,
      fontWeight: FontWeight.normal,
      shadows: [
        Shadow(blurRadius: 2, color: Colors.black54),
      ],
    );

    const highlightTextStyle = TextStyle(
      fontSize: 14,
      color: Color(0xFFFFD700),
      fontWeight: FontWeight.bold,
      shadows: [
        Shadow(blurRadius: 2, color: Colors.black54),
      ],
    );

    const headerStyle = TextStyle(
      fontSize: 16,
      color: Colors.white70,
      fontWeight: FontWeight.bold,
      shadows: [
        Shadow(blurRadius: 2, color: Colors.black54),
      ],
    );

    const newHighScoreStyle = TextStyle(
      fontSize: 18,
      color: Color(0xFFFFD700),
      fontWeight: FontWeight.bold,
      shadows: [
        Shadow(blurRadius: 4, color: Colors.black87),
      ],
    );

    final rows = <Widget>[];

    if (highlightIndex != null) {
      const newHighScoreText = Text(
        'New High Score!',
        style: newHighScoreStyle,
        textAlign: TextAlign.center,
      );

      final newHighScorePadding = const Padding(
        padding: EdgeInsets.only(bottom: 8),
        child: newHighScoreText,
      );

      rows.add(newHighScorePadding);
    }

    final rankHeader = SizedBox(
      width: 40,
      child: const Text('#', style: headerStyle),
    );

    final scoreHeader = Expanded(
      child: const Text('Score', style: headerStyle, textAlign: TextAlign.center),
    );

    final dateHeader = SizedBox(
      width: 90,
      child: const Text('Date', style: headerStyle, textAlign: TextAlign.right),
    );

    final headerRow = Row(
      children: [rankHeader, scoreHeader, dateHeader],
    );

    final headerPadding = Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: headerRow,
    );

    rows.add(headerPadding);

    final divider = Divider(
      color: Colors.white24,
      height: 1,
      thickness: 1,
    );

    rows.add(divider);

    for (var i = 0; i < scores.length; i++) {
      final entry = scores[i];
      final isHighlighted = highlightIndex == i;
      final textStyle = isHighlighted ? highlightTextStyle : defaultTextStyle;

      final rankText = SizedBox(
        width: 40,
        child: Text('#${i + 1}', style: textStyle),
      );

      final scoreText = Expanded(
        child: Text(
          '${entry.score}',
          style: textStyle,
          textAlign: TextAlign.center,
        ),
      );

      final dateText = SizedBox(
        width: 90,
        child: Text(
          _formatDate(entry.date),
          style: textStyle,
          textAlign: TextAlign.right,
        ),
      );

      final row = Row(
        children: [rankText, scoreText, dateText],
      );

      final rowPadding = Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: row,
      );

      rows.add(rowPadding);
    }

    final column = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: rows,
    );

    final innerPadding = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: column,
    );

    final containerDecoration = BoxDecoration(
      color: Colors.black.withValues(alpha: 0.7),
      borderRadius: BorderRadius.circular(12),
    );

    final container = Container(
      width: 280,
      decoration: containerDecoration,
      child: innerPadding,
    );

    final centered = Center(
      child: container,
    );

    return centered;
  }
}
