import 'package:crossword_generator/crossword_generator.dart';
import 'package:intl/intl.dart';

void main(List<String> arguments) {
  List<String> listOfWords = [
    'game',
    'greeds',
    'shop',
    'paws',
    'simplify',
    'ballet',
    'puffed',
    // Noticeably slower after these words are added
    'pealed',
    'kills',
    'fig'
  ];

  for (int i = 1; i < listOfWords.length + 1; i++) {
    List<String> words = listOfWords.sublist(0, i);
    print("Generating crosswords for $words");
    final stopwatch = Stopwatch()..start();
    List<Crossword> crosswords = generateCrosswords(words);
    stopwatch.stop();
    NumberFormat numberFormat = NumberFormat('#,##0');
    String formattedCrosswordsLength = numberFormat.format(crosswords.length);
    Duration elapsed = stopwatch.elapsed;
    String formattedElapsedTime =
        "${(elapsed.inMinutes % 60).toString().padLeft(2, '0')}:"
        "${(elapsed.inSeconds % 60).toString().padLeft(2, '0')}:"
        "${(elapsed.inMilliseconds % 1000).toString().padLeft(3, '0')}";

    print("Found $formattedCrosswordsLength crosswords in $formattedElapsedTime");
    // for (Crossword crossword in generateCrosswords(listOfWords)) {
    //   print(crossword.toPrettyString());
    //   print("---Placed words---}");
    //   for (PositionedWord word in crossword.placedWords) {
    //     print(word);
    //   }
    //   print("Score: ${crossword.score}");
    // }    
  }
}
