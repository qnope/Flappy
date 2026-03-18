enum Wing {
  up('assets/images/bird_up.svg'),
  mid('assets/images/bird_mid.svg'),
  down('assets/images/bird_down.svg');

  final String assetPath;
  const Wing(this.assetPath);

  static const List<Wing> animationSequence = [up, mid, down, mid];
}
