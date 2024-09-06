import 'package:test/test.dart';

import 'package:crossword_generator/crossword_generator.dart';

/// Tests that the crosswords are sorted by score in descending order
void expectCrosswordsSortedByScore(List<Crossword> crosswords) {
  for (int i = 0; i < crosswords.length - 1; i++) {
    expect(crosswords[i].score, greaterThanOrEqualTo(crosswords[i + 1].score));
  }
}

void main() {
  test('Test generator with empty list', () {
    final List<Crossword> crosswords = generateCrosswords([]);
    expect(crosswords.length, 0);
  });
  test('Test generator with single word', () {
    final List<Crossword> crosswords = generateCrosswords(['hello']);
    expect(crosswords.length, 2);

    final List<List<PositionedWord>> placedWords =
        crosswords.map((crossword) => crossword.placedWords).toList();
    expect(
        placedWords,
        containsAll([
          [
            PositionedWord.horizontal(
              word: 'hello',
              start: const Coordinates(x: 0, y: 0),
            )
          ],
          [
            PositionedWord.vertical(
              word: 'hello',
              start: const Coordinates(x: 0, y: 0),
            )
          ]
        ]));
    expectCrosswordsSortedByScore(crosswords);
  });

  test('Test generator with two words with single point of intersection', () {
    final List<Crossword> crosswords = generateCrosswords(['hello', 'ham']);
    expect(crosswords.length, 2);

    final List<List<List<String?>>> expectedOptions = [
      [
        ['h', 'e', 'l', 'l', 'o'],
        ['a', null, null, null, null],
        ['m', null, null, null, null],
      ],
      [
        ['h', 'a', 'm'],
        ['e', null, null],
        ['l', null, null],
        ['l', null, null],
        ['o', null, null],
      ],
    ];

    final options =
        crosswords.map((crossword) => crossword.grid.toList()).toList();

    expect(options, containsAll(expectedOptions));
    expectCrosswordsSortedByScore(crosswords);
  });

  test('Test generator with two words with multiple points of intersection',
      () {
    final expectedResults = [
      [
        [null, null, 'w', null, null],
        [null, null, 'o', null, null],
        [null, null, 'r', null, null],
        ['h', 'e', 'l', 'l', 'o'],
        [null, null, 'd', null, null],
      ],
      [
        [null, null, null, 'w', null],
        [null, null, null, 'o', null],
        [null, null, null, 'r', null],
        ['h', 'e', 'l', 'l', 'o'],
        [null, null, null, 'd', null],
      ],
      [
        [null, null, null, null, 'w'],
        ['h', 'e', 'l', 'l', 'o'],
        [null, null, null, null, 'r'],
        [null, null, null, null, 'l'],
        [null, null, null, null, 'd'],
      ],
      [
        [null, null, null, 'h', null],
        [null, null, null, 'e', null],
        ['w', 'o', 'r', 'l', 'd'],
        [null, null, null, 'l', null],
        [null, null, null, 'o', null],
      ],
      [
        [null, null, null, 'h', null],
        [null, null, null, 'e', null],
        [null, null, null, 'l', null],
        ['w', 'o', 'r', 'l', 'd'],
        [null, null, null, 'o', null],
      ],
      [
        [null, 'h', null, null, null],
        [null, 'e', null, null, null],
        [null, 'l', null, null, null],
        [null, 'l', null, null, null],
        ['w', 'o', 'r', 'l', 'd'],
      ],
    ];
    final List<Crossword> crosswords = generateCrosswords(['hello', 'world']);
    expect(crosswords.length, 6);
    final options =
        crosswords.map((crossword) => crossword.grid.toList()).toList();
    expect(options, containsAll(expectedResults));
    expectCrosswordsSortedByScore(crosswords);
  });

  test('Test 3 words with multiple points of intersection', () {
    final expectedResults = [
      [
        [null, null, null, 'h', 'a', 'm'],
        [null, null, null, 'e', null, null],
        ['w', 'o', 'r', 'l', 'd', null],
        [null, null, null, 'l', null, null],
        [null, null, null, 'o', null, null],
      ],
      [
        [null, null, null, 'h', 'a', 'm'],
        [null, null, null, 'e', null, null],
        [null, null, null, 'l', null, null],
        ['w', 'o', 'r', 'l', 'd', null],
        [null, null, null, 'o', null, null],
      ],
      [
        [null, 'h', 'a', 'm', null],
        [null, 'e', null, null, null],
        [null, 'l', null, null, null],
        [null, 'l', null, null, null],
        ['w', 'o', 'r', 'l', 'd'],
      ],
      [
        [null, null, 'w', null, null],
        [null, null, 'o', null, null],
        [null, null, 'r', null, null],
        ['h', 'e', 'l', 'l', 'o'],
        ['a', null, 'd', null, null],
        ['m', null, null, null, null],
      ],
      [
        [null, null, null, 'w', null],
        [null, null, null, 'o', null],
        [null, null, null, 'r', null],
        ['h', 'e', 'l', 'l', 'o'],
        ['a', null, null, 'd', null],
        ['m', null, null, null, null],
      ],
      [
        [null, null, null, null, 'w'],
        ['h', 'e', 'l', 'l', 'o'],
        ['a', null, null, null, 'r'],
        ['m', null, null, null, 'l'],
        [null, null, null, null, 'd'],
      ]
    ];
    final List<Crossword> crosswords =
        generateCrosswords(['hello', 'world', 'ham']);
    expect(crosswords.length, 6);
    final options =
        crosswords.map((crossword) => crossword.grid.toList()).toList();
    expect(options, containsAll(expectedResults));
    expectCrosswordsSortedByScore(crosswords);
  });

  test('Test crossword from list with no crossover letters', () {
    final List<Crossword> crosswords = generateCrosswords(['hello', 'zany']);
    expect(crosswords.length, 0);
  });

  group('Test placeWord', () {
    test('Test placeWord with no conflicts', () {
      final Crossword crossword = Crossword.startWithHorizontalWord('hello');
      final PositionedWord word = PositionedWord.vertical(
        word: 'world',
        start: const Coordinates(x: 3, y: -3),
      );
      final Crossword? newCrossword =
          placeWord(crossword, word, ['hello', 'world'], []);
      expect(newCrossword, isNotNull);
      expect(newCrossword!.placedWords, contains(word));
    });

    test('Test placeWord with conflicts', () {
      final Crossword crossword = Crossword.startWithHorizontalWord('hello');
      final PositionedWord word = PositionedWord.vertical(
        word: 'world',
        start: const Coordinates(x: 3, y: -4),
      );
      final Crossword? newCrossword =
          placeWord(crossword, word, ['hello', 'world'], []);
      expect(newCrossword, isNull);
    });

    test('Test placeWord with perfect overlap', () {
      final PositionedWord shop = PositionedWord.horizontal(
        word: 'shop',
        start: const Coordinates(x: 0, y: 0),
      );
      final PositionedWord paws = PositionedWord.vertical(
        word: 'paws',
        start: const Coordinates(x: 0, y: -3),
      );
      final PositionedWord greeds = PositionedWord.vertical(
        word: 'greeds',
        start: const Coordinates(x: 0, y: -5),
      );
      final Crossword crossword = Crossword([shop, paws]);
      

      final Crossword? newCrossword = placeWord(
        crossword,
        greeds,
        ['shop', 'paws', 'greeds'],
        [],
      );
      expect(newCrossword, isNull);
    });

    test('Test placeWord with accidental placement', () {
      final PositionedWord thomas = PositionedWord.horizontal(
        word: 'thomas',
        start: const Coordinates(x: 0, y: 0),
      );
      final PositionedWord chest = PositionedWord.vertical(
        word: 'chest',
        start: const Coordinates(x: 0, y: -4),
      );
      final PositionedWord alamo = PositionedWord.vertical(
        word: 'alamo',
        start: const Coordinates(x: 2, y: -4),
      );
      final PositionedWord ahead = PositionedWord.vertical(
        word: 'ahead',
        start: const Coordinates(x: 1, y: -1),
      );
      final PositionedWord sam = PositionedWord.horizontal(
        word: 'sam',
        start: const Coordinates(x: 0, y: -1),
      );
      final Crossword crossword = Crossword([thomas, chest, alamo]);
      print(crossword.toPrettyString());
      final Crossword? newCrossword = placeWord(
        crossword,
        ahead,
        ['thomas', 'chest', 'alamo', 'ahead', 'sam'],
        ['sam'],
      );
      expect(newCrossword, isNotNull);
      expect(newCrossword!.placedWords, contains(ahead));
      expect(newCrossword.placedWords, contains(sam));
    });
  });
}
