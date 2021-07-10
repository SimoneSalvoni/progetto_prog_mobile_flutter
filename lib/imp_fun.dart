import 'dart:math';
import 'package:flutter/services.dart' show rootBundle;

class ImpFun {
  List<String> _words = [];

  Future readFromFile() async {
    String fileText = await rootBundle.loadString('lib/textFiles/words_3000.txt');
    _words = fileText.split('\n');
  }

  Future<String> getWord() async {
    readFromFile();
    var rand = Random();
    int words = _words.length;
    int randNumber = rand.nextInt(words);
    return _words[randNumber];
  }

  String getHiddenWord(int wordLength) {
    String hiddenWord = '';
    for (int i = 0; i < wordLength; i++) {
      hiddenWord += '_';
    }
    return hiddenWord;
  }
}