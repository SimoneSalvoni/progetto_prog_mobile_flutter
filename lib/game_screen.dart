import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'game_win.dart';
import 'game_lose.dart';
import 'qwerty.dart';
import 'imp_fun.dart';

class ImpGame extends StatefulWidget {
  ImpGame({Key? key, required this.title, required this.impObj})
      : super(key: key);
  final String title;
  final ImpFun impObj;

  get impObject => null;

  @override
  _ImpGame createState() => _ImpGame();
}


class _ImpGame extends State<ImpGame> {
  int impState = 0;
  Qwerty keyboard = Qwerty();

  List<bool> buttonStatus = [];

  String? shownWord;
  String? chosenWord;

  void newGame() {
    setState(() {
      impState = 0;
      chooseWord();
    });
  }

  Widget createKey(index) {
    return Container(
      child: Center(
        child: TextButton(
            style:
                TextButton.styleFrom(textStyle: const TextStyle(fontSize: 20)),
            onPressed: () {
              if (buttonStatus[index]) checkLetter(keyboard.qwerty[index]);
            },
            child: Text(keyboard.qwerty[index].toUpperCase())),
      ),
    );
  }

  void chooseWord() async {
    buttonStatus = List.generate(26, (index) {
      return true;
    });
    chosenWord = await widget.impObj.getWord();
    if (chosenWord!.length != 0) {
      shownWord = widget.impObj.getHiddenWord(chosenWord!.length);
    }
  }

  bool checkLetter(c) {
    List<int> ind = [];
    for (int i = 0; i < chosenWord!.length; i++) {
      if (c == chosenWord![i]) ind.add(i);
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
    if (impState == 6) {
      Navigator.pushNamed(context, '/game/lose', arguments: LoseArguments(chosenWord!));
    }
  }

  void letterIsPresent(c, ind) {
    for (int i = 0; i < ind.size; i++) {
      shownWord = shownWord!.replaceFirst(RegExp('_'), c, i);
    }
    if (shownWord == chosenWord) {
      num points = pointsCalc(chosenWord!.length, impState);
      Navigator.pushNamed(context, '/game/win', arguments: WinArguments(points, chosenWord!));
    }
  }

  num pointsCalc(length,errors){
    return 50*length -25*errors;
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
            title: Text(widget.title),
            leading: BackButton(
              onPressed: () {
                Navigator.pushNamed(context, '/');
              },
            )),
        body: Center(
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 6,
                child: Container(
                  alignment: Alignment.bottomCenter,
                  child: FittedBox(
                    child: Image.asset(
                      'lib/imgs/$impState.png',
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
                        child: createKey(0),
                      ),
                      TableCell(
                        child: createKey(1),
                      ),
                      TableCell(
                        child: createKey(2),
                      ),
                      TableCell(
                        child: createKey(3),
                      ),
                      TableCell(
                        child: createKey(4),
                      ),
                      TableCell(
                        child: createKey(5),
                      ),
                      TableCell(
                        child: createKey(6),
                      )
                    ]),
                    TableRow(children: [
                      TableCell(
                        child: createKey(7),
                      ),
                      TableCell(
                        child: createKey(8),
                      ),
                      TableCell(
                        child: createKey(9),
                      ),
                    ]),
                    TableRow(children: [
                      TableCell(
                        child: createKey(10),
                      ),
                      TableCell(
                        child: createKey(11),
                      ),
                      TableCell(
                        child: createKey(12),
                      ),
                      TableCell(
                        child: createKey(13),
                      ),
                      TableCell(
                        child: createKey(14),
                      ),
                      TableCell(
                        child: createKey(15),
                      ),
                      TableCell(
                        child: createKey(16),
                      ),
                      TableCell(
                        child: createKey(17),
                      ),
                      TableCell(
                        child: createKey(18),
                      ),
                    ]),
                    TableRow(children: [
                      TableCell(
                        child: createKey(19),
                      ),
                      TableCell(
                        child: createKey(20),
                      ),
                      TableCell(
                        child: createKey(21),
                      ),
                      TableCell(
                        child: createKey(22),
                      ),
                      TableCell(
                        child: createKey(23),
                      ),
                      TableCell(
                        child: createKey(24),
                      ),
                      TableCell(
                        child: createKey(25),
                      ),
                    ]),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
