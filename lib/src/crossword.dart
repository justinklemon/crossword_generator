import 'package:crossword_generator/src/positioned_word.dart';
import 'package:meta/meta.dart';

import 'coordinates.dart';
import 'grid.dart';

/// Represents a crossword puzzle.
///
/// A crossword puzzle is made up of a list of [PositionedWord]s and a [Grid] of characters.
/// The [PositionedWord]s represent the words placed in the crossword, and the [Grid] represents the crossword grid.
@immutable
class Crossword {
  /// The list of words placed in the crossword
  final List<PositionedWord> placedWords;

  /// The grid of characters in the crossword
  final Grid<String> grid;

  Crossword(List<PositionedWord> words)
      : placedWords = List.unmodifiable(words),
        grid = toGrid(words);

  /// Returns a new [Crossword] with the given [placedWords] added to the current [placedWords]
  ///
  /// If [placedWords] is not provided, returns a copy of the current [Crossword]
  /// Does not check for conflicts
  Crossword copyWith([List<PositionedWord>? placedWords]) {
    if (placedWords == null) {
      return Crossword(this.placedWords);
    }
    return Crossword([...placedWords, ...this.placedWords]);
  }

  /// Adds a word to the crossword
  ///
  /// Returns a new [Crossword] with the word added
  /// Does not check for conflicts
  Crossword addWord(PositionedWord word) {
    return Crossword([...placedWords, word]);
  }

  /// Returns an empty [Crossword]
  Crossword.empty()
      : placedWords = [],
        grid = Grid<String>();

  /// Returns a new [Crossword] with the given [word] placed horizontally beginning at the origin
  factory Crossword.startWithHorizontalWord(String word) {
    return Crossword([
      PositionedWord.horizontal(
          word: word, start: const Coordinates(x: 0, y: 0))
    ]);
  }

  /// Returns a new [Crossword] with the given [word] placed vertically beginning at the origin
  factory Crossword.startWithVerticalWord(String word) {
    return Crossword([
      PositionedWord.vertical(word: word, start: const Coordinates(x: 0, y: 0))
    ]);
  }

  /// Returns a List of [PositionedWord]s that pass through the given [coord]
  ///
  /// If no words pass through the [coord], returns an empty List
  /// If only a single horizontal/vertical word passes through the [coord], returns a List with a single element
  /// If both a horizontal and vertical word pass through the [coord], returns a List with both elements
  List<PositionedWord> getWordsPassingThroughCoordinates(Coordinates coord) {
    PositionedWord? horizontalWord = getHorizontalWord(coord);
    PositionedWord? verticalWord = getVerticalWord(coord);
    // Remove null values
    return [horizontalWord, verticalWord].whereType<PositionedWord>().toList();
  }

  /// Returns the horizontal [PositionedWord] that passes through the given [coord] or null if no word passes through
  ///
  /// The word is returned as a [PositionedWord] with the starting coordinates set to the first character of the word
  /// Words are assumed to always start at the top and proceed downwards.
  /// Single character 'words' are ignored
  /// Does not check if a word is actually a word, merely checks for a sequence of characters
  PositionedWord? getHorizontalWord(Coordinates coord) {
    String word = '';
    Coordinates currCoord = coord;
    String? char = grid.get(currCoord);
    // Get preceeding characters
    while (char != null) {
      word = char + word;
      currCoord = currCoord.shiftX(amount: -1);
      char = grid.get(currCoord);
    }
    // Correct the starting coordinates to the first character of the word (currCord is null)
    Coordinates start = currCoord.shiftX();
    // Get succeeding characters
    currCoord = coord.shiftX();
    char = grid.get(currCoord);
    while (char != null) {
      word += char;
      currCoord = currCoord.shiftX();
      char = grid.get(currCoord);
    }
    // Ignore single character words
    if (word.isEmpty || word.length == 1) {
      return null;
    }
    return PositionedWord.horizontal(word: word, start: start);
  }

  /// Returns the vertical [PositionedWord] that passes through the given [coord] or null if no word passes through
  ///
  /// The word is returned as a [PositionedWord] with the starting coordinates set to the first character of the word
  /// Words are assumed to always start at the left and proceed rightwards.
  /// Single character 'words' are ignored
  /// Does not check if a word is actually a word, merely checks for a sequence of characters
  PositionedWord? getVerticalWord(Coordinates coord) {
    String word = '';
    Coordinates currCoord = coord;
    String? char = grid.get(currCoord);
    // Get preceeding characters
    while (char != null) {
      word = char + word;
      currCoord = currCoord.shiftY(amount: -1);
      char = grid.get(currCoord);
    }
    // Correct the starting coordinates to the first character of the word (currCord is null)
    Coordinates start = currCoord.shiftY();
    // Get succeeding characters
    currCoord = coord.shiftY();
    char = grid.get(currCoord);
    while (char != null) {
      word += char;
      currCoord = currCoord.shiftY();
      char = grid.get(currCoord);
    }

    // Ignore single character words
    if (word.isEmpty || word.length == 1) {
      return null;
    }
    return PositionedWord.vertical(word: word, start: start);
  }

  static Grid<String> toGrid(List<PositionedWord> placedWords) {
    // Initialize an empty grid
    Grid<String> grid = Grid<String>();

    for (PositionedWord placedWord in placedWords) {
      for (Coordinates coord in placedWord.getCoordinates()) {
        grid.set(coord, placedWord.characterAt(coord));
      }
    }

    return grid;
  }

  /// Returns a double representing the score of the crossword.
  ///
  /// The score is calculated based on the density of the crossword and the ratio of filled cells.
  /// The higher the score, the better the crossword.
  /// A completely filled crossword will have a score of infinity.
  /// A completely empty crossword will have a score of 0.0
  double get score {
    if (grid.isEmpty) {
      return 0.0;
    }
    int rows = grid.rows;
    int columns = grid.columns;

    // Calculate the ratio of rows to columns or columns to rows depending on which is larger
    double sizeRatio = rows / columns;
    if (rows > columns) {
      sizeRatio = columns / rows;
    }

    // Calculate the amount of filled and empty cells
    int totalCells = rows * columns;
    Set<Coordinates> filledCells = grid.coordinates.toSet();
    int filledCellCount = filledCells.length;
    int emptyCellCount = totalCells - filledCellCount;

    // If the crossword is completely filled, return infinity
    if (emptyCellCount == 0) {
      return double.infinity;
    }

    double filledCellRatio = filledCellCount / emptyCellCount;

    // The score is a combination of the size ratio and the filled cell ratio
    return sizeRatio * 10 + filledCellRatio * 20;
  }

  @override
  String toString() {
    return 'Crossword(placedWords: $placedWords, grid: $grid)';
  }

  /// Returns a pretty string representation of the crossword
  String toPrettyString() {
    return "---Crossword---\n${grid.toPrettyString()}";
  }

  /// Crosswords are equal if their grids are relatively equivalent
  ///
  /// Relatively equivalent means that the characters are all in the same relative positions.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Crossword && other.grid.isRelativelyEquivalent(grid);
  }

  @override
  int get hashCode {
    return grid.hashCodeFromValuesOnly;
  }
}
