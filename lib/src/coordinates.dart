import 'package:meta/meta.dart';

/// Represents a pair of x and y coordinates
@immutable
class Coordinates {
  final int x;
  final int y;

  const Coordinates({required this.x, required this.y});

  /// Shifts the x coordinate by [amount]. Defaults to 1
  Coordinates shiftX({int amount = 1}) => Coordinates(x: x + amount, y: y);
  /// Shifts the y coordinate by [amount]. Defaults to 1
  Coordinates shiftY({int amount = 1}) => Coordinates(x: x, y: y + amount);

  @override
  String toString() {
    return 'Coordinates(x: $x, y: $y)';
  }

  /// Coordinates are equal if both x and y are equal
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Coordinates && other.x == x && other.y == y;
  }

  @override
  int get hashCode {
    return x.hashCode ^ y.hashCode;
  }
}
