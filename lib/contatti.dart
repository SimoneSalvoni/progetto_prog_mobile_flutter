import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Contatti extends StatefulWidget {
  Contatti({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _Contatti createState() => _Contatti();
}

class _Contatti extends State<Contatti> {

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Contatti"),
          leading: BackButton(
            onPressed: () {
              Navigator.pushNamed(context, '/');
            },
          )),
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
                margin: EdgeInsets.only(top: 50),
                child: Text("CONTATTI",
                    style:
                    TextStyle(fontSize: 50, fontWeight: FontWeight.bold))),
            Container(
              margin: EdgeInsets.only(left: 10, top: 20),
              child: Text(
                  "Contattaci pure per qualunque cose. Saremo lieti di risolvere qualunque tuo problema o di rispondere a qualsiasi tuo dubbio!",
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.fade,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20)
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                    child: Icon(Icons.alternate_email),
                    onPressed: () {
                      //TODO mailto
                    },
                    style: ElevatedButton.styleFrom(
                        primary: Color(0xFFF9AA33),
                        textStyle: TextStyle(fontSize: 22))),
                SizedBox(width: 50),
                Text(
                    "email@email.com",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20)
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                    child: Icon(Icons.web),
                    onPressed: () {
                      //TODO web
                    },
                    style: ElevatedButton.styleFrom(
                        primary: Color(0xFFF9AA33),
                        textStyle: TextStyle(fontSize: 22))),
                SizedBox(width: 50),
                Text(
                    "univpm.it",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20)
                ),
              ],
            ),


          ],
        ),
      ),

    );
  }
}
