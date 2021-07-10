import 'dart:math';
import 'package:flutter/services.dart' show rootBundle;

class ImpFun {
  List<String> _words = [];

  Future<List<String>> readFromFile() async {
    String fileText = await rootBundle.loadString('lib/textFiles/words_3000.txt');
    return fileText.split("\r\n");
  }

  Future<String> getWord() async {
    var rand = Random();
    _words = await readFromFile();
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