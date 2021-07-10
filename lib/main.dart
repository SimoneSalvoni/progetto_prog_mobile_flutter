import 'package:flutter/material.dart';
import 'package:italian_english_games_flutter/auth/login.dart';
import 'package:italian_english_games_flutter/auth/completeReg.dart';
import 'package:italian_english_games_flutter/game_lose.dart';
import 'package:italian_english_games_flutter/game_menu.dart';
import 'package:italian_english_games_flutter/game_win.dart';
import 'package:italian_english_games_flutter/game_screen.dart';
import 'package:italian_english_games_flutter/imp_fun.dart';
import 'package:italian_english_games_flutter/profile/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'contacts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
        '/menu': (context) => GameMenu(title: "Titolo del gioco"),
        '/game': (context) => ImpGame (title: "Impiccato", impObj: ImpFun()),
        '/game/win': (context) => GameWinScreen(title: "Vittoria"),
        '/game/lose': (context) => GameLoseScreen(title: "Sconfitta"),
        '/login': (context) => LoginScreen(title: "Login"),
        '/completeReg': (context) =>
            CompleteRegScreen(title: "Completa la registrazione"),
        '/profile': (context) => ProfileScreen(title: "Profilo"),
        '/contacts': (context) => ContactsScreen(title: "Contatti")
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
  final FirebaseAuth auth = FirebaseAuth.instance;
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  String _username = "";
  String? _imageUrl;

  /// Questa funzione recupera i dati dell'utente (nome, immagine di profilo) da
  /// Firebase e richiede il build della schermata per inserire queste info
  void pickUserInfo() async {
    _username = auth.currentUser!.displayName!;
    var storageRef = storage.ref().child(auth.currentUser!.uid);
    _imageUrl = await storageRef.getDownloadURL();
    setState(() {});
  }

  /// Questa funzione restituisce il Drawer Header del NavDrawer. Se non si ha
  /// l'immagine di profilo se ne mette una placeholder
  Widget buildDrawerHeader() {
    if (_imageUrl != null) {
      return DrawerHeader(
          decoration: BoxDecoration(
            color: Color(0xFFF9AA33),
          ),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Image.network(_imageUrl!, width: 100, height: 100),
                Container(
                    margin: EdgeInsets.only(top: 5), child: Text(_username))
              ]));
    } else {
      return DrawerHeader(
          decoration: BoxDecoration(
            color: Color(0xFFF9AA33),
          ),
          child: Column(children: <Widget>[
            Image.asset('lib/imgs/default_profile.jpg', width: 50, height: 50),
            Container(margin: EdgeInsets.only(top: 5), child: Text(_username))
          ]));
    }
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAuth.instance.userChanges().listen((User? user) {
      if (user == null) {
        Navigator.pushNamed(context, '/login');
      } else {
        pickUserInfo();
      }
    });
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: Drawer(
          child: ListView(padding: EdgeInsets.zero, children: <Widget>[
        buildDrawerHeader(),
        ListTile(
          title: Text('Contatti'),
          onTap: () {
            Navigator.pushNamed(context, "/contacts");
          },
        ),
        ListTile(
          title: Text('Profilo'),
          onTap: () {
            Navigator.pushNamed(context, "/profile");
          },
        ),
        ListTile(
            title: Text('Logout'),
            onTap: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushNamed(context, "/login");
            })
      ])),
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.symmetric(vertical: 100.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'lib/imgs/italia.png',
                    width: 150,
                    height: 150,
                  ),
                  Image.asset(
                    'lib/imgs/bandiera-inglese-png-6.png',
                    width: 150,
                    height: 150,
                  )
                ],
              ),
            ),
            Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: 10),
                  child: ElevatedButton(
                      child: Text("Impiccato"),
                      onPressed: () {
                        Navigator.pushNamed(context, '/menu');
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
