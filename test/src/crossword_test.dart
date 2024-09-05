import 'package:crossword_generator/crossword_generator.dart';
import 'package:test/test.dart';

void main() {
  group('Test constructors', () {
    test('Test empty constructor', () {
      final Crossword crossword = Crossword.empty();

      expect(crossword.placedWords.isEmpty, isTrue);
      expect(crossword.grid.isEmpty, isTrue);
    });

    test('Test startWithHorizontalWord constructor', () {
      final Crossword crossword = Crossword.startWithHorizontalWord('hello');

      expect(crossword.placedWords.length, 1);
      expect(crossword.placedWords.first.word, 'hello');
      expect(crossword.placedWords.first.start.x, 0);
      expect(crossword.placedWords.first.start.y, 0);
      expect(crossword.placedWords.first.end.x, 4);
      expect(crossword.placedWords.first.end.y, 0);

      expect(crossword.grid.isEmpty, isFalse);
      List<List<String?>> grid = crossword.grid.toList();
      expect(grid.length, 1);
      expect(grid[0].length, 5);
      expect(grid, [
        ['h', 'e', 'l', 'l', 'o'],
      ]);
    });

    test('Test startWithVerticalWord constructor', () {
      final Crossword crossword = Crossword.startWithVerticalWord('hello');

      expect(crossword.placedWords.length, 1);
      expect(crossword.placedWords.first.word, 'hello');
      expect(crossword.placedWords.first.start.x, 0);
      expect(crossword.placedWords.first.start.y, 0);
      expect(crossword.placedWords.first.end.x, 0);
      expect(crossword.placedWords.first.end.y, 4);

      expect(crossword.grid.isEmpty, isFalse);
      List<List<String?>> grid = crossword.grid.toList();
      expect(grid.length, 5);
      for (int i = 0; i < 5; i++) {
        expect(grid[i].length, 1);
      }
      expect(grid, [
        ['h'],
        ['e'],
        ['l'],
        ['l'],
        ['o'],
      ]);
    });

    test('Test from list constructor', () {
      List<PositionedWord> words = [
        PositionedWord.horizontal(
            word: 'hello', start: const Coordinates(x: 0, y: 0)),
        PositionedWord.vertical(
            word: 'world', start: const Coordinates(x: 4, y: -1)),
        PositionedWord.vertical(
            word: 'ham', start: const Coordinates(x: 0, y: 0)),
      ];

      final Crossword crossword = Crossword(words);

      expect(crossword.placedWords.length, 3);
      expect(crossword.placedWords, containsAll(words));

      expect(crossword.grid.isEmpty, isFalse);
      List<List<String?>> grid = crossword.grid.toList();
      expect(grid.length, 5);
      expect(grid[0].length, 5);
      expect(grid, [
        [null, null, null, null, 'w'],
        ['h', 'e', 'l', 'l', 'o'],
        ['a', null, null, null, 'r'],
        ['m', null, null, null, 'l'],
        [null, null, null, null, 'd'],
      ]);
    });
  });

  group('Test copyWith', () {
    test('Test copyWith empty', () {
      final Crossword crossword = Crossword.startWithHorizontalWord('hello');
      final Crossword newCrossword = crossword.copyWith();

      expect(newCrossword.placedWords, crossword.placedWords);
      expect(newCrossword.grid, crossword.grid);
    });

    test('Test copyWith with new words', () {
      final Crossword crossword = Crossword.startWithHorizontalWord('hello');
      final Crossword newCrossword = crossword.copyWith([
        PositionedWord.vertical(
            word: 'world', start: const Coordinates(x: 4, y: -1)),
        PositionedWord.vertical(
            word: 'ham', start: const Coordinates(x: 0, y: 0)),
      ]);

      expect(newCrossword.placedWords.length, 3);
      expect(
          newCrossword.placedWords,
          containsAll([
            PositionedWord.horizontal(
                word: 'hello', start: const Coordinates(x: 0, y: 0)),
            PositionedWord.vertical(
                word: 'world', start: const Coordinates(x: 4, y: -1)),
            PositionedWord.vertical(
                word: 'ham', start: const Coordinates(x: 0, y: 0)),
          ]));

      expect(newCrossword.grid.isEmpty, isFalse);
      List<List<String?>> grid = newCrossword.grid.toList();
      expect(grid.length, 5);
      expect(grid[0].length, 5);
      expect(grid, [
        [null, null, null, null, 'w'],
        ['h', 'e', 'l', 'l', 'o'],
        ['a', null, null, null, 'r'],
        ['m', null, null, null, 'l'],
        [null, null, null, null, 'd'],
      ]);
    });
  });

  test('Test addWord', () {
    final Crossword crossword = Crossword.startWithHorizontalWord('hello');
    final Crossword newCrossword = crossword.addWord(PositionedWord.vertical(
        word: 'world', start: const Coordinates(x: 4, y: -1)));
    expect(newCrossword.placedWords.length, 2);
    expect(
        newCrossword.placedWords,
        containsAll([
          PositionedWord.horizontal(
              word: 'hello', start: const Coordinates(x: 0, y: 0)),
          PositionedWord.vertical(
              word: 'world', start: const Coordinates(x: 4, y: -1)),
        ]));

    expect(newCrossword.grid.isEmpty, isFalse);
    List<List<String?>> grid = newCrossword.grid.toList();
    expect(grid.length, 5);
    expect(grid[0].length, 5);
    expect(grid, [
      [null, null, null, null, 'w'],
      ['h', 'e', 'l', 'l', 'o'],
      [null, null, null, null, 'r'],
      [null, null, null, null, 'l'],
      [null, null, null, null, 'd'],
    ]);
  });

  group('Test getWord functions', () {
    group('Test getHorizontalWord', () {
      final Crossword crossword = Crossword.startWithHorizontalWord('hello');
      test('Test getHorizontalWord start coord', () {
        final PositionedWord? word =
            crossword.getHorizontalWord(const Coordinates(x: 0, y: 0));

        expect(word, isNotNull);
        expect(word!.word, 'hello');
        expect(word.start, const Coordinates(x: 0, y: 0));
        expect(word.end, const Coordinates(x: 4, y: 0));
      });

      test('Test getHorizontalWord middle coord', () {
        final PositionedWord? word =
            crossword.getHorizontalWord(const Coordinates(x: 2, y: 0));

        expect(word, isNotNull);
        expect(word!.word, 'hello');
        expect(word.start, const Coordinates(x: 0, y: 0));
        expect(word.end, const Coordinates(x: 4, y: 0));
      });

      test('Test getHorizontalWord end coord', () {
        final PositionedWord? word =
            crossword.getHorizontalWord(const Coordinates(x: 4, y: 0));

        expect(word, isNotNull);
        expect(word!.word, 'hello');
        expect(word.start, const Coordinates(x: 0, y: 0));
        expect(word.end, const Coordinates(x: 4, y: 0));
      });

      test('Test getHorizontalWord outside coord', () {
        final PositionedWord? word =
            crossword.getHorizontalWord(const Coordinates(x: 5, y: 0));

        expect(word, isNull);
      });
    });

    group('Test getVerticalWord', () {
      final Crossword crossword = Crossword.startWithVerticalWord('hello');
      test('Test getVerticalWord start coord', () {
        final PositionedWord? word =
            crossword.getVerticalWord(const Coordinates(x: 0, y: 0));

        expect(word, isNotNull);
        expect(word!.word, 'hello');
        expect(word.start, const Coordinates(x: 0, y: 0));
        expect(word.end, const Coordinates(x: 0, y: 4));
      });

      test('Test getVerticalWord middle coord', () {
        final PositionedWord? word =
            crossword.getVerticalWord(const Coordinates(x: 0, y: 2));

        expect(word, isNotNull);
        expect(word!.word, 'hello');
        expect(word.start, const Coordinates(x: 0, y: 0));
        expect(word.end, const Coordinates(x: 0, y: 4));
      });

      test('Test getVerticalWord end coord', () {
        final PositionedWord? word =
            crossword.getVerticalWord(const Coordinates(x: 0, y: 4));

        expect(word, isNotNull);
        expect(word!.word, 'hello');
        expect(word.start, const Coordinates(x: 0, y: 0));
        expect(word.end, const Coordinates(x: 0, y: 4));
      });

      test('Test getVerticalWord outside coord', () {
        final PositionedWord? word =
            crossword.getVerticalWord(const Coordinates(x: 0, y: 5));

        expect(word, isNull);
      });
    });

    group('Test getWordsPassingThroughCoordinates', () {
      test('Test getWordsPassingThroughCoordinates at intersection point', () {
        final Crossword crossword = Crossword([
          PositionedWord.horizontal(
              word: 'hello', start: const Coordinates(x: 0, y: 0)),
          PositionedWord.vertical(
              word: 'world', start: const Coordinates(x: 4, y: -1)),
          PositionedWord.vertical(
              word: 'ham', start: const Coordinates(x: 0, y: 0)),
        ]);

        final List<PositionedWord> words = crossword
            .getWordsPassingThroughCoordinates(const Coordinates(x: 0, y: 0));

        expect(words.length, 2);
        expect(
            words,
            containsAll([
              PositionedWord.horizontal(
                  word: 'hello', start: const Coordinates(x: 0, y: 0)),
              PositionedWord.vertical(
                  word: 'ham', start: const Coordinates(x: 0, y: 0)),
            ]));
      });

      test('Test getWordsPassingThroughCoordinates outside', () {
        final Crossword crossword = Crossword([
          PositionedWord.horizontal(
              word: 'hello', start: const Coordinates(x: 0, y: 0)),
          PositionedWord.vertical(
              word: 'world', start: const Coordinates(x: 4, y: -1)),
          PositionedWord.vertical(
              word: 'ham', start: const Coordinates(x: 0, y: 0)),
        ]);

        final List<PositionedWord> words = crossword
            .getWordsPassingThroughCoordinates(const Coordinates(x: 5, y: 0));

        expect(words.isEmpty, isTrue);
      });

      test('Test getWordsPassingThroughCoordinates empty', () {
        final Crossword crossword = Crossword.empty();

        final List<PositionedWord> words = crossword
            .getWordsPassingThroughCoordinates(const Coordinates(x: 0, y: 0));

        expect(words.isEmpty, isTrue);
      });

      test('Test getWordsPassingThroughCoordinates single horizontal', () {
        final Crossword crossword = Crossword.startWithHorizontalWord('hello');

        final List<PositionedWord> words = crossword
            .getWordsPassingThroughCoordinates(const Coordinates(x: 0, y: 0));
        expect(words.length, 1,
            reason:
                'Should only return the single word, as single letters are not considered words');
        expect(
            words,
            containsAll([
              PositionedWord.horizontal(
                  word: 'hello', start: const Coordinates(x: 0, y: 0)),
            ]));
      });

      test('Test getWordsPassingThroughCoordinates single vertical', () {
        final Crossword crossword = Crossword.startWithVerticalWord('hello');

        final List<PositionedWord> words = crossword
            .getWordsPassingThroughCoordinates(const Coordinates(x: 0, y: 0));
        expect(words.length, 1,
            reason:
                'Should only return the single word, as single letters are not considered words');
        expect(
            words,
            containsAll([
              PositionedWord.vertical(
                  word: 'hello', start: const Coordinates(x: 0, y: 0)),
            ]));
      });

      test('Test getWordsPassingThroughCoordinates single letter', () {
        final Crossword crossword = Crossword.empty();
        crossword.grid.set(const Coordinates(x: 0, y: 0), 'a');

        final List<PositionedWord> words = crossword
            .getWordsPassingThroughCoordinates(const Coordinates(x: 0, y: 0));
        expect(words.isEmpty, isTrue,
            reason:
                'Should not return any words, as single letters are not considered words');
      });
    });
  });

  group('Test score getter', () {
    test('Test score with empty crossword', () {
      final Crossword crossword = Crossword.empty();

      expect(crossword.score, 0);
    });

    test('Test score with single horizontal word crossword', () {
      final Crossword crossword = Crossword.startWithHorizontalWord('hello');
      expect(crossword.score, double.infinity);
    });

    test('Test score with single vertical word crossword', () {
      final Crossword crossword = Crossword.startWithVerticalWord('hello');
      expect(crossword.score, double.infinity);
    });

    test('Test score with good complex crossword', () {
      final Crossword crossword = Crossword([
        PositionedWord.horizontal(
            word: 'game', start: const Coordinates(x: 4, y: 0)),
        PositionedWord.vertical(
            word: 'greeds', start: const Coordinates(x: 4, y: 0)),
        PositionedWord.horizontal(
            word: 'shop', start: const Coordinates(x: 4, y: 5)),
        PositionedWord.vertical(
            word: 'paws', start: const Coordinates(x: 10, y: 0)),
        PositionedWord.vertical(
            word: 'simplify', start: const Coordinates(x: 7, y: 2)),
        PositionedWord.vertical(
            word: 'ballet', start: const Coordinates(x: 2, y: 1)),
        PositionedWord.vertical(
            word: 'puffed', start: const Coordinates(x: 0, y: 2)),
        PositionedWord.horizontal(
            word: 'pealed', start: const Coordinates(x: 0, y: 2)),
        PositionedWord.horizontal(
            word: 'kills', start: const Coordinates(x: 6, y: 3)),
        PositionedWord.horizontal(
            word: 'fig', start: const Coordinates(x: 6, y: 7)),
      ]);
      // The result should be close to 21.92672999: https://www.baeldung.com/cs/generate-crossword-puzzle
      expect(crossword.score, closeTo(21.92672999, 0.00000001));
    });

    test('Test score with bad complex crossword', () {
      final Crossword crossword = Crossword([
        PositionedWord.horizontal(
            word: 'mania', start: const Coordinates(x: 0, y: 2)),
        PositionedWord.vertical(
            word: 'odious', start: const Coordinates(x: 3, y: 0)),
        PositionedWord.horizontal(
            word: 'unapproved', start: const Coordinates(x: 3, y: 4)),
        PositionedWord.vertical(
            word: 'doodle', start: const Coordinates(x: 12, y: 4)),
        PositionedWord.horizontal(
            word: 'legs', start: const Coordinates(x: 12, y: 8)),
        PositionedWord.vertical(
            word: 'graveyard', start: const Coordinates(x: 14, y: 8)),
      ]);
      // The result should be close to 12.3653512: https://www.baeldung.com/cs/generate-crossword-puzzle
      expect(crossword.score, closeTo(12.3653512, 0.00000001));
    });
  });
}
