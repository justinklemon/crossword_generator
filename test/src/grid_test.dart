import 'package:crossword_generator/crossword_generator.dart';
import 'package:test/test.dart';

void main() {
  test('Grid', () {
    final grid = Grid<int>();
    expect(grid.contains(const Coordinates(x: 0, y: 0)), isFalse);
    grid.set(const Coordinates(x: 0, y: 0), 42);
    expect(grid.contains(const Coordinates(x: 0, y: 0)), isTrue);
    expect(grid.get(const Coordinates(x: 0, y: 0)), 42);
    grid.remove(const Coordinates(x: 0, y: 0));
    expect(grid.contains(const Coordinates(x: 0, y: 0)), isFalse);

    grid.set(const Coordinates(x: -2, y: 3), 42);
    expect(grid.contains(const Coordinates(x: -2, y: 3)), isTrue);
    expect(grid.get(const Coordinates(x: -2, y: 3)), 42);
    grid.remove(const Coordinates(x: -2, y: 3));
    expect(grid.contains(const Coordinates(x: -2, y: 3)), isFalse);

    grid.set(const Coordinates(x: 0, y: -7), 42);
    expect(grid.contains(const Coordinates(x: 0, y: -7)), isTrue);
    expect(grid.get(const Coordinates(x: 0, y: -7)), 42);
    grid.remove(const Coordinates(x: 0, y: -7));
    expect(grid.contains(const Coordinates(x: 0, y: -7)), isFalse);
  });

  test('Grid minXindex', () {
    final grid = Grid<int>();
    grid.set(const Coordinates(x: 0, y: 0), 42);
    grid.set(const Coordinates(x: 1, y: 0), 42);
    grid.set(const Coordinates(x: 2, y: 0), 42);
    expect(grid.minXindex, 0);
    grid.set(const Coordinates(x: -1, y: 0), 42);
    expect(grid.minXindex, -1);
    grid.set(const Coordinates(x: 4, y: 0), 42);
    expect(grid.minXindex, -1);
  });

  test('Grid maxXindex', () {
    final grid = Grid<int>();
    grid.set(const Coordinates(x: 0, y: 0), 42);
    grid.set(const Coordinates(x: 1, y: 0), 42);
    grid.set(const Coordinates(x: 2, y: 0), 42);
    expect(grid.maxXindex, 2);
    grid.set(const Coordinates(x: -1, y: 0), 42);
    expect(grid.maxXindex, 2);
    grid.set(const Coordinates(x: 4, y: 0), 42);
    expect(grid.maxXindex, 4);
  });

  test('Grid minYindex', () {
    final grid = Grid<int>();
    grid.set(const Coordinates(x: 0, y: 0), 42);
    grid.set(const Coordinates(x: 0, y: 1), 42);
    grid.set(const Coordinates(x: 0, y: 2), 42);
    expect(grid.minYindex, 0);
    grid.set(const Coordinates(x: 0, y: -1), 42);
    expect(grid.minYindex, -1);
    grid.set(const Coordinates(x: 0, y: 4), 42);
    expect(grid.minYindex, -1);
  });

  test('Grid maxYindex', () {
    final grid = Grid<int>();
    grid.set(const Coordinates(x: 0, y: 0), 42);
    grid.set(const Coordinates(x: 0, y: 1), 42);
    grid.set(const Coordinates(x: 0, y: 2), 42);
    expect(grid.maxYindex, 2);
    grid.set(const Coordinates(x: 0, y: -1), 42);
    expect(grid.maxYindex, 2);
    grid.set(const Coordinates(x: 0, y: 4), 42);
    expect(grid.maxYindex, 4);
  });

  group('Grid coordinates', () {
    test('Grid coordinates empty grid', () {
      final grid = Grid<int>();
      expect(grid.coordinates, isEmpty);
    });

    test('Grid coordinates single item grid', () {
      final grid = Grid<int>();
      grid.set(const Coordinates(x: 0, y: 0), 42);
      expect(grid.coordinates, [const Coordinates(x: 0, y: 0)]);
    });

    test('Grid coordinates multiple items grid', () {
      final grid = Grid<int>();
      grid.set(const Coordinates(x: 0, y: 0), 42);
      grid.set(const Coordinates(x: 1, y: 0), 42);
      grid.set(const Coordinates(x: 0, y: 1), 42);
      expect(
          grid.coordinates,
          containsAll([
            const Coordinates(x: 0, y: 0),
            const Coordinates(x: 1, y: 0),
            const Coordinates(x: 0, y: 1),
          ]));
    });

    test('Grid coordinates after removing items', () {
      final grid = Grid<int>();
      grid.set(const Coordinates(x: 0, y: 0), 42);
      grid.set(const Coordinates(x: 1, y: 0), 42);
      grid.set(const Coordinates(x: 0, y: 1), 42);
      grid.remove(const Coordinates(x: 0, y: 0));
      expect(
          grid.coordinates,
          containsAll([
            const Coordinates(x: 1, y: 0),
            const Coordinates(x: 0, y: 1),
          ]));
      expect(grid.coordinates.length, 2);
    });
  });

  group('Test toString methods', () {
    Grid<String> grid = Grid<String>();
    setUpAll(() {
      grid = Grid<String>();
      grid.set(const Coordinates(x: 0, y: 0), 'H');
      grid.set(const Coordinates(x: 1, y: 0), 'E');
      grid.set(const Coordinates(x: 2, y: 0), 'L');
      grid.set(const Coordinates(x: 3, y: 0), 'L');
      grid.set(const Coordinates(x: 4, y: 0), 'O');
      grid.set(const Coordinates(x: 0, y: 1), 'A');
      grid.set(const Coordinates(x: 0, y: 2), 'M');
      grid.set(const Coordinates(x: 4, y: -1), 'W');
      grid.set(const Coordinates(x: 4, y: 1), 'R');
      grid.set(const Coordinates(x: 4, y: 2), 'L');
      grid.set(const Coordinates(x: 4, y: 3), 'D');
    });
    test('Test toString', () {
      String expectedString = '''(0, 0): H
(0, 1): A
(0, 2): M
(1, 0): E
(2, 0): L
(3, 0): L
(4, 0): O
(4, -1): W
(4, 1): R
(4, 2): L
(4, 3): D
''';
      expect(grid.toString(), expectedString);
    });

    test('Test toPrettyString', () {
      String expectedPrettyString = '''Top-left: (0, -1)
Bottom-right: (4, 3)

        W 
H E L L O 
A       R 
M       L 
        D 
''';
      expect(grid.toPrettyString(), expectedPrettyString);
    });
  });

  group('Test toList', () {
    test('Test empty grid', () {
      final grid = Grid<int>();
      expect(grid.toList(), []);
    });

    test('Test non-empty/full square grid', () {
      final grid = Grid<int>();
      grid.set(const Coordinates(x: 0, y: 0), 1);
      grid.set(const Coordinates(x: 1, y: 0), 2);
      grid.set(const Coordinates(x: 2, y: 0), 3);
      grid.set(const Coordinates(x: 0, y: 1), 4);
      grid.set(const Coordinates(x: 1, y: 1), 5);
      grid.set(const Coordinates(x: 2, y: 1), 6);
      grid.set(const Coordinates(x: 0, y: 2), 7);
      grid.set(const Coordinates(x: 1, y: 2), 8);
      grid.set(const Coordinates(x: 2, y: 2), 9);
      expect(grid.toList(), [
        [1, 2, 3],
        [4, 5, 6],
        [7, 8, 9],
      ]);
    });

    test('Test square grid with blank spaces', () {
      final grid = Grid<int>();
      grid.set(const Coordinates(x: 0, y: 0), 1);
      grid.set(const Coordinates(x: 1, y: 0), 2);
      grid.set(const Coordinates(x: 2, y: 0), 3);
      grid.set(const Coordinates(x: 0, y: 1), 4);
      grid.set(const Coordinates(x: 2, y: 1), 6);
      grid.set(const Coordinates(x: 0, y: 2), 7);
      grid.set(const Coordinates(x: 1, y: 2), 8);
      expect(grid.toList(), [
        [1, 2, 3],
        [4, null, 6],
        [7, 8, null],
      ]);
    });

    test('Test non-uniform grid', () {
      final grid = Grid<String>();
      grid.set(const Coordinates(x: 0, y: 0), 'H');
      grid.set(const Coordinates(x: 1, y: 0), 'E');
      grid.set(const Coordinates(x: 2, y: 0), 'L');
      grid.set(const Coordinates(x: 3, y: 0), 'L');
      grid.set(const Coordinates(x: 4, y: 0), 'O');
      grid.set(const Coordinates(x: 0, y: 1), 'A');
      grid.set(const Coordinates(x: 0, y: 2), 'M');
      grid.set(const Coordinates(x: 4, y: -1), 'W');
      grid.set(const Coordinates(x: 4, y: 1), 'R');
      grid.set(const Coordinates(x: 4, y: 2), 'L');
      grid.set(const Coordinates(x: 4, y: 3), 'D');
      expect(grid.toList(), [
        [null, null, null, null, 'W'],
        ['H', 'E', 'L', 'L', 'O'],
        ['A', null, null, null, 'R'],
        ['M', null, null, null, 'L'],
        [null, null, null, null, 'D'],
      ]);
    });
  });

  group('Test isEmpty', () {
    test('Test empty grid', () {
      final grid = Grid<int>();
      expect(grid.isEmpty, isTrue);
    });

    test('Test non-empty grid', () {
      final grid = Grid<int>();
      grid.set(const Coordinates(x: 0, y: 0), 42);
      expect(grid.isEmpty, isFalse);
    });
  });

  group('Test equality operators', () {
    group('Test hashcode', () {
      test('Test hashCode empty grids', () {
        final grid1 = Grid<int>();
        final grid2 = Grid<int>();
        expect(grid1.hashCode, grid2.hashCode);
      });

      test('Test hashCode single item grid', () {
        final grid1 = Grid<int>();
        final grid2 = Grid<int>();
        grid1.set(const Coordinates(x: 0, y: 0), 42);
        grid2.set(const Coordinates(x: 0, y: 0), 42);
        expect(grid1.hashCode, grid2.hashCode);
      });

      test('Test hashcode multiple items added in the same order', () {
        final grid1 = Grid<int>();
        final grid2 = Grid<int>();
        grid1.set(const Coordinates(x: 0, y: 0), 42);
        grid1.set(const Coordinates(x: 1, y: 0), 43);
        grid1.set(const Coordinates(x: 0, y: 1), 44);
        grid2.set(const Coordinates(x: 0, y: 0), 42);
        grid2.set(const Coordinates(x: 1, y: 0), 43);
        grid2.set(const Coordinates(x: 0, y: 1), 44);
        expect(grid1.hashCode, grid2.hashCode);
      });

      test('Test hashcode multiple items added in different order', () {
        final grid1 = Grid<int>();
        final grid2 = Grid<int>();
        grid1.set(const Coordinates(x: 0, y: 0), 42);
        grid1.set(const Coordinates(x: 1, y: 0), 43);
        grid1.set(const Coordinates(x: 0, y: 1), 44);
        grid2.set(const Coordinates(x: 0, y: 1), 44);
        grid2.set(const Coordinates(x: 1, y: 0), 43);
        grid2.set(const Coordinates(x: 0, y: 0), 42);
        expect(grid1.hashCode, grid2.hashCode);
      });

      test('Test hashcode different grids', () {
        final grid1 = Grid<int>();
        final grid2 = Grid<int>();
        grid1.set(const Coordinates(x: 0, y: 0), 42);
        grid2.set(const Coordinates(x: 0, y: 0), 43);
        expect(grid1.hashCode, isNot(grid2.hashCode));
      });
    });

    group('Test ==', () {
      test('Test == empty grids', () {
        final grid1 = Grid<int>();
        final grid2 = Grid<int>();
        expect(grid1, grid2);
      });

      test('Test == single item grid', () {
        final grid1 = Grid<int>();
        final grid2 = Grid<int>();
        grid1.set(const Coordinates(x: 0, y: 0), 42);
        grid2.set(const Coordinates(x: 0, y: 0), 42);
        expect(grid1, grid2);
      });

      test('Test == multiple items added in the same order', () {
        final grid1 = Grid<int>();
        final grid2 = Grid<int>();
        grid1.set(const Coordinates(x: 0, y: 0), 42);
        grid1.set(const Coordinates(x: 1, y: 0), 43);
        grid1.set(const Coordinates(x: 0, y: 1), 44);
        grid2.set(const Coordinates(x: 0, y: 0), 42);
        grid2.set(const Coordinates(x: 1, y: 0), 43);
        grid2.set(const Coordinates(x: 0, y: 1), 44);
        expect(grid1, grid2);
      });

      test('Test == multiple items added in different order', () {
        final grid1 = Grid<int>();
        final grid2 = Grid<int>();
        grid1.set(const Coordinates(x: 0, y: 0), 42);
        grid1.set(const Coordinates(x: 1, y: 0), 43);
        grid1.set(const Coordinates(x: 0, y: 1), 44);
        grid2.set(const Coordinates(x: 0, y: 1), 44);
        grid2.set(const Coordinates(x: 1, y: 0), 43);
        grid2.set(const Coordinates(x: 0, y: 0), 42);
        expect(grid1, grid2);
      });

      test('Test == different grids', () {
        final grid1 = Grid<int>();
        final grid2 = Grid<int>();
        grid1.set(const Coordinates(x: 0, y: 0), 42);
        grid2.set(const Coordinates(x: 0, y: 0), 43);
        expect(grid1, isNot(grid2));
      });
    });

    group('Test relativeHashCode', () {
      test('Test relativeHashCode empty grids', () {
        final grid1 = Grid<int>();
        final grid2 = Grid<int>();
        expect(grid1.relativeHashCode, grid2.relativeHashCode);
      });

      test('Test relativeHashCode single item grid, same place', () {
        final grid1 = Grid<int>();
        final grid2 = Grid<int>();
        grid1.set(const Coordinates(x: 0, y: 0), 42);
        grid2.set(const Coordinates(x: 0, y: 0), 42);
        expect(grid1.relativeHashCode, grid2.relativeHashCode);
      });

      test('Test relativeHashCode single item grid, different place', () {
        final grid1 = Grid<int>();
        final grid2 = Grid<int>();
        grid1.set(const Coordinates(x: 0, y: 0), 42);
        grid2.set(const Coordinates(x: 1, y: 0), 42);
        expect(grid1.relativeHashCode, grid2.relativeHashCode);
      });

      test(
          'Test relativeHashCode multiple items added in the same order to the same places',
          () {
        final grid1 = Grid<int>();
        final grid2 = Grid<int>();
        grid1.set(const Coordinates(x: 0, y: 0), 42);
        grid1.set(const Coordinates(x: 1, y: 0), 43);
        grid1.set(const Coordinates(x: 0, y: 1), 44);
        grid2.set(const Coordinates(x: 0, y: 0), 42);
        grid2.set(const Coordinates(x: 1, y: 0), 43);
        grid2.set(const Coordinates(x: 0, y: 1), 44);
        expect(grid1.relativeHashCode, grid2.relativeHashCode);
      });

      test(
          'Test relativeHashCode multiple items added in the same order to different places',
          () {
        final grid1 = Grid<int>();
        final grid2 = Grid<int>();
        // grid1:
        // 42 43
        // 44 __
        // grid2:
        // __ __
        // __ 42 43
        // __ 44
        grid1.set(const Coordinates(x: 0, y: 0), 42);
        grid1.set(const Coordinates(x: 1, y: 0), 43);
        grid1.set(const Coordinates(x: 0, y: 1), 44);
        grid2.set(const Coordinates(x: 1, y: 1), 42);
        grid2.set(const Coordinates(x: 2, y: 1), 43);
        grid2.set(const Coordinates(x: 1, y: 2), 44);

        expect(grid1.relativeHashCode, grid2.relativeHashCode);
      });

      test(
          'Test relativeHashCode multiple items added in different order to the same places',
          () {
        final grid1 = Grid<int>();
        final grid2 = Grid<int>();
        grid1.set(const Coordinates(x: 0, y: 0), 42);
        grid1.set(const Coordinates(x: 1, y: 0), 43);
        grid1.set(const Coordinates(x: 0, y: 1), 44);
        grid2.set(const Coordinates(x: 0, y: 1), 44);
        grid2.set(const Coordinates(x: 1, y: 0), 43);
        grid2.set(const Coordinates(x: 0, y: 0), 42);
        expect(grid1.relativeHashCode, grid2.relativeHashCode);
      });

      test(
          'Test relativeHashCode items added in different order with one item moving to a different column',
          () {
        final grid1 = Grid<int>();
        final grid2 = Grid<int>();
        // grid1:
        // 42 43
        // 44 __
        // grid2:
        // __ __ __
        // __ 42 43
        // __ __ 44
        grid1.set(const Coordinates(x: 0, y: 0), 42);
        grid1.set(const Coordinates(x: 1, y: 0), 43);
        grid1.set(const Coordinates(x: 0, y: 1), 44);
        grid2.set(const Coordinates(x: 2, y: 2), 44);
        grid2.set(const Coordinates(x: 2, y: 1), 43);
        grid2.set(const Coordinates(x: 1, y: 1), 42);

        expect(grid1.relativeHashCode, isNot(grid2.relativeHashCode));
      });
      test('Test relativeHashCode extra row between items', () {
        final grid1 = Grid<int>();
        final grid2 = Grid<int>();
        // grid1:
        // 42 43
        // 44 __
        // grid2:
        // 42 43
        // __ __
        // 44 __
        grid1.set(const Coordinates(x: 0, y: 0), 42);
        grid1.set(const Coordinates(x: 1, y: 0), 43);
        grid1.set(const Coordinates(x: 0, y: 1), 44);
        grid2.set(const Coordinates(x: 0, y: 2), 44);
        grid2.set(const Coordinates(x: 1, y: 0), 43);
        grid2.set(const Coordinates(x: 0, y: 0), 42);

        expect(grid1.relativeHashCode, isNot(grid2.relativeHashCode));
      });

      test('Test relativeHashCode extra column between items', () {
        final grid1 = Grid<int>();
        final grid2 = Grid<int>();
        // grid1:
        // 42 43
        // 44 __
        // grid2:
        // 42 __ 43
        // 44 __
        grid1.set(const Coordinates(x: 0, y: 0), 42);
        grid1.set(const Coordinates(x: 1, y: 0), 43);
        grid1.set(const Coordinates(x: 0, y: 1), 44);
        grid2.set(const Coordinates(x: 0, y: 1), 44);
        grid2.set(const Coordinates(x: 2, y: 0), 43);
        grid2.set(const Coordinates(x: 0, y: 0), 42);
        expect(grid1.relativeHashCode, isNot(grid2.relativeHashCode));
      });

      test(
          'Test relativeHashCode extra row between items - one item per column',
          () {
        final grid1 = Grid<int>();
        final grid2 = Grid<int>();
        // grid1:
        // 42 __
        // __ 43
        // grid2:
        // 42 __
        // __ __
        // __ 43
        grid1.set(const Coordinates(x: 0, y: 0), 42);
        grid1.set(const Coordinates(x: 1, y: 1), 43);

        grid2.set(const Coordinates(x: 0, y: 0), 42);
        grid2.set(const Coordinates(x: 2, y: 1), 43);

        expect(grid1.relativeHashCode, isNot(grid2.relativeHashCode));
      });

      test('Test relativeHashCode different grids', () {
        final grid1 = Grid<int>();
        final grid2 = Grid<int>();
        grid1.set(const Coordinates(x: 0, y: 0), 42);
        grid2.set(const Coordinates(x: 0, y: 0), 43);
        expect(grid1.relativeHashCode, isNot(grid2.relativeHashCode));
      });

      test('Test relativeHashCode single item grids with negative y value ',() {
        final grid1 = Grid<int>();
        final grid2 = Grid<int>();
        grid1.set(const Coordinates(x: 0, y: 0), 42);
        grid2.set(const Coordinates(x: 0, y: -1), 42);
        expect(grid1.relativeHashCode, grid2.relativeHashCode);
      });
    });

    group('Test isRelativelyEquivalent', () {
      test('Test isRelativelyEquivalent empty grids', () {
        final grid1 = Grid<int>();
        final grid2 = Grid<int>();
        expect(grid1.isRelativelyEquivalent(grid2), isTrue);
      });

      test('Test isRelativelyEquivalent single item grid, same place', () {
        final grid1 = Grid<int>();
        final grid2 = Grid<int>();
        grid1.set(const Coordinates(x: 0, y: 0), 42);
        grid2.set(const Coordinates(x: 0, y: 0), 42);
        expect(grid1.isRelativelyEquivalent(grid2), isTrue);
      });

      test('Test isRelativelyEquivalent single item grid, different place', () {
        final grid1 = Grid<int>();
        final grid2 = Grid<int>();
        grid1.set(const Coordinates(x: 0, y: 0), 42);
        grid2.set(const Coordinates(x: 1, y: 0), 42);
        expect(grid1.isRelativelyEquivalent(grid2), isTrue);
      });

      test(
          'Test isRelativelyEquivalent multiple items added in the same order to the same places',
          () {
        final grid1 = Grid<int>();
        final grid2 = Grid<int>();
        grid1.set(const Coordinates(x: 0, y: 0), 42);
        grid1.set(const Coordinates(x: 1, y: 0), 43);
        grid1.set(const Coordinates(x: 0, y: 1), 44);
        grid2.set(const Coordinates(x: 0, y: 0), 42);
        grid2.set(const Coordinates(x: 1, y: 0), 43);
        grid2.set(const Coordinates(x: 0, y: 1), 44);
        expect(grid1.isRelativelyEquivalent(grid2), isTrue);
      });

      test(
          'Test isRelativelyEquivalent multiple items added in the same order to different places, but same relative locations',
          () {
        final grid1 = Grid<int>();
        final grid2 = Grid<int>();
        grid1.set(const Coordinates(x: 0, y: 0), 42);
        grid1.set(const Coordinates(x: 1, y: 0), 43);
        grid1.set(const Coordinates(x: 0, y: 1), 44);
        grid2.set(const Coordinates(x: 1, y: 1), 42);
        grid2.set(const Coordinates(x: 2, y: 1), 43);
        grid2.set(const Coordinates(x: 1, y: 2), 44);
        expect(grid1.isRelativelyEquivalent(grid2), isTrue);
      });

      test(
          'Test isRelativelyEquivalent multiple items added in the same order to different places, but different relative locations',
          () {
        final grid1 = Grid<int>();
        final grid2 = Grid<int>();
        grid1.set(const Coordinates(x: 0, y: 0), 42);
        grid1.set(const Coordinates(x: 1, y: 0), 43);
        grid1.set(const Coordinates(x: 0, y: 1), 44);
        grid2.set(const Coordinates(x: 1, y: 2), 42);
        grid2.set(const Coordinates(x: 2, y: 1), 43);
        grid2.set(const Coordinates(x: 1, y: 1), 44);
        expect(grid1.isRelativelyEquivalent(grid2), isFalse);
      });

      test(
          'Test isRelativelyEquivalent multiple items added in different order to the same places',
          () {
        final grid1 = Grid<int>();
        final grid2 = Grid<int>();
        grid1.set(const Coordinates(x: 0, y: 0), 42);
        grid1.set(const Coordinates(x: 1, y: 0), 43);
        grid1.set(const Coordinates(x: 0, y: 1), 44);
        grid2.set(const Coordinates(x: 0, y: 1), 44);
        grid2.set(const Coordinates(x: 1, y: 0), 43);
        grid2.set(const Coordinates(x: 0, y: 0), 42);
        expect(grid1.isRelativelyEquivalent(grid2), isTrue);
      });

      test(
          'Test isRelativelyEquivalent multiple items added in different order to different places, but same relative locations',
          () {
        final grid1 = Grid<int>();
        final grid2 = Grid<int>();
        grid1.set(const Coordinates(x: 0, y: 0), 42);
        grid1.set(const Coordinates(x: 1, y: 0), 43);
        grid1.set(const Coordinates(x: 0, y: 1), 44);
        grid2.set(const Coordinates(x: 1, y: 2), 44);
        grid2.set(const Coordinates(x: 2, y: 1), 43);
        grid2.set(const Coordinates(x: 1, y: 1), 42);
        expect(grid1.isRelativelyEquivalent(grid2), isTrue);
      });

      test(
          'Test isRelativelyEquivalent multiple items added in different order to different places, but different relative locations',
          () {
        final grid1 = Grid<int>();
        final grid2 = Grid<int>();
        grid1.set(const Coordinates(x: 0, y: 0), 42);
        grid1.set(const Coordinates(x: 1, y: 0), 43);
        grid1.set(const Coordinates(x: 0, y: 1), 44);
        grid2.set(const Coordinates(x: 1, y: 2), 44);
        grid2.set(const Coordinates(x: 2, y: 2), 43);
        grid2.set(const Coordinates(x: 1, y: 1), 42);
        expect(grid1.isRelativelyEquivalent(grid2), isFalse);
      });

      test('Test isRelativelyEquivalent different grids', () {
        final grid1 = Grid<int>();
        final grid2 = Grid<int>();
        grid1.set(const Coordinates(x: 0, y: 0), 42);
        grid2.set(const Coordinates(x: 0, y: 0), 43);
        grid2.set(const Coordinates(x: 1, y: 0), 43);
        expect(grid1.isRelativelyEquivalent(grid2), isFalse);
      });

      test('Test isRelativelyEquivalent different grids, different sizes', () {
        final grid1 = Grid<int>();
        final grid2 = Grid<int>();
        grid1.set(const Coordinates(x: 0, y: 0), 42);
        grid1.set(const Coordinates(x: 1, y: 0), 43);
        grid1.set(const Coordinates(x: 0, y: 1), 44);
        grid2.set(const Coordinates(x: 0, y: 0), 42);
        grid2.set(const Coordinates(x: 1, y: 0), 43);
        expect(grid1.isRelativelyEquivalent(grid2), isFalse);
      });
    });
  });

  group('Test normalize', () {
    test('Test normalize empty grid', () {
      final grid = Grid<int>();
      final normalized = grid.normalize;
      expect(normalized, Grid<int>());
      expect(identical(normalized, grid), isFalse);
    });

    test('Test normalize single item grid - already normalized', () {
      final grid = Grid<int>();
      grid.set(const Coordinates(x: 0, y: 0), 42);
      final normalized = grid.normalize;
      expect(normalized, grid);
      expect(identical(normalized, grid), isFalse);
    });

    test('Test normalize single item grid, positive x-y values', () {
      final grid = Grid<int>();
      grid.set(const Coordinates(x: 1, y: 2), 42);
      final normalizedGrid = grid.normalize;
      expect(normalizedGrid.minXindex, 0);
      expect(normalizedGrid.maxXindex, 0);
      expect(normalizedGrid.minYindex, 0);
      expect(normalizedGrid.maxYindex, 0);
      expect(normalizedGrid.get(const Coordinates(x: 0, y: 0)), 42);
      expect(normalizedGrid.toList(), [
        [42]
      ]);
      expect(identical(normalizedGrid, grid), isFalse);
    });

    test('Test normalize single item grid, negative x-y values', () {
      final grid = Grid<int>();
      grid.set(const Coordinates(x: -1, y: -2), 42);
      final normalizedGrid = grid.normalize;
      expect(normalizedGrid.minXindex, 0);
      expect(normalizedGrid.maxXindex, 0);
      expect(normalizedGrid.minYindex, 0);
      expect(normalizedGrid.maxYindex, 0);
      expect(normalizedGrid.get(const Coordinates(x: 0, y: 0)), 42);
      expect(normalizedGrid.toList(), [
        [42]
      ]);
      expect(identical(normalizedGrid, grid), isFalse);
    });

    test('Test normalize single item grid, positive x - negative y value', () {
      final grid = Grid<int>();
      grid.set(const Coordinates(x: 1, y: -2), 42);
      final normalizedGrid = grid.normalize;
      expect(normalizedGrid.minXindex, 0);
      expect(normalizedGrid.maxXindex, 0);
      expect(normalizedGrid.minYindex, 0);
      expect(normalizedGrid.maxYindex, 0);
      expect(normalizedGrid.get(const Coordinates(x: 0, y: 0)), 42);
      expect(normalizedGrid.toList(), [
        [42]
      ]);
      expect(identical(normalizedGrid, grid), isFalse);
    });

    test('Test normalize multiple items grid, already normalized', () {
      final grid = Grid<int>();
      grid.set(const Coordinates(x: 0, y: 0), 42);
      grid.set(const Coordinates(x: 1, y: 0), 43);
      grid.set(const Coordinates(x: 0, y: 1), 44);
      final normalizedGrid = grid.normalize;
      expect(normalizedGrid.minXindex, 0);
      expect(normalizedGrid.maxXindex, 1);
      expect(normalizedGrid.minYindex, 0);
      expect(normalizedGrid.maxYindex, 1);
      expect(normalizedGrid.toList(), [
        [42, 43],
        [44, null],
      ]);
    });

    test('Test normalize multiple items grid with negative coordinates', () {
      final grid = Grid<int>();
      grid.set(const Coordinates(x: 0, y: 0), 42);
      grid.set(const Coordinates(x: -1, y: 0), 43);
      grid.set(const Coordinates(x: 0, y: -1), 44);
      final normalizedGrid = grid.normalize;
      expect(normalizedGrid.minXindex, 0);
      expect(normalizedGrid.maxXindex, 1);
      expect(normalizedGrid.minYindex, 0);
      expect(normalizedGrid.maxYindex, 1);
      expect(normalizedGrid.toList(), [
        [null, 44],
        [43, 42],
      ]);
    });

    test(
        'Test normalize multiple items grid with positive and negative coordinates, not normalized',
        () {
      final grid = Grid<int>();
      grid.set(const Coordinates(x: 1, y: 2), 42);
      grid.set(const Coordinates(x: -1, y: 0), 43);
      grid.set(const Coordinates(x: 0, y: -1), 44);
      final normalizedGrid = grid.normalize;
      expect(normalizedGrid.minXindex, 0);
      expect(normalizedGrid.maxXindex, 2);
      expect(normalizedGrid.minYindex, 0);
      expect(normalizedGrid.maxYindex, 3);
      expect(normalizedGrid.toList(), [
        [null, 44, null],
        [43, null, null],
        [null, null, null],
        [null, null, 42],
      ]);
    });

    test(
        'Test normalize multiple items grid with positive and negative coordinates, already normalized',
        () {
      final grid = Grid<int>();
      grid.set(const Coordinates(x: 0, y: 0), 42);
      grid.set(const Coordinates(x: 1, y: 0), 43);
      grid.set(const Coordinates(x: 0, y: 1), 44);
      final normalizedGrid = grid.normalize;
      expect(normalizedGrid.minXindex, 0);
      expect(normalizedGrid.maxXindex, 1);
      expect(normalizedGrid.minYindex, 0);
      expect(normalizedGrid.maxYindex, 1);
      expect(normalizedGrid.toList(), [
        [42, 43],
        [44, null],
      ]);
    });
  });

  group('Test rows/columns getters', () {
    group('Test rows getter', () {
      test('Test rows empty grid', () {
        final grid = Grid<int>();
        expect(grid.rows, 0);
      });

      test('Test rows single item grid', () {
        final grid = Grid<int>();
        grid.set(const Coordinates(x: 0, y: 0), 42);
        expect(grid.rows, 1);
      });

      test('Test rows multiple items grid', () {
        final grid = Grid<int>();
        grid.set(const Coordinates(x: 0, y: 0), 42);
        grid.set(const Coordinates(x: 1, y: 0), 43);
        grid.set(const Coordinates(x: 0, y: 1), 44);
        expect(grid.rows, 2);
      });

      test('Test rows multiple items grid with negative coordinates', () {
        final grid = Grid<int>();
        grid.set(const Coordinates(x: 0, y: 0), 42);
        grid.set(const Coordinates(x: -1, y: 0), 43);
        grid.set(const Coordinates(x: 0, y: -1), 44);
        expect(grid.rows, 2);
      });
      test(
          'Test rows mulitple items grid with positive and negative coordinates',
          () {
        final grid = Grid<int>();
        grid.set(const Coordinates(x: 1, y: 2), 42);
        grid.set(const Coordinates(x: -1, y: 0), 43);
        grid.set(const Coordinates(x: 0, y: -1), 44);
        expect(grid.rows, 4);
      });
    });
    group('Test columns getter', () {
      test('Test columns empty grid', () {
        final grid = Grid<int>();
        expect(grid.columns, 0);
      });

      test('Test columns single item grid', () {
        final grid = Grid<int>();
        grid.set(const Coordinates(x: 0, y: 0), 42);
        expect(grid.columns, 1);
      });

      test('Test columns multiple items grid', () {
        final grid = Grid<int>();
        grid.set(const Coordinates(x: 0, y: 0), 42);
        grid.set(const Coordinates(x: 1, y: 0), 43);
        grid.set(const Coordinates(x: 0, y: 1), 44);
        expect(grid.columns, 2);
      });

      test('Test columns multiple items grid with negative coordinates', () {
        final grid = Grid<int>();
        grid.set(const Coordinates(x: 0, y: 0), 42);
        grid.set(const Coordinates(x: -1, y: 0), 43);
        grid.set(const Coordinates(x: 0, y: -1), 44);
        expect(grid.columns, 2);
      });
      test(
          'Test columns mulitple items grid with positive and negative coordinates',
          () {
        final grid = Grid<int>();
        grid.set(const Coordinates(x: 1, y: 2), 42);
        grid.set(const Coordinates(x: -1, y: 0), 43);
        grid.set(const Coordinates(x: 2, y: -1), 44);
        expect(grid.columns, 4);
      });
    });
  });
}
