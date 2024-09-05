import 'package:crossword_generator/crossword_generator.dart';

void main(List<String> arguments) {
  List<String> listOfWords = [
    'game',
    'greeds',
    'shop',
    'paws',
    'simplify',
    'ballet', //268 crosswords
    // Gets slow after this
    // 'puffed', //3728 crosswords
    //Stops working after this (runs out of memory)
    // 'pealed',
    // 'kills',
    // 'fig'
  ];
  List<Crossword> crosswords = generateCrosswords(listOfWords);

  for (Crossword crossword in crosswords) {
    print(crossword.toPrettyString());
    print("Score: ${crossword.score}");
  }
  print("Found ${crosswords.length} crosswords");
}
