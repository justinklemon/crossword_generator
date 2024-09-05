import 'package:meta/meta.dart';

import 'coordinates.dart';

/// Represents a word placed in a crossword puzzle.
///
/// A [PositionedWord] is made up of a [word], a [start] [Coordinates], and an [end] [Coordinates].
/// The [PositionedWord] can be either horizontal or vertical but not diagonal.
@immutable
class PositionedWord {
  final String word;
  final Coordinates start;
  final Coordinates end;

  /// Creates a [PositionedWord] with the given [word], [start] [Coordinates], and [end] [Coordinates].
  ///
  /// The [start] and [end] [Coordinates] must be aligned either horizontally or vertically.
  /// The [end] [Coordinates] must be the last character of the [word].
  PositionedWord({
    required this.word,
    required this.start,
    required this.end,
  }) : assert(
          (start.x == end.x && (end.y - start.y + 1) == word.length) ||
              (start.y == end.y && (end.x - start.x + 1) == word.length),
          'Coordinates do not fit the word length or are not aligned horizontally or vertically',
        );

  /// Creates a horizontal [PositionedWord] with the given [word] and [start] [Coordinates].
  ///
  /// The [end] [Coordinates] are calculated based on the [word] length.
  PositionedWord.horizontal({
    required this.word,
    required this.start,
  }) : end = Coordinates(x: start.x + word.length - 1, y: start.y);

  /// Creates a vertical [PositionedWord] with the given [word] and [start] [Coordinates].
  ///
  /// The [end] [Coordinates] are calculated based on the [word] length.
  PositionedWord.vertical({
    required this.word,
    required this.start,
  }) : end = Coordinates(x: start.x, y: start.y + word.length - 1);

  @override
  String toString() {
    return 'PositionedWord(word: $word, start: $start, end: $end)';
  }

  /// Returns true if the [word] contains the given [word].
  bool contains(String word) {
    return this.word.contains(word);
  }

  /// Returns true if the [PositionedWord] is horizontal.
  ///
  /// A [PositionedWord] is horizontal if the [start] and [end] [Coordinates] are on the same row.
  bool isHorizontal() {
    return start.y == end.y;
  }

  /// Returns true if the [PositionedWord] is vertical.
  ///
  /// A [PositionedWord] is vertical if the [start] and [end] [Coordinates] are on the same column.
  bool isVertical() {
    return start.x == end.x;
  }

  /// Returns the character at the given [Coordinates].
  ///
  /// If the [Coordinates] are not part of the [PositionedWord], returns an empty string.
  /// Otherwise, returns the character at the given [Coordinates] by calculating the offset from the [start] [Coordinates].
  String characterAt(Coordinates coordinates) {
    if (isHorizontal()) {
      if (coordinates.y != start.y) {
        return '';
      }
      if (coordinates.x < start.x || coordinates.x > end.x) {
        return '';
      }
      return word[coordinates.x - start.x];
    } else {
      if (coordinates.x != start.x) {
        return '';
      }
      if (coordinates.y < start.y || coordinates.y > end.y) {
        return '';
      }
      return word[coordinates.y - start.y];
    }
  }

  /// Returns a list of [PositionedWord] options that intersect with the given [newWord].
  List<PositionedWord> intersectingWordOptions(String newWord) {
    if (isHorizontal()) {
      return _intersectingWordOptionsHorizontal(newWord);
    } else {
      return _intersectingWordOptionsVertical(newWord);
    }
  }

  /// Returns a list of [PositionedWord] options that intersect with the given [newWord] horizontally.
  ///
  /// The current word is horizontal, so all intersecting words must be vertical.
  List<PositionedWord> _intersectingWordOptionsVertical(String newWord) {
    List<PositionedWord> intersectingWordOptions = [];
    for (int i = 0; i < word.length; i++) {
      for (int j = 0; j < newWord.length; j++) {
        // If the characters match, add the intersecting word to the list of options
        if (word[i] == newWord[j]) {
          final Coordinates newWordStart = Coordinates(
            x: start.x - j,
            y: start.y + i,
          );
          final Coordinates newWordEnd = Coordinates(
            x: start.x - j + newWord.length - 1,
            y: start.y + i,
          );
          intersectingWordOptions.add(
            PositionedWord(
              word: newWord,
              start: newWordStart,
              end: newWordEnd,
            ),
          );
        }
      }
    }
    return intersectingWordOptions;
  }

  /// Returns a list of [PositionedWord] options that intersect with the given [newWord] vertically.
  ///
  /// The current word is vertical, so all intersecting words must be horizontal.
  List<PositionedWord> _intersectingWordOptionsHorizontal(String newWord) {
    List<PositionedWord> intersectingWordOptions = [];
    for (int i = 0; i < word.length; i++) {
      for (int j = 0; j < newWord.length; j++) {
        // If the characters match, add the intersecting word to the list of options
        if (word[i] == newWord[j]) {
          final Coordinates newWordStart = Coordinates(
            x: start.x + i,
            y: start.y - j,
          );
          final Coordinates newWordEnd = Coordinates(
            x: start.x + i,
            y: start.y - j + newWord.length - 1,
          );
          intersectingWordOptions.add(
            PositionedWord(
              word: newWord,
              start: newWordStart,
              end: newWordEnd,
            ),
          );
        }
      }
    }
    return intersectingWordOptions;
  }

  /// Returns a list of [Coordinates] that the [PositionedWord] passes through.
  List<Coordinates> getCoordinates() {
    List<Coordinates> coordinates = [];
    if (isHorizontal()) {
      for (int i = 0; i < word.length; i++) {
        coordinates.add(Coordinates(x: start.x + i, y: start.y));
      }
    } else {
      for (int i = 0; i < word.length; i++) {
        coordinates.add(Coordinates(x: start.x, y: start.y + i));
      }
    }
    return coordinates;
  }

  /// Returns true if the [PositionedWord] passes through the given [coordinates].
  bool passesThroughPoint(Coordinates coordinates) {
    if (isHorizontal()) {
      // Check if the coordinates are on the same row and within the start and end x values
      return coordinates.y == start.y &&
          coordinates.x >= start.x &&
          coordinates.x <= end.x;
    } else {
      // Check if the coordinates are on the same column and within the start and end y values
      return coordinates.x == start.x &&
          coordinates.y >= start.y &&
          coordinates.y <= end.y;
    }
  }

  /// [PositionedWord]s are equal if they have the same [word], [start], and [end].
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PositionedWord &&
        other.word == word &&
        other.start == start &&
        other.end == end;
  }

  @override
  int get hashCode {
    return word.hashCode ^ start.hashCode ^ end.hashCode;
  }
}
