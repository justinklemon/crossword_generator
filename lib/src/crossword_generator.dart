import 'package:crossword_generator/src/set_queue.dart';

import 'coordinates.dart';
import 'crossword.dart';
import 'positioned_word.dart';

List<Crossword> generateCrosswords(List<String> words) {
  if (words.isEmpty) {
    return [];
  }

  // Sort the words by length
  words.sort((a, b) => a.length.compareTo(b.length));

  final SetQueue<Crossword> crosswordCandidates = SetQueue<Crossword>();
  final Set<Crossword> completeCrosswords = {};

  // Attempt to start the crossword with each word in both horizontal and vertical orientations
  for (String word in words) {
    crosswordCandidates.addLast(Crossword.startWithHorizontalWord(word));
    crosswordCandidates.addLast(Crossword.startWithVerticalWord(word));
  }

  while (crosswordCandidates.isNotEmpty) {
    final Crossword crossword = crosswordCandidates.removeFirst()!;

    final List<String> remainingWords = List.from(words)
      ..removeWhere((word) =>
          crossword.placedWords.any((placedWord) => placedWord.word == word));
    if (remainingWords.isEmpty) {
      completeCrosswords.add(crossword);
      continue;
    }
    // Try to place each remaining word in the crossword. If successful, add the new crossword to the list of candidates
    for (String word in remainingWords) {
      final List<String> wordsNotPlaced = List.from(remainingWords)
        ..remove(word);
      final List<PositionedWord> possiblePlacements = crossword.placedWords
          .expand((placedWord) => placedWord.intersectingWordOptions(word))
          .toList();
      for (PositionedWord placement in possiblePlacements) {
        final Crossword? newCrossword =
            placeWord(crossword, placement, words, wordsNotPlaced);
        // If no conflicts were found, add the new crossword to the list of candidates
        if (newCrossword != null) {
          crosswordCandidates.addLast(newCrossword);
        }
      }
    }
  }
  // Sort by score, descending
  return completeCrosswords.toList()
    ..sort((a, b) => b.score.compareTo(a.score));
}

/// Attempts to place a word in the crossword. If successful, returns the new crossword. If not, returns null
///
/// After placing the word, it will check for any and all words passing through the new word. If any of these words are not in the list of all words, then this is not a valid crossword placement.
/// If any of the words passing through are not in the list of words placed but are in the list of words not placed, then this is an accidental valid placement.
/// If any accidental valid placements are found, then it will recursively attempt to place these words in the crossword.
Crossword? placeWord(Crossword existingCrossword, PositionedWord placement,
    List<String> allWords, List<String> wordsNotPlaced) {
  final List<PositionedWord> accidentalValidWordPlacements = [];
  Crossword newCrossword = existingCrossword.addWord(placement);
  for (Coordinates coordinate in placement.getCoordinates()) {
    List<PositionedWord> wordsPassingThrough =
        newCrossword.getWordsPassingThroughCoordinates(coordinate);

    for (PositionedWord wordPassingThrough in wordsPassingThrough) {
      // If any of the 'words' passing through this point are not in the words list, then this is not a valid crossword placement
      if (!allWords.contains(wordPassingThrough.word)) {
        return null;
      }
      // If the word passing through is not in the wordsNotPlaced list, then it is an accidental valid placement
      if (wordsNotPlaced.contains(wordPassingThrough.word)) {
        accidentalValidWordPlacements.add(wordPassingThrough);
      }
    }
  }
  if (accidentalValidWordPlacements.isNotEmpty) {
    for (PositionedWord accidentalPlacement in accidentalValidWordPlacements) {
      final List<String> remainingWords = List.from(wordsNotPlaced)
        ..remove(accidentalPlacement.word);
      Crossword? validCrossword = placeWord(
          newCrossword, accidentalPlacement, allWords, remainingWords);
      // If any of the accidental placements are not valid, then this is not a valid crossword placement
      if (validCrossword == null) {
        return null;
      }
    }
  }
  // If all accidental placements are valid, then update the new crossword
  newCrossword = newCrossword.copyWith(accidentalValidWordPlacements);

  // Make sure that all the placed words are still present in the grid
  for (PositionedWord placedWord in newCrossword.placedWords) {
    for (Coordinates coord in placedWord.getCoordinates()) {
      if (newCrossword.grid.get(coord) != placedWord.characterAt(coord)) {
        return null;
      }
    }
  }
  return newCrossword;
}
