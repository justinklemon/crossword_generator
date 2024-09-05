import 'coordinates.dart';

/// Represents a 2d grid of values of type [T].
class Grid<T> {
  /// The internal grid representation.
  final Map<int, Map<int, T>> _grid = {};

  /// Sets the [value] at the given [coord].
  void set(Coordinates coord, T value) {
    // Create the column if it doesn't exist
    if (!_grid.containsKey(coord.x)) {
      _grid[coord.x] = {};
    }
    _grid[coord.x]![coord.y] = value;
  }

  /// Returns the value at the given [coord].
  /// 
  /// If the [coord] is not present in the grid, returns null.
  T? get(Coordinates coord) {
    return _grid[coord.x]?[coord.y];
  }

  /// Returns true if the grid contains the given [coord].
  bool contains(Coordinates coord) {
    return _grid.containsKey(coord.x) && _grid[coord.x]!.containsKey(coord.y);
  }

  /// Returns true if the grid is empty.
  bool get isEmpty {
    return _grid.isEmpty;
  }

  /// Removes the value at the given [coord].
  void remove(Coordinates coord) {
    if (_grid.containsKey(coord.x)) {
      _grid[coord.x]!.remove(coord.y);
      if (_grid[coord.x]!.isEmpty) {
        _grid.remove(coord.x);
      }
    }
  }

  /// Returns a list of lists representing the grid.
  /// 
  /// The inner lists represent the rows of the grid.
  /// If the grid is empty, returns an empty list.
  /// Positive x values are to the right, and positive y values are down.
  /// Positions that are not present in the grid are represented by null.
  List<List<T?>> toList() {
    if (_grid.isEmpty) return [];
    final result = <List<T?>>[];
    for (int y = minYindex; y <= maxYindex; y++) {
      final row = <T?>[];
      for (int x = minXindex; x <= maxXindex; x++) {
        row.add(get(Coordinates(x: x, y: y)));
      }
      result.add(row);
    }
    return result;
  }

  /// Returns the minimum x index in the grid.
  /// 
  /// If the grid is empty, throws a [StateError].
  int get minXindex {
    if (_grid.isEmpty) throw StateError('Grid is empty');
    return _grid.keys
        .reduce((value, element) => value < element ? value : element);
  }

  /// Returns the maximum x index in the grid.
  /// 
  /// If the grid is empty, throws a [StateError].
  int get maxXindex {
    if (_grid.isEmpty) throw StateError('Grid is empty');
    return _grid.keys
        .reduce((value, element) => value > element ? value : element);
  }

  /// Returns the minimum y index in the grid.
  /// 
  /// If the grid is empty, throws a [StateError].
  int get minYindex {
    if (_grid.isEmpty) throw StateError('Grid is empty');
    return _grid.values
        .map((row) => row.keys
            .reduce((value, element) => value < element ? value : element))
        .reduce((value, element) => value < element ? value : element);
  }

  /// Returns the maximum y index in the grid.
  /// 
  /// If the grid is empty, throws a [StateError].
  int get maxYindex {
    if (_grid.isEmpty) throw StateError('Grid is empty');
    return _grid.values
        .map((row) => row.keys
            .reduce((value, element) => value > element ? value : element))
        .reduce((value, element) => value > element ? value : element);
  }

  /// Returns the number of rows in the grid.
  /// 
  /// If the grid is empty, returns 0.
  int get rows {
    if (_grid.isEmpty) return 0;
    return maxYindex - minYindex + 1;
  }

  /// Returns the number of columns in the grid.
  /// 
  /// If the grid is empty, returns 0.
  int get columns {
    if (_grid.isEmpty) return 0;
    return maxXindex - minXindex + 1;
  }

  /// Returns a list of all the coordinates in the grid.
  List<Coordinates> get coordinates {
    final List<Coordinates> result = [];
    _grid.forEach((x, row) {
      row.forEach((y, _) {
        result.add(Coordinates(x: x, y: y));
      });
    });
    return result;
  }

  /// Returns a new grid with the values normalized to the top-left corner.
  /// 
  /// If the grid is empty, returns an empty grid.
  /// The top-left corner of the grid will be (0, 0).
  /// The relative positions of the values will be preserved.
  Grid<T> get normalize {
    if (_grid.isEmpty) return Grid<T>();
    final int minX = minXindex;
    final int minY = minYindex;
    final Grid<T> result = Grid<T>();
    for (final coord in coordinates) {
      final T? value = get(coord);
      if (value != null) {
        // Normalize the coordinates
        result.set(Coordinates(x: coord.x - minX, y: coord.y - minY), value);
      }
    }
    return result;
  }

