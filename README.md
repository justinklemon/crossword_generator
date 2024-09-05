Have you ever wondered how to create a crosword from your family's names or needed to create a crossword from a list of vocabulary words for your students? This package has the perfect solution!

## Features

- This package allows you to generate a list of all possible crosswords that can be made from a given list of words.
- Each crossword is scored based on density and sorted to prefer denser crosswords.

## Getting started

Add this line to your pubspec.yaml:

```yaml
dependencies:
  crossword_generator: 
    git: https://github.com/justinklemon/crossword_generator.git
```

Then run this command:

```bash
dart pub get
```

Then add this import:

```dart
import 'package:crossword_generator:crossword_generator.dart
```

## Usage

You can generate a list of `Crossword`s by using the `generateCrosswords` function.

```dart
List<String> names = ["John", "Joe", "Jane"];
List<Crossword> crosswords = generateCrosswords(names);
```

The crosswords will be sorted such that the denser/more compact versions are preferred. You can see their exact score with the `crossword.score` getter.

Each `Crossword` has a list of `PositionedWord`s that specify where each word starts and ends within the puzzle.

```dart
List<PositionedWord> words = crossword.placedWords;
String firstWord = words[0].word;
Coordinates startCoords = words[0].start;
Coordinates endCoords = words[0].end;
```


Each `Crossword` also has a `Grid` that represents the object in 2D space. The grid can be further converted into a `List<List<String?>>` where the null values represent empty spaces and the characters are placed as strings.

```dart
List<List<String?>> gridList = crossword.grid.toList();
```

You can use either of these options to display the crossword within your application, or for simple testing you can also use the `toPrettyString()` function.

```dart
print(crossword.toPrettyString());
```
