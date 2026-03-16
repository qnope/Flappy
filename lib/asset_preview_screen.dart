import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AssetPreviewScreen extends StatelessWidget {
  const AssetPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Background section
    final backgroundImage = SvgPicture.asset(
      'assets/images/background.svg',
      fit: BoxFit.fitWidth,
    );

    final backgroundContainer = SizedBox(
      width: double.infinity,
      child: backgroundImage,
    );

    final backgroundLabel = const Text(
      'background.svg',
      style: TextStyle(fontWeight: FontWeight.bold),
    );

    final backgroundSection = Column(
      children: [backgroundContainer, backgroundLabel],
    );

    // Ground section
    final groundImage = SvgPicture.asset(
      'assets/images/ground.svg',
      fit: BoxFit.fitWidth,
    );

    final groundContainer = SizedBox(
      width: double.infinity,
      child: groundImage,
    );

    final groundLabel = const Text(
      'ground.svg',
      style: TextStyle(fontWeight: FontWeight.bold),
    );

    final groundSection = Column(
      children: [groundContainer, groundLabel],
    );

    // Bird frames section
    final birdUp = SvgPicture.asset(
      'assets/images/bird_up.svg',
      height: 60,
    );

    final birdUpLabeled = Column(
      children: [birdUp, const Text('bird_up.svg')],
    );

    final birdMid = SvgPicture.asset(
      'assets/images/bird_mid.svg',
      height: 60,
    );

    final birdMidLabeled = Column(
      children: [birdMid, const Text('bird_mid.svg')],
    );

    final birdDown = SvgPicture.asset(
      'assets/images/bird_down.svg',
      height: 60,
    );

    final birdDownLabeled = Column(
      children: [birdDown, const Text('bird_down.svg')],
    );

    final birdRow = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [birdUpLabeled, birdMidLabeled, birdDownLabeled],
    );

    final birdSectionTitle = const Text(
      'Bird Frames',
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );

    final birdSection = Column(
      children: [birdSectionTitle, const SizedBox(height: 8), birdRow],
    );

    // Pipe assembly section
    final pipeTop = SvgPicture.asset(
      'assets/images/pipe_top.svg',
      width: 60,
    );

    final pipeTopLabel = const Text('pipe_top.svg');

    final pipeBody = SvgPicture.asset(
      'assets/images/pipe.svg',
      width: 60,
      height: 150,
      fit: BoxFit.fill,
    );

    final pipeBodyLabel = const Text('pipe.svg');

    final pipeBottomCap = Transform.flip(
      flipY: true,
      child: SvgPicture.asset(
        'assets/images/pipe_top.svg',
        width: 60,
      ),
    );

    final pipeBottomCapLabel = const Text('pipe_top.svg (flipped)');

    final pipeAssembly = Column(
      children: [
        pipeTop,
        pipeTopLabel,
        const SizedBox(height: 4),
        pipeBody,
        pipeBodyLabel,
        const SizedBox(height: 4),
        pipeBottomCap,
        pipeBottomCapLabel,
      ],
    );

    final pipeSectionTitle = const Text(
      'Pipe Assembly',
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );

    final pipeSection = Column(
      children: [pipeSectionTitle, const SizedBox(height: 8), pipeAssembly],
    );

    // Main content
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        backgroundSection,
        const SizedBox(height: 16),
        groundSection,
        const SizedBox(height: 24),
        birdSection,
        const SizedBox(height: 24),
        pipeSection,
        const SizedBox(height: 24),
      ],
    );

    final scrollView = SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: content,
    );

    final appBar = AppBar(
      title: const Text('Asset Preview'),
    );

    return Scaffold(
      appBar: appBar,
      body: scrollView,
    );
  }
}
