class Pipe {
  double posX;
  double gapCenterY;
  double gapSize;
  bool scored;

  Pipe({
    required this.posX,
    required this.gapCenterY,
    required this.gapSize,
    this.scored = false,
  });

  double get gapTop => gapCenterY - gapSize / 2;
  double get gapBottom => gapCenterY + gapSize / 2;
}
