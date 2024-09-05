import 'package:test/test.dart';

import 'package:crossword_generator/crossword_generator.dart';

void main() {
  group('Test Constructor', () {
    test('Test constructor with horizontal word', () {
      PositionedWord horizontalWord = PositionedWord(
        word: 'hello',
        start: const Coordinates(x: 0, y: 0),
        end: const Coordinates(x: 4, y: 0),
      );
      expect(horizontalWord.isHorizontal(), true);
      expect(horizontalWord.isVertical(), false);
      expect(horizontalWord.word, 'hello');
    });

    test('Test constructor with vertical word', () {
      PositionedWord verticalWord = PositionedWord(
        word: 'hello',
        start: const Coordinates(x: 0, y: 0),
        end: const Coordinates(x: 0, y: 4),
      );
      expect(verticalWord.isHorizontal(), false);
      expect(verticalWord.isVertical(), true);
      expect(verticalWord.word, 'hello');
    });

    test('Test constructor with invalid coordinates', () {
      expect(
        () => PositionedWord(
          word: 'hello',
          start: const Coordinates(x: 0, y: 0),
          end: const Coordinates(x: 0, y: 1),
        ),
        throwsA(isA<AssertionError>()),
      );

      expect(
        () => PositionedWord(
          word: 'hello',
          start: const Coordinates(x: 0, y: 0),
          end: const Coordinates(x: 1, y: 0),
        ),
        throwsA(isA<AssertionError>()),
      );

      expect(
        () => PositionedWord(
          word: 'hello',
          start: const Coordinates(x: 0, y: 0),
          end: const Coordinates(x: 1, y: 1),
        ),
        throwsA(isA<AssertionError>()),
      );

      expect(
        () => PositionedWord(
          word: 'hello',
          start: const Coordinates(x: 0, y: 0),
          end: const Coordinates(x: 0, y: 17),
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    test('Test constructor with negative coordinates', () {
      PositionedWord negativeCoordinatesWord = PositionedWord(
        word: 'hello',
        start: const Coordinates(x: -2, y: -2),
        end: const Coordinates(x: 2, y: -2),
      );
      expect(negativeCoordinatesWord.isHorizontal(), true);
      expect(negativeCoordinatesWord.isVertical(), false);
      expect(negativeCoordinatesWord.word, 'hello');
    });

    test('Test named horizontal contstructor', () {
      PositionedWord horizontalWord = PositionedWord.horizontal(
        word: 'hello',
        start: const Coordinates(x: 0, y: 0),
      );
      expect(horizontalWord.isHorizontal(), true);
      expect(horizontalWord.isVertical(), false);
      expect(horizontalWord.word, 'hello');
      expect(horizontalWord.start, const Coordinates(x: 0, y: 0));
      expect(horizontalWord.end, const Coordinates(x: 4, y: 0));
    });

    test('Test named vertical contstructor', () {
      PositionedWord verticalWord = PositionedWord.vertical(
        word: 'hello',
        start: const Coordinates(x: 0, y: 0),
      );
      expect(verticalWord.isHorizontal(), false);
      expect(verticalWord.isVertical(), true);
      expect(verticalWord.word, 'hello');
      expect(verticalWord.start, const Coordinates(x: 0, y: 0));
      expect(verticalWord.end, const Coordinates(x: 0, y: 4));
    });
  });

  test('Test isHorizontal', () {
    PositionedWord horizontalWord = PositionedWord(
      word: 'hello',
      start: const Coordinates(x: 0, y: 0),
      end: const Coordinates(x: 4, y: 0),
    );
    expect(horizontalWord.isHorizontal(), true);
    PositionedWord nonHorizontalWord = PositionedWord(
      word: 'hello',
      start: const Coordinates(x: 0, y: 0),
      end: const Coordinates(x: 0, y: 4),
    );
    expect(nonHorizontalWord.isHorizontal(), false);
  });

  test('Test isVertical', () {
    PositionedWord verticalWord = PositionedWord(
      word: 'hello',
      start: const Coordinates(x: 0, y: 0),
      end: const Coordinates(x: 0, y: 4),
    );
    expect(verticalWord.isVertical(), true);
    PositionedWord nonVerticalWord = PositionedWord(
      word: 'hello',
      start: const Coordinates(x: 0, y: 0),
      end: const Coordinates(x: 4, y: 0),
    );
    expect(nonVerticalWord.isVertical(), false);
  });

  test('Test contains', () {
    PositionedWord positionedWord = PositionedWord(
      word: 'hello',
      start: const Coordinates(x: 0, y: 0),
      end: const Coordinates(x: 4, y: 0),
    );
    expect(positionedWord.contains('hello'), true);
    expect(positionedWord.contains('hell'), true);
    expect(positionedWord.contains('h'), true);
    expect(positionedWord.contains('he'), true);
    expect(positionedWord.contains('l'), true);
    expect(positionedWord.contains('lo'), true);
    expect(positionedWord.contains('o'), true);
    expect(positionedWord.contains('heo'), false);
    expect(positionedWord.contains('helo'), false);
    expect(positionedWord.contains('helloo'), false);
    expect(positionedWord.contains('hello '), false);
    expect(positionedWord.contains(' hello'), false);
  });

  group('Test getCharacterAt', () {
    test('Test getCharacterAt horizontal', () {
      PositionedWord positionedWord = PositionedWord(
        word: 'hello',
        start: const Coordinates(x: 0, y: 0),
        end: const Coordinates(x: 4, y: 0),
      );
      expect(positionedWord.characterAt(const Coordinates(x: 0, y: 0)), 'h');
      expect(positionedWord.characterAt(const Coordinates(x: 1, y: 0)), 'e');
      expect(positionedWord.characterAt(const Coordinates(x: 2, y: 0)), 'l');
      expect(positionedWord.characterAt(const Coordinates(x: 3, y: 0)), 'l');
      expect(positionedWord.characterAt(const Coordinates(x: 4, y: 0)), 'o');
      expect(positionedWord.characterAt(const Coordinates(x: 5, y: 0)), '');
      expect(positionedWord.characterAt(const Coordinates(x: 0, y: 1)), '');
    });

    test('Test getCharacterAt vertical', () {
      PositionedWord positionedWord = PositionedWord(
        word: 'hello',
        start: const Coordinates(x: 0, y: 0),
        end: const Coordinates(x: 0, y: 4),
      );
      expect(positionedWord.characterAt(const Coordinates(x: 0, y: 0)), 'h');
      expect(positionedWord.characterAt(const Coordinates(x: 0, y: 1)), 'e');
      expect(positionedWord.characterAt(const Coordinates(x: 0, y: 2)), 'l');
      expect(positionedWord.characterAt(const Coordinates(x: 0, y: 3)), 'l');
      expect(positionedWord.characterAt(const Coordinates(x: 0, y: 4)), 'o');
      expect(positionedWord.characterAt(const Coordinates(x: 0, y: 5)), '');
      expect(positionedWord.characterAt(const Coordinates(x: 1, y: 0)), '');
    });
  });

  group('Test intersectingWordOptions', () {
    test('Test intersectingWordOptions horizontal', () {
      PositionedWord positionedWord = PositionedWord(
        word: 'hello',
        start: const Coordinates(x: 0, y: 0),
        end: const Coordinates(x: 4, y: 0),
      );

      List<PositionedWord> intersectingWordOptions =
          positionedWord.intersectingWordOptions('world');
      expect(intersectingWordOptions.length, 3);

      // Check that the list contains the expected items without caring about the order
      expect(
        intersectingWordOptions,
        containsAll([
          PositionedWord(
            word: 'world',
            start: const Coordinates(x: 2, y: -3),
            end: const Coordinates(x: 2, y: 1),
          ),
          PositionedWord(
            word: 'world',
            start: const Coordinates(x: 3, y: -3),
            end: const Coordinates(x: 3, y: 1),
          ),
          PositionedWord(
            word: 'world',
            start: const Coordinates(x: 4, y: -1),
            end: const Coordinates(x: 4, y: 3),
          ),
        ]),
      );
    });

    test('Test intersectingWordOptions vertical', () {
      PositionedWord positionedWord = PositionedWord(
        word: 'hello',
        start: const Coordinates(x: 0, y: 0),
        end: const Coordinates(x: 0, y: 4),
      );
      List<PositionedWord> intersectingWordOptions =
          positionedWord.intersectingWordOptions('world');
      expect(intersectingWordOptions.length, 3);

      // Check that the list contains the expected items without caring about the order
      expect(
        intersectingWordOptions,
        containsAll([
          PositionedWord(
            word: 'world',
            start: const Coordinates(x: -3, y: 2),
            end: const Coordinates(x: 1, y: 2),
          ),
          PositionedWord(
            word: 'world',
            start: const Coordinates(x: -3, y: 3),
            end: const Coordinates(x: 1, y: 3),
          ),
          PositionedWord(
            word: 'world',
            start: const Coordinates(x: -1, y: 4),
            end: const Coordinates(x: 3, y: 4),
          ),
        ]),
      );
    });

    test('Test intersectingWordOptions no intersection', () {
      PositionedWord positionedWord = PositionedWord(
        word: 'hello',
        start: const Coordinates(x: 0, y: 0),
        end: const Coordinates(x: 4, y: 0),
      );
      List<PositionedWord> intersectingWordOptions =
          positionedWord.intersectingWordOptions('car');
      expect(intersectingWordOptions.length, 0);
    });
  });

  group('Test getCoordinates', () {
    test('Test getCoordinates horizontal', () {
      PositionedWord positionedWord = PositionedWord(
        word: 'hello',
        start: const Coordinates(x: 0, y: 0),
        end: const Coordinates(x: 4, y: 0),
      );
      List<Coordinates> coordinates = positionedWord.getCoordinates();
      expect(coordinates.length, 5);
      expect(
        coordinates,
        containsAll([
          const Coordinates(x: 0, y: 0),
          const Coordinates(x: 1, y: 0),
          const Coordinates(x: 2, y: 0),
          const Coordinates(x: 3, y: 0),
          const Coordinates(x: 4, y: 0),
        ]),
      );
    });

    test('Test getCoordinates vertical', () {
      PositionedWord positionedWord = PositionedWord(
        word: 'hello',
        start: const Coordinates(x: 0, y: 0),
        end: const Coordinates(x: 0, y: 4),
      );
      List<Coordinates> coordinates = positionedWord.getCoordinates();
      expect(coordinates.length, 5);
      expect(
        coordinates,
        containsAll([
          const Coordinates(x: 0, y: 0),
          const Coordinates(x: 0, y: 1),
          const Coordinates(x: 0, y: 2),
          const Coordinates(x: 0, y: 3),
          const Coordinates(x: 0, y: 4),
        ]),
      );
    });

    test('Test getCoordinates with negative', () {
      PositionedWord positionedWord = PositionedWord(
        word: 'hello',
        start: const Coordinates(x: -2, y: -2),
        end: const Coordinates(x: 2, y: -2),
      );
      List<Coordinates> coordinates = positionedWord.getCoordinates();
      expect(coordinates.length, 5);
      expect(
        coordinates,
        containsAll([
          const Coordinates(x: -2, y: -2),
          const Coordinates(x: -1, y: -2),
          const Coordinates(x: 0, y: -2),
          const Coordinates(x: 1, y: -2),
          const Coordinates(x: 2, y: -2),
        ]),
      );
    });
  });

  group('Test passesThroughPoint', () {
    test('Test passesThrough start point', () {
      PositionedWord positionedWord = PositionedWord(
        word: 'hello',
        start: const Coordinates(x: 0, y: 0),
        end: const Coordinates(x: 4, y: 0),
      );
      expect(positionedWord.passesThroughPoint(const Coordinates(x: 0, y: 0)),
          true);
    });

    test('Test passesThrough middle point', () {
      PositionedWord positionedWord = PositionedWord(
        word: 'hello',
        start: const Coordinates(x: 0, y: 0),
        end: const Coordinates(x: 4, y: 0),
      );
      expect(positionedWord.passesThroughPoint(const Coordinates(x: 2, y: 0)),
          true);
    });

    test('Test passesThrough end point', () {
      PositionedWord positionedWord = PositionedWord(
        word: 'hello',
        start: const Coordinates(x: 0, y: 0),
        end: const Coordinates(x: 4, y: 0),
      );
      expect(positionedWord.passesThroughPoint(const Coordinates(x: 4, y: 0)),
          true);
    });

    test('Test does not pass through point', () {
      PositionedWord positionedWord = PositionedWord(
        word: 'hello',
        start: const Coordinates(x: 0, y: 0),
        end: const Coordinates(x: 4, y: 0),
      );
      expect(positionedWord.passesThroughPoint(const Coordinates(x: 0, y: 1)),
          false);
    });
  });

  group('Test equality operators', () {
    test('Test equality operator', () {
      PositionedWord positionedWord1 = PositionedWord(
        word: 'hello',
        start: const Coordinates(x: 0, y: 0),
        end: const Coordinates(x: 4, y: 0),
      );
      PositionedWord positionedWord2 = PositionedWord(
        word: 'hello',
        start: const Coordinates(x: 0, y: 0),
        end: const Coordinates(x: 4, y: 0),
      );
      expect(positionedWord1 == positionedWord2, true);
    });

    test('Test equality operator with different words', () {
      PositionedWord positionedWord1 = PositionedWord(
        word: 'hello',
        start: const Coordinates(x: 0, y: 0),
        end: const Coordinates(x: 4, y: 0),
      );
      PositionedWord positionedWord2 = PositionedWord(
        word: 'world',
        start: const Coordinates(x: 0, y: 0),
        end: const Coordinates(x: 4, y: 0),
      );
      expect(positionedWord1 == positionedWord2, false);
    });

    test('Test equality operator with different start coordinates', () {
      PositionedWord positionedWord1 = PositionedWord(
        word: 'hello',
        start: const Coordinates(x: 0, y: 0),
        end: const Coordinates(x: 4, y: 0),
      );
      PositionedWord positionedWord2 = PositionedWord(
        word: 'hello',
        start: const Coordinates(x: 1, y: 0),
        end: const Coordinates(x: 5, y: 0),
      );
      expect(positionedWord1 == positionedWord2, false);
    });

    test('Test equality operator with different end coordinates', () {
      PositionedWord positionedWord1 = PositionedWord(
        word: 'hello',
        start: const Coordinates(x: 0, y: 0),
        end: const Coordinates(x: 4, y: 0),
      );
      PositionedWord positionedWord2 = PositionedWord(
        word: 'hello',
        start: const Coordinates(x: 1, y: 0),
        end: const Coordinates(x: 5, y: 0),
      );
      expect(positionedWord1 == positionedWord2, false);
    });

    test('Test equality operator with different coordinates', () {
      PositionedWord positionedWord1 = PositionedWord(
        word: 'hello',
        start: const Coordinates(x: 0, y: 0),
        end: const Coordinates(x: 4, y: 0),
      );
      PositionedWord positionedWord2 = PositionedWord(
        word: 'hello',
        start: const Coordinates(x: 1, y: 1),
        end: const Coordinates(x: 5, y: 1),
      );
      expect(positionedWord1 == positionedWord2, false);
    });

    test('Test compatibility with set', () {
      PositionedWord positionedWord1 = PositionedWord(
        word: 'hello',
        start: const Coordinates(x: 0, y: 0),
        end: const Coordinates(x: 4, y: 0),
      );
      PositionedWord positionedWord2 = PositionedWord(
        word: 'hello',
        start: const Coordinates(x: 0, y: 0),
        end: const Coordinates(x: 4, y: 0),
      );
      Set<PositionedWord> set = {positionedWord1, positionedWord2};
      expect(set.length, 1);
    });
  });
}
