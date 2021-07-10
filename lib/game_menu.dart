import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GameMenu extends StatefulWidget {
  GameMenu({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _GameMenu createState() => _GameMenu();
}

class _GameMenu extends State<GameMenu> {

  ///Questa funzione crea il pop di info da mostrare se premuto il pulsante apposito
  Widget buildDialogue() {
    return AlertDialog(
        title: Text("Info"),
        content: Text(
            "Questo è un gioco in cui bisogna scoprire una parola inglese scelta casualmente "
            "tra quelle più utilizzate nella lingua. All'inizio saprai quante lettere compongono"
            "quella parola. A quel punto potrai iniziare a provare ad inserire le lettere che pensi "
            "possano formarla. Attenzione però, hai un numero di tentativi limitati!"),
        actions: <Widget>[
          TextButton(
            child: Text("Chiudi"),
            onPressed: () {
              Navigator.pop(context, 'Cancel');
            },
          )
        ]);
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
            Container(
              margin: EdgeInsets.only(left: 10, top: 5),
              child: Align(
                alignment: Alignment.centerLeft,
                child: ElevatedButton(
                    child: Text("Info"),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) => buildDialogue());
                    },
                    style: ElevatedButton.styleFrom(
                        primary: Color(0xFFF9AA33),
                        textStyle: TextStyle(fontSize: 22))),
              ),
            ),
            Container(
                margin: EdgeInsets.only(top: 70),
                child: Text("IMPICCATO",
                    style:
                        TextStyle(fontSize: 50, fontWeight: FontWeight.bold))),
            Container(
              margin: EdgeInsets.only(top: 80),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Image.asset(
                      'lib/imgs/gioco-impiccato.jpg',
                      height: 150,
                      width: 150,
                    ),
                  ),
                  Expanded(
                      child: Center(
                          child: Container(
                              margin: EdgeInsets.only(left: 10),
                              child: Text(
                                "Indovina la parola inglese che verrà "
                                "selezionata casualmente ad ogni partita!"
                                " Quanto è ampio il tuo vocabolario?",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ))))
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 100),
              child: ElevatedButton(
                  child: Text("Gioca!"),
                  onPressed: () {
                    Navigator.pushNamed(context, '/game');
                  },
                  style: ElevatedButton.styleFrom(
                      primary: Color(0xFFF9AA33),
                      textStyle: TextStyle(fontSize: 22))),
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
