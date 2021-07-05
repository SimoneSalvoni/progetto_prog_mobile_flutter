import 'package:flutter/material.dart';
import 'package:italian_english_games_flutter/game_menu.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Italian-English Games',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: MyHomePage(title: 'Italian-English Games'),
      initialRoute: "/",
      routes: {
        '/menu': (context) => GameMenu(title: "Titolo del gioco")
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      drawer: Drawer(
          child: ListView(padding: EdgeInsets.zero, children: <Widget>[
        DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFFF9AA33),
            ),
            child: Text('Prova Drawer Header')),
        ListTile(
          title: Text('FAQ'),
          onTap: () {},
        ),
        ListTile(
          title: Text('Logout'),
          onTap: (){}
        )
      ])),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.symmetric(vertical: 100.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'imgs/italia.png',
                    width: 150,
                    height: 150,
                  ),
                  Image.asset(
                    'imgs/bandiera-inglese-png-6.png',
                    width: 150,
                    height: 150,
                  )
                ],
              ),
            ),
            Row(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: 10),
                  child: ElevatedButton(
                      child: Text("Testo di prova"),
                      onPressed: () {
                        Navigator.pushNamed(context, '/menu',);
                      },
                      style: ElevatedButton.styleFrom(
                          primary: Color(0xFFF9AA33),
                          textStyle: TextStyle(fontSize: 22))),
                ),
                Container(
                    margin: const EdgeInsets.only(left: 20),
                    child: Text(
                      'TROVA LE PAROLE!',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    )),
              ],
            )
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
