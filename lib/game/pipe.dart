class Pipe {
  double posX;
  double gapCenterY;
  double gapSize;

  Pipe({
    required this.posX,
    required this.gapCenterY,
    required this.gapSize,
  });

  double get gapTop => gapCenterY - gapSize / 2;
  double get gapBottom => gapCenterY + gapSize / 2;
}
