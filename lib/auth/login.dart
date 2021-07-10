import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

///Variabile di questo tipo viene usata per mostrare una form di login o di registrazione
enum LoginOrRegister { login, register }

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController _emailListener = TextEditingController();
  TextEditingController _passwordListener = TextEditingController();
  String _email = "";
  String _password = "";
  LoginOrRegister _form = LoginOrRegister.login;

  _LoginScreenState() {
    _emailListener.addListener(_emailListen);
    _passwordListener.addListener(_passwordListen);
  }

  void _emailListen() {
    if (_emailListener.text.isEmpty)
      _email = "";
    else
      _email = _emailListener.text;
  }

  void _passwordListen() {
    if (_passwordListener.text.isEmpty)
      _password = "";
    else
      _password = _passwordListener.text;
  }

  ///Modifica la tipologia di form
  void formChange() async {
    setState(() {
      if (_form == LoginOrRegister.register)
        _form = LoginOrRegister.login;
      else
        _form = LoginOrRegister.register;
    });
  }

  ///Questa funzione costruisce i pulsanti da mostrare nella form, che cambiano
  ///a dipendenza della tipolgia di form
  Widget _buildButtons() {
    if (_form == LoginOrRegister.login) {
      return Container(
          margin: EdgeInsets.only(top: 80),
          child: Column(children: <Widget>[
            Container(
                margin: EdgeInsets.only(bottom: 20),
                child: ElevatedButton(
                    child: Text("Login"),
                    onPressed: () {
                      _login();
                    },
                    style:
                        ElevatedButton.styleFrom(primary: Color(0xFFF9AA33)))),
            GestureDetector(
              child: Text("Non hai un account? Registrati",
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.indigo)),
              onTap: () {
                formChange();
              },
            )
          ]));
    } else {
      return Container(
          margin: EdgeInsets.only(top: 80),
          child: Column(children: <Widget>[
            Container(
                margin: EdgeInsets.only(bottom: 20),
                child: ElevatedButton(
                    child: Text("Registrati"),
                    onPressed: () {
                      _register();
                    },
                    style:
                        ElevatedButton.styleFrom(primary: Color(0xFFF9AA33)))),
            GestureDetector(
              child: Text("Hai già un account? Esegui il login!",
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.indigo)),
              onTap: () {
                formChange();
              },
            )
          ]));
    }
  }

  ///Il titolo della schermata va adattato alla form mostrata
  Widget _buildTitle() {
    if (_form == LoginOrRegister.login) {
      return Text('Login',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 60));
    } else
      return Text('Registrazione',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 60));
  }

  ///Questa funzione esegue il login all'account dell'utente tramite Firebase Auth
  ///Si usano email e password
  void _login() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: _email, password: _password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Utente non trovato"),
        ));
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Password errata"),
        ));
      }
    }
  }

  ///Questa funzione registra un nuovo utente sfruttando Firebase auth.
  ///Ci si registra con email e password
  void _register() async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: _email, password: _password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Password troppo debole"),
        ));
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Email già in uso"),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    auth.userChanges().listen((User? user) {
      if (user == null) {
      } else {
        if (_form == LoginOrRegister.login)
          Navigator.pushNamed(context, '/');
        else {
          Navigator.pushNamed(context, '/completeReg');
        }
      }
    });

    return Scaffold(
        appBar: AppBar(
            title: Text(widget.title),
            leading: BackButton(
              onPressed: () {
                if (_form == LoginOrRegister.login)
                  Navigator.pushNamed(context, '/');
                else
                  formChange();
              },
            )),
        body: Center(
            child: Column(
          children: <Widget>[
            Container(margin: EdgeInsets.only(top: 20), child: _buildTitle()),
            Container(
                width: 300,
                margin: EdgeInsets.only(top: 80),
                child: TextField(
                  controller: _emailListener,
                  decoration: InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                )),
            Container(
                width: 300,
                child: TextField(
                    controller: _passwordListener,
                    decoration: InputDecoration(labelText: "Password"),
                    obscureText: true)),
            _buildButtons()
          ],
        )));
  }
}
