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
                margin: EdgeInsets.only(top:50),
              child: Text(
                "NOME DEL GIOCO",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold
                  )
              )
            )
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
