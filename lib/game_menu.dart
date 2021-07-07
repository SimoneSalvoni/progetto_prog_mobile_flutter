import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GameMenu extends StatefulWidget {
  GameMenu({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _GameMenu createState() => _GameMenu();
}

class _GameMenu extends State<GameMenu> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        leading: BackButton(
          onPressed:(){
            Navigator.pushNamed(context, '/');
          },
        )
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 10, top: 5),
              child: Align(
                alignment: Alignment.centerLeft,
                child: ElevatedButton(
                    child: Text("Info"),
                    onPressed: () {
                      //TODO info popup
                    },
                    style: ElevatedButton.styleFrom(
                        primary: Color(0xFFF9AA33),
                        textStyle: TextStyle(fontSize: 22))),
              ),
            ),
            Container(
                margin: EdgeInsets.only(top: 70),
                child: Text("NOME DEL GIOCO",
                    style:
                        TextStyle(fontSize: 30, fontWeight: FontWeight.bold))),
            Container(
              margin: EdgeInsets.only(top: 50),
              child: Align(
                alignment: Alignment.center,
                child: Image.asset(
                  'imgs/gioco-impiccato.jpg',
                  height: 150,
                  width: 150,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 10, top: 20),
              child: Text(
                  "Indovina la parola inglese che verrà selezionata casualmente ad ogni partita! Quanto è ampio il tuo vocabolario?",
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.fade,
              style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20)
               ),
            ),

            Container(
              margin: EdgeInsets.only(top:50),
              child: ElevatedButton(
                  child: Text("Gioca!"),
                  onPressed: () {
                    //TODO navigation
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
