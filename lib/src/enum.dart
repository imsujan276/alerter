/// indicates the position of the overlay
enum OverlayPosition { top, bottom }

/// indicates the duration of the overlay
///
/// [short] - 2 seconds
/// [normal] - 3 seconds
/// [long] - 4 seconds
/// [veryLong] - 5 seconds
enum OverlayDuration {
  short(2),
  normal(3),
  long(3),
  veryLong(5);

  final int value;
  const OverlayDuration(this.value);

  @override
  String toString() => 'OverlayDuration(value: $value seconds)';
}