  /// Grids are equal if they have the same values at the same coordinates.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Grid &&
        other._grid.length == _grid.length &&
        _grid.entries.every((entry) {
          final otherRow = other._grid[entry.key];
          if (otherRow == null) return false;
          return otherRow.length == entry.value.length &&
              entry.value.entries
                  .every((entry) => otherRow[entry.key] == entry.value);
        });
  }

  @override
  int get hashCode {
    const int prime = 31;

    // Sort the outer map by keys. This is done to ensure that the hash code is consistent
    List<MapEntry<int, Map<int, T>>> sortedColumns = _grid.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    // Compute the hash code
    return sortedColumns.fold(0, (prevColumnHash, entry) {
      int keyHash = entry.key.hashCode;

      // Sort the inner map by keys. This is done to ensure that the hash code is consistent
      var sortedRows = entry.value.entries.toList()
        ..sort((a, b) => a.key.compareTo(b.key));

      // Compute the hash code for the inner map
      int valueHash = sortedRows.fold(0, (prevRowHash, rowEntry) {
        return prime * prevRowHash +
            Object.hash(rowEntry.key.hashCode, rowEntry.value.hashCode);
      });

      return prime * prevColumnHash + Object.hash(keyHash, valueHash);
    });
  }

  /// Returns true if the two grids are relatively equivalent.
  ///
  /// Two grids are relatively equivalent if they have the same values
  /// positioned at relatively the same coordinates, regardless of the
  /// actual coordinates. i.e. a grid with the value 'A' at (0, 0) is
  /// relatively equivalent to a grid with the value 'A' at (1, 1).
  bool isRelativelyEquivalent(Grid<T> other) {
    if (_grid.isEmpty && other._grid.isEmpty) return true;
    if (_grid.isEmpty || other._grid.isEmpty) return false;

    // Get the minimum and maximum indices for both grids
    final int minX = minXindex;
    final int maxX = maxXindex;
    final int minY = minYindex;
    final int maxY = maxYindex;

    final int otherMinX = other.minXindex;
    final int otherMaxX = other.maxXindex;
    final int otherMinY = other.minYindex;
    final int otherMaxY = other.maxYindex;

    // Check if the grids have the same dimensions
    if (maxX - minX != otherMaxX - otherMinX ||
        maxY - minY != otherMaxY - otherMinY) {
      return false;
    }

    // Check if the grids have the same values at the same relative coordinates
    final coords = coordinates;
    for (final coord in coords) {
      final otherCoord = Coordinates(
        x: coord.x - minX + otherMinX,
        y: coord.y - minY + otherMinY,
      );

      if (get(coord) != other.get(otherCoord)) {
        return false;
      }
    }

    return true;
  }

  /// Returns a hash code based on the values of the grid only.
  /// The hash code is computed by sorting the grid by keys and then
  /// computing the hash code of the values.
  /// This method is useful when the keys are not important for the
  /// equality of the grid.
  int get hashCodeFromValuesOnly {
    const int prime = 31;

    // Sort the outer map by keys
    List<MapEntry<int, Map<int, T>>> sortedColumns = _grid.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    // Compute the hash code
    return sortedColumns.fold(0, (prevColumnHash, entry) {
      // Sort the inner map by keys
      var sortedRows = entry.value.entries.toList()
        ..sort((a, b) => a.key.compareTo(b.key));

      // Compute the hash code for the inner map
      int valueHash = sortedRows.fold(0, (prevRowHash, rowEntry) {
        return prime * prevRowHash + rowEntry.value.hashCode;
      });

      return prime * prevColumnHash + valueHash;
    });
  }

  @override
  String toString() {
    final buffer = StringBuffer();
    _grid.forEach((x, row) {
      row.forEach((y, value) {
        buffer.writeln('($x, $y): $value');
      });
    });
    return buffer.toString();
  }

  /// Returns a pretty string representation of the grid.
  String toPrettyString() {
    if (_grid.isEmpty) return '';
    StringBuffer buffer = StringBuffer();

    // Calculate the top-left and bottom-right coordinates
    final topLeft = Coordinates(x: minXindex, y: minYindex);
    final bottomRight = Coordinates(x: maxXindex, y: maxYindex);

    // Append the coordinates to the buffer
    buffer.writeln('Top-left: (${topLeft.x}, ${topLeft.y})');
    buffer.writeln('Bottom-right: (${bottomRight.x}, ${bottomRight.y})');
    buffer.writeln();

    for (int y = topLeft.y; y <= bottomRight.y; y++) {
      for (int x = topLeft.x; x <= bottomRight.x; x++) {
        if (contains(Coordinates(x: x, y: y))) {
          buffer.write(get(Coordinates(x: x, y: y)));
        } else {
          buffer.write(' ');
        }
        // Add a space between each value
        buffer.write(' ');
      }
      buffer.writeln();
    }
    return buffer.toString();
  }
}
