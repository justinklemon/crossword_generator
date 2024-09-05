import 'package:crossword_generator/src/coordinates.dart';
import 'package:test/test.dart';

void main() {
  group('Test constructor', () {
    test('Test constructor at origin', () {
      const Coordinates coordinates = Coordinates(x: 0, y: 0);

      expect(coordinates.x, 0);
      expect(coordinates.y, 0);
    });

    test('Test constructor at (1, 2)', () {
      const Coordinates coordinates = Coordinates(x: 1, y: 2);

      expect(coordinates.x, 1);
      expect(coordinates.y, 2);
    });

    test('Test constructor with negative values', () {
      const Coordinates coordinates = Coordinates(x: -1, y: -2);

      expect(coordinates.x, -1);
      expect(coordinates.y, -2);
    });

    test('Test constructor with negative X and positive Y', () {
      const Coordinates coordinates = Coordinates(x: -1, y: 2);

      expect(coordinates.x, -1);
      expect(coordinates.y, 2);
    });

    test('Test constructor with positive X and negative Y', () {
      const Coordinates coordinates = Coordinates(x: 1, y: -2);

      expect(coordinates.x, 1);
      expect(coordinates.y, -2);
    });
  });

  group('Test shift functions', () {
    test('Test shiftX', () {
      const Coordinates coordinates = Coordinates(x: 1, y: 2);
      Coordinates shiftedCoordinates = coordinates.shiftX();

      expect(shiftedCoordinates.x, 2);
      expect(shiftedCoordinates.y, 2);
    });

    test('Test shiftX with amount', () {
      const Coordinates coordinates = Coordinates(x: 1, y: 2);
      Coordinates shiftedCoordinates = coordinates.shiftX(amount: 3);

      expect(shiftedCoordinates.x, 4);
      expect(shiftedCoordinates.y, 2);
    });

    test('Test shiftX with negative amount', () {
      const Coordinates coordinates = Coordinates(x: 1, y: 2);
      Coordinates shiftedCoordinates = coordinates.shiftX(amount: -3);

      expect(shiftedCoordinates.x, -2);
      expect(shiftedCoordinates.y, 2);
    });

    test('Test shiftX from negative X', () {
      const Coordinates coordinates = Coordinates(x: -1, y: 2);
      Coordinates shiftedCoordinates = coordinates.shiftX();

      expect(shiftedCoordinates.x, 0);
      expect(shiftedCoordinates.y, 2);
    });

    test('Test shiftY', () {
      const Coordinates coordinates = Coordinates(x: 1, y: 2);
      Coordinates shiftedCoordinates = coordinates.shiftY();

      expect(shiftedCoordinates.x, 1);
      expect(shiftedCoordinates.y, 3);
    });

    test('Test shiftY with amount', () {
      const Coordinates coordinates = Coordinates(x: 1, y: 2);
      Coordinates shiftedCoordinates = coordinates.shiftY(amount: 3);

      expect(shiftedCoordinates.x, 1);
      expect(shiftedCoordinates.y, 5);
    });

    test('Test shiftY with negative amount', () {
      const Coordinates coordinates = Coordinates(x: 1, y: 2);
      Coordinates shiftedCoordinates = coordinates.shiftY(amount: -3);

      expect(shiftedCoordinates.x, 1);
      expect(shiftedCoordinates.y, -1);
    });

    test('Test shiftY from negative Y', () {
      const Coordinates coordinates = Coordinates(x: 1, y: -2);
      Coordinates shiftedCoordinates = coordinates.shiftY();

      expect(shiftedCoordinates.x, 1);
      expect(shiftedCoordinates.y, -1);
    });
  });

  group('Test equality operators', () {
    test('Test equality with same coordinates', () {
      const Coordinates coordinates1 = Coordinates(x: 1, y: 2);
      const Coordinates coordinates2 = Coordinates(x: 1, y: 2);

      expect(coordinates1, coordinates2);
    });

    test('Test equality with different coordinates', () {
      const Coordinates coordinates1 = Coordinates(x: 1, y: 2);
      const Coordinates coordinates2 = Coordinates(x: 2, y: 1);

      expect(coordinates1 != coordinates2, true);
    });

    test('Test equality with different X', () {
      const Coordinates coordinates1 = Coordinates(x: 1, y: 2);
      const Coordinates coordinates2 = Coordinates(x: 2, y: 2);

      expect(coordinates1 != coordinates2, true);
    });

    test('Test equality with different Y', () {
      const Coordinates coordinates1 = Coordinates(x: 1, y: 2);
      const Coordinates coordinates2 = Coordinates(x: 1, y: 3);

      expect(coordinates1 != coordinates2, true);
    });

    test('Test compatibility with toSet', () {
      List<Coordinates> coordinatesList = [
        const Coordinates(x: 1, y: 2),
        const Coordinates(x: 1, y: 2),
        const Coordinates(x: 2, y: 1),
        const Coordinates(x: 2, y: 1),
      ];

      Set<Coordinates> coordinatesSet = coordinatesList.toSet();

      expect(coordinatesSet.length, 2);
    });

  });
}
