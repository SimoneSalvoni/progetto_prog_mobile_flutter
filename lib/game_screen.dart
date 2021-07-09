import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'qwerty.dart';
import 'imp_fun.dart';

class ImpGame extends StatefulWidget {
  ImpGame({Key? key, required this.title, this.impObj}) : super(key: key);
  final String title;
  final ImpFun impObj;

  @override
  _ImpGame createState() => _ImpGame();
}

enum gameState {
  PLAYING,
  LOSE,
  WIN
}

class _ImpGame extends State<ImpGame> {
  int impState = 0;
  Qwerty keyboard = Qwerty();

  List<bool> buttonStatus

  [

  ];

  String shownWord;
  String chosenWord;

  void newGame() {
    setState(() {
      widget.impObject.reset();
      errors = 0;
      chooseWord();
    });
  }

  Widget createKey(index) {
    return Container(
      child: Center(
        child: TextButton(
            style: TextButton.styleFrom(
                textStyle: const TextStyle(fontSize: 20)
            ),
            onPressed: () {
              if (buttonStatus[index]) checkLetter(keyboard.qwerty[index]);
            },
            child: Text(keyboard.qwerty[index].toUpperCase())
        ),
      ),
    );
  }

  void chooseWord() {
    buttonStatus = List.generate(26, (index) {
      return true;
    });
    wordList = [];
    chosenWord = widget.Imp.getWord();
    if (chosenWord.length != 0) {
      shownWord = widget.impObj.getHiddenWord(chosenWord.length);
    }
  }

  bool checkLetter(c) {
    List<int> ind;
    for (int i = 0; i < chosenWord.length; i++) {
      if (c == chosenWord(i)) ind.add(i);
    }
    if (ind.isEmpty) {
      letterIsNotPresent();
      return false;
    } else {
      letterIsPresent(c, ind);
      return true;
    }
  }

  void letterIsNotPresent() {
    impState += 1;
    if (impState == 6) gameState.LOSE;
  }

  void letterIsPresent(c, ind) {
    for (int i = 0, i<ind.size, i++) {
      shownWord = shownWord.replaceFirst(RegExp('_'), c, i);
    }
    if (shownWord == chosenWord) gameState.WIN;
  }


  @override
  void initState() {
    super.initState();
    chooseWord();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
            title: Text(widget.title),
            leading: BackButton(
              onPressed: () {
                Navigator.pushNamed(context, '/');
              },
            )
        ),
        body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
            child: Column(
              children: <Widget>[
              Expanded(
              flex: 6,
              child: Container(
                alignment: Alignment.bottomCenter,
                child: FittedBox(
                  child: Image.asset(
                    'res/drawable/$impState.png',
                    height: 1001,
                    width: 991,
                    gaplessPlayback: true,
                  ),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 10, top: 5),
              child: Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                //columnWidths: {1: FlexColumnWidth(10)},
                children: [
                  TableRow(children: [
                    TableCell(
                      child: createButton(0),
                    ),
                    TableCell(
                      child: createButton(1),
                    ),
                    TableCell(
                      child: createButton(2),
                    ),
                    TableCell(
                      child: createButton(3),
                    ),
                    TableCell(
                      child: createButton(4),
                    ),
                    TableCell(
                      child: createButton(5),
                    ),
                    TableCell(
                      child: createButton(6),
                    ),
                    TableRow(children: [
                      TableCell(
                        child: createButton(7),
                      ),
                      TableCell(
                        child: createButton(8),
                      ),
                      TableCell(
                        child: createButton(9),
                      ),
                    ]),
                    TableRow(children: [
                      TableCell(
                        TableCell(
                          child: createButton(10),
                        ),
                        TableCell(
                          child: createButton(11),
                        ),
                        TableCell(
                          child: createButton(12),
                        ),
                        TableCell(
                          child: createButton(13),
                        ),
                        child: createButton(14),
                      ),
                      TableCell(
                        child: createButton(15),
                      ),
                      TableCell(
                        child: createButton(16),
                      ),
                      TableCell(
                        child: createButton(17),
                      ),
                      TableCell(
                        child: createButton(18),
                      ),
                    ]),
                    TableRow(children: [
                      TableCell(
                        child: createButton(19),
                      ),
                      TableCell(
                        child: createButton(20),
                      ),


                      TableCell(
                        child: createButton(21),
                      ),
                      TableCell(
                        child: createButton(22),
                      ),
                      TableCell(
                        child: createButton(23),
                      ),
                      TableCell(
                        child: createButton(24),
                      ),
                      TableCell(
                        child: createButton(25),

                      ),
                    ]),
                  ],
                  ),
                ],
              ), // This trailing comma makes auto-formatting nicer for build methods.
            )));
  }
}
