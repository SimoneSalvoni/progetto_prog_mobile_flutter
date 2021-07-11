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

enum LetterStatus { unknown, right, wrong }

class _ImpGame extends State<ImpGame> {
  int impState = 0;
  Qwerty keyboard = Qwerty();
  String shownWord = "";
  String? chosenWord;
  List<LetterStatus> letterStatus = List.generate(26, (index) {
    return LetterStatus.unknown;
  });

  Widget createKey(index) {
    if (letterStatus[index] == LetterStatus.unknown)
      return Container(
        width: 30,
        child: TextButton(
            style:
                TextButton.styleFrom(textStyle: const TextStyle(fontSize: 20)),
            onPressed: () {
              checkLetter(keyboard.qwerty[index], index);
            },
            child: Text(keyboard.qwerty[index].toUpperCase())),
      );
    else if (letterStatus[index] == LetterStatus.right)
      return Container(
        width: 30,
        child: TextButton(
            style:
                TextButton.styleFrom(textStyle: const TextStyle(fontSize: 20)),
            onPressed: () {},
            child: Text(keyboard.qwerty[index].toUpperCase(),
                style: TextStyle(color: Colors.green))),
      );
    else
      return Container(
        width: 30,
        child: TextButton(
            style:
                TextButton.styleFrom(textStyle: const TextStyle(fontSize: 20)),
            onPressed: () {},
            child: Text(keyboard.qwerty[index].toUpperCase(),
                style: TextStyle(color: Colors.red))),
      );
  }

  void chooseWord() async {
    chosenWord = await widget.impObj.getWord();
    if (chosenWord!.length != 0) {
      setState(() {
        shownWord = widget.impObj.getHiddenWord(chosenWord!.length);
      });
    }
  }

  bool checkLetter(c, index) {
    List<int> ind = [];
    for (int i = 0; i < chosenWord!.length; i++) {
      if (c == chosenWord![i]) ind.add(i);
    }
    if (ind.isEmpty) {
      letterStatus[index] = LetterStatus.wrong;
      letterIsNotPresent();
      return false;
    } else {
      letterStatus[index] = LetterStatus.right;
      letterIsPresent(c, ind);
      return true;
    }
  }

  void letterIsNotPresent() {
    impState += 1;
    if (impState == 6) {
      Navigator.pushNamed(context, '/game/lose',
          arguments: LoseArguments(chosenWord!));
    }
    setState(() {});
  }

  void letterIsPresent(c, ind) {
    setState(() {
      for (int i = 0; i < ind.length; i++) {
        shownWord = shownWord.replaceRange(ind[i], ind[i] + 1, c);
      }
      if (shownWord == chosenWord) {
        num points = pointsCalc(chosenWord!.length, impState);
        Navigator.pushNamed(context, '/game/win',
            arguments: WinArguments(points, chosenWord!));
      }
    });
  }

  num pointsCalc(length, errors) {
    return 50 * length - 25 * errors;
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
                Navigator.pushNamed(context, '/menu');
              },
            )),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                child: Image.asset(
                  'lib/imgs/$impState.png',
                  gaplessPlayback: true,
                ),
              ),
              Container(
                  child: Text(shownWord,
                      style: TextStyle(fontSize: 30, letterSpacing: 2))),
              Container(
                margin: EdgeInsets.only(left: 10, top: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            child: createKey(0),
                          ),
                          Container(
                            child: createKey(1),
                          ),
                          Container(
                            child: createKey(2),
                          ),
                          Container(
                            child: createKey(3),
                          ),
                          Container(
                            child: createKey(4),
                          ),
                          Container(
                            child: createKey(5),
                          ),
                          Container(
                            child: createKey(6),
                          ),
                          Container(
                            child: createKey(7),
                          ),
                          Container(
                            child: createKey(8),
                          ),
                          Container(
                            child: createKey(9),
                          ),
                        ]),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            width: 15,
                          ),
                          Container(
                            child: createKey(10),
                          ),
                          Container(
                            child: createKey(11),
                          ),
                          Container(
                            child: createKey(12),
                          ),
                          Container(
                            child: createKey(13),
                          ),
                          Container(
                            child: createKey(14),
                          ),
                          Container(
                            child: createKey(15),
                          ),
                          Container(
                            child: createKey(16),
                          ),
                          Container(
                            child: createKey(17),
                          ),
                          Container(
                            child: createKey(18),
                          ),
                          Container(
                            width: 15,
                          )
                        ]),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            width: 45,
                          ),
                          Container(
                            child: createKey(19),
                          ),
                          Container(
                            child: createKey(20),
                          ),
                          Container(
                            child: createKey(21),
                          ),
                          Container(
                            child: createKey(22),
                          ),
                          Container(
                            child: createKey(23),
                          ),
                          Container(
                            child: createKey(24),
                          ),
                          Container(
                            child: createKey(25),
                          ),
                          Container(
                            width: 45,
                          )
                        ]),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
