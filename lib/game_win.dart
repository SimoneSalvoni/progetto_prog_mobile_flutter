import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GameWinScreen extends StatefulWidget {
  GameWinScreen ({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  _GameWinScreen createState() => _GameWinScreen();
}

class WinArguments{
  final num points;
  final String solution;
  WinArguments(this.points, this.solution);
}

class _GameWinScreen extends State<GameWinScreen> {

  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  int? _record;
  int? newRecord;


  void getUserInfo() async {
    var recordRef = firestore.collection('userRecords');
    await recordRef
        .doc(auth.currentUser!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      _record = documentSnapshot['impRecord'];
    });
    setState(() {});
  }

  bool checkRecord(points){
    return (points>_record);
  }

  Widget _buildPointsFields(points){
    if(checkRecord(points))
      return Container(
          margin: EdgeInsets.only(top: 70, bottom: 120),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text("Punteggio: "+points.toString(),
              textAlign: TextAlign.left,
              style:
              TextStyle(fontSize: 22 )),
          Text("NUOVO RECORD!",
          style: TextStyle(
            fontSize:25
          ))
        ],
      ));
    else return Container(
        margin: EdgeInsets.only(top: 70, bottom: 120),
        child: Text("Punteggio: "+points.toString(),
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 22 )));
  }


  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as WinArguments ;
    if(_record==null) getUserInfo();
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.title),
          leading: BackButton(
            onPressed:(){
              Navigator.pushNamed(context, '/menu');
            },
          )
      ),
      body: Center(
          child: Column(
              children: <Widget>[
                Container(
                    margin: EdgeInsets.only(top: 100),
                    child: Text("HAI VINTO!",
                        style:
                        TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.green))),

                Container(
                    margin: EdgeInsets.only(top: 70),
                    child: Text("La parola era: "+args.solution,
                        textAlign: TextAlign.left,
                        style:
                        TextStyle(fontSize: 22))),
                _buildPointsFields(args.points),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                        child: Text("TORNA AL MENÙ"),
                        onPressed: () {
                          Navigator.pushNamed(context, '/menu');
                        },
                        style: ElevatedButton.styleFrom(
                            primary: Color(0xFFF9AA33),
                            textStyle: TextStyle(fontSize: 22))),
                    SizedBox(width: 50),
                    ElevatedButton(
                        child: Text("RIGIOCA"),
                        onPressed: () {
                          Navigator.pushNamed(context, '/game');
                        },
                        style: ElevatedButton.styleFrom(
                            primary: Color(0xFFF9AA33),
                            textStyle: TextStyle(fontSize: 22))),
                  ],
                ),
              ]
          )
      ),
    );
  }
}
