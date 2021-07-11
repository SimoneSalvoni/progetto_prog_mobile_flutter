import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<StatefulWidget> createState() => _ProfileScreenState();
}

///A dipendenza del valore di una variabile di questo tipo viene mostrata o la
///schermata del profilo o quella di modifica del profilo
enum Status { show, modify }

class _ProfileScreenState extends State<ProfileScreen> {
  Status _status = Status.show;
  String _email = "";
  String _oldEmail = "";
  String _username = "";
  String _password = "";
  String _newPassword = "";
  String _confNewPass = "";
  String? _imageUrl;
  int _record = 0;
  TextEditingController _emailListener = TextEditingController();
  TextEditingController _usernameListener = TextEditingController();
  TextEditingController _newPasswordListener = TextEditingController();
  TextEditingController _confPassListener = TextEditingController();
  TextEditingController _passwordListener = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool _modifyPassword = false; // se l'utente vuole modificare la password
  File? _newImageFile; //Una nuova immagine scelta dall'utente viene salvata qua
  bool _needUserInfo =
      true; //Questa variabile è usata per sapere se bisogna ri-ottenere i dati dell'utente

  _ProfileScreenState() {
    _emailListener.addListener(_emailListen);
    _usernameListener.addListener(_usernameListen);
    _passwordListener.addListener(_passwordListen);
    _newPasswordListener.addListener(_newPasswordListen);
    _confPassListener.addListener(_confPassListen);
  }

  ///Questa funzione ottiene i dati dell'utente da Firebase (nome utente, record e foto profilo)
  ///e richiede il ricaricamento della schermata
  void getUserInfo() async {
    var recordRef = firestore.collection('userRecords');
    await recordRef
        .doc(auth.currentUser!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      _record = documentSnapshot['impRecord'];
    });
    var storageRef = storage.ref().child(auth.currentUser!.uid);
    _imageUrl = await storageRef.getDownloadURL();
    if (_imageUrl == null) _imageUrl = "";
    _username = auth.currentUser!.displayName!;
    _email = auth.currentUser!.email!;
    _oldEmail = _email;
    setState(() {});
  }

  void _emailListen() {
    if (_emailListener.text.isEmpty)
      _email = auth.currentUser!.email!;
    else
      _email = _emailListener.text;
  }

  void _usernameListen() {
    if (_usernameListener.text.isEmpty)
      _username = auth.currentUser!.displayName!;
    else
      _username = _usernameListener.text;
  }

  void _passwordListen() {
    if (_passwordListener.text.isEmpty)
      _password = "";
    else
      _password = _passwordListener.text;
  }

  void _newPasswordListen() {
    if (_newPasswordListener.text.isEmpty)
      _newPassword = "";
    else
      _newPassword = _newPasswordListener.text;
  }

  void _confPassListen() {
    if (_confPassListener.text.isEmpty)
      _confNewPass = "";
    else
      _confNewPass = _confPassListener.text;
  }

  ///Questa funzione restituisce l'immagine di profilo dell'utente (una di default viene
  ///scelta se manca). Se inoltre la schermata è quella di modifica viene anche inserito
  ///un pulsante per cambiare immagine di profilo e se una nuova immagine viene scelta, viene mostrata quella
  Widget _buildImage() {
    if (_imageUrl == "" || _imageUrl == null) if (_status == Status.modify) {
      return Container(
          margin: EdgeInsets.only(top: 20),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            Image.asset('lib/imgs/default_profile.jpg',
                width: 200, height: 200),
            ConstrainedBox(
                constraints: BoxConstraints.tightFor(width: 60, height: 60),
                child: ElevatedButton(
                    onPressed: changeImage,
                    child: Icon(Icons.photo_outlined),
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                    ))),
          ]));
    } else {
      return Container(
        margin: EdgeInsets.only(top: 20),
        child: Image.asset('lib/imgs/default_profile.jpg',
            width: 200, height: 200),
      );
    }
    else if (_newImageFile != null && _status == Status.modify) {
      return Container(
          margin: EdgeInsets.only(top: 20),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            Image.file(_newImageFile!, width: 180, height: 180),
            ConstrainedBox(
                constraints: BoxConstraints.tightFor(width: 60, height: 60),
                child: ElevatedButton(
                    onPressed: changeImage,
                    child: Icon(Icons.photo_outlined),
                    style: ElevatedButton.styleFrom(
                        shape: CircleBorder(), primary: Color(0xFFF9AA33)))),
          ]));
    } else {
      if (_status == Status.modify) {
        return Container(
            margin: EdgeInsets.only(top: 20),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Image.network(_imageUrl!, width: 180, height: 180),
                  ConstrainedBox(
                      constraints:
                          BoxConstraints.tightFor(width: 60, height: 60),
                      child: ElevatedButton(
                          onPressed: changeImage,
                          child: Icon(Icons.photo_outlined),
                          style: ElevatedButton.styleFrom(
                              shape: CircleBorder(),
                              primary: Color(0xFFF9AA33)))),
                ]));
      } else {
        return Container(
          margin: EdgeInsets.only(top: 20),
          child: Image.network(_imageUrl!, width: 180, height: 180),
        );
      }
    }
  }

  ///Modifica la tipologia di schermata
  void _statusChange() {
    setState(() {
      if (_status == Status.show)
        _status = Status.modify;
      else {
        _status = Status.show;
        _modifyPassword = false;
      }
    });
  }

  ///Questa funzione restituisce i campi con le informazioni dell'utente. Se la schermata è
  ///quella di modifica sono campi modificabili. Se l'utente preme il pulsante di modifica password
  ///inoltre vengono mostrati anche due campi aggiuntivi in cui inserire la nuova password e confermarla
  ///Vengono inoltre creati anche i pulsanti necessari alla situazione
  Widget _buildFields() {
    if (_status == Status.show) {
      return Container(
          child: Column(
        children: <Widget>[
          Container(
              margin: EdgeInsets.only(top: 30),
              child: Column(
                children: [
                  Text("Email: ", style: TextStyle(fontSize: 20)),
                  Text(_email, style: TextStyle(fontSize: 20))
                ],
              )),
          Container(
              margin: EdgeInsets.only(top: 30),
              child: Column(
                children: [
                  Text("Nome utente: ", style: TextStyle(fontSize: 20)),
                  Text(_username, style: TextStyle(fontSize: 20))
                ],
              )),
          Container(
              margin: EdgeInsets.only(top: 30),
              child: Text("Record impiccato : " + _record.toString(),
                  style: TextStyle(fontSize: 20))),
        ],
      ));
    } else if (!_modifyPassword) {
      _emailListener.text = _email;
      _usernameListener.text = _username;
      return Container(
          child: Column(
        children: <Widget>[
          Container(
              width: 300,
              // margin: EdgeInsets.only(top:80),
              child: TextField(
                  controller: _emailListener,
                  decoration: InputDecoration(labelText: "E-mail"),
                  keyboardType: TextInputType.emailAddress)),
          Container(
              width: 300,
              child: TextField(
                controller: _usernameListener,
                decoration: InputDecoration(labelText: "Nome utente"),
              )),
          Container(
              margin: EdgeInsets.only(top: 30),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    ElevatedButton(
                        onPressed: () {
                          _email = auth.currentUser!.email!;
                          _username = auth.currentUser!.displayName!;
                          _newImageFile = null;
                          _statusChange();
                        },
                        child: Text("Annulla Modifiche"),
                        style: ElevatedButton.styleFrom(
                            primary: Color(0xFFF9AA33))),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Color(0xFFF9AA33)),
                        onPressed: () {
                          setState(() {
                            _modifyPassword = true;
                          });
                        },
                        child: Text("Modifica password")),
                  ]))
        ],
      ));
    } else {
      _emailListener.text = _email;
      _usernameListener.text = _username;
      return Container(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
              width: 300,
              // margin: EdgeInsets.only(top:80),
              child: TextField(
                  controller: _emailListener,
                  decoration: InputDecoration(labelText: "E-mail"),
                  keyboardType: TextInputType.emailAddress)),
          Container(
              width: 300,
              child: TextField(
                controller: _usernameListener,
                decoration: InputDecoration(labelText: "Nome utente"),
              )),
          Container(
              width: 300,
              child: TextField(
                  decoration: InputDecoration(labelText: "Inserisci password"),
                  obscureText: true,
                  controller: _newPasswordListener)),
          Container(
              width: 300,
              child: TextField(
                  decoration: InputDecoration(labelText: "Conferma password"),
                  obscureText: true,
                  controller: _confPassListener)),
          Container(
              margin: EdgeInsets.only(top: 30),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Color(0xFFF9AA33)),
                        onPressed: () {
                          _email = auth.currentUser!.email!;
                          _username = auth.currentUser!.displayName!;
                          _newImageFile = null;
                          _statusChange();
                        },
                        child: Text("Annulla Modifiche")),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Color(0xFFF9AA33)),
                        onPressed: () {
                          setState(() {
                            _modifyPassword = false;
                          });
                        },
                        child: Text("Annulla modifica password")),
                  ])),
        ],
      ));
    }
  }

  ///Questa funzione restituisce il floatin action button, con un'immagine differente (e una funzione
  ///diversa) a dipendenza della schermata
  Widget buildFab() {
    if (_status == Status.show)
      return FloatingActionButton.extended(
          onPressed: _statusChange,
          label: Text("Modifica profilo"),
          icon: Icon(Icons.mode_edit),
          backgroundColor: Color(0xFFF9AA33));
    else
      return FloatingActionButton.extended(
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) => _buildDialogue());
          },
          label: Text("Conferma modifica profilo"),
          backgroundColor: Color(0xFFF9AA33),
          icon: Icon(Icons.save));
  }

  ///Questa funzione modifica il profilo dell'utente e riporta poi alla schermata del profilo
  void _modifyProfile() async {
    try {
      if (_modifyPassword) {
        if (_newPassword == "") {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Inserisci la nuova password")));
          return;
        } else if (_confNewPass == "") {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Conferma la password")));
          return;
        } else if (_newPassword != _confNewPass) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Inserisci la nuova password")));
          return;
        } else
          await auth.currentUser!.updatePassword(_newPassword);
      }
      await auth.currentUser!.updateDisplayName(_username);
      await auth.currentUser!.updateEmail(_email);
      var storageRef = storage.ref().child(auth.currentUser!.uid);
      if (_newImageFile != null) {
        await storageRef.putFile(_newImageFile!);
        _newImageFile = null;
      }
      await auth.currentUser!.reload();
      _needUserInfo = true;
      _statusChange();
    } on Exception catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("C'è stato un errore")));
      return;
    }
  }

  ///Questa funzione permette all'utente di scegliere una nuova immagine di profilo nella galleria
  void changeImage() async {
    var picker = ImagePicker();
    var pickedImage = await picker.getImage(source: ImageSource.gallery);
    _newImageFile = File(pickedImage!.path);
    setState(() {});
  }

  ///Questa funzione costruisce il popup in cui l'utente dovrà inserire la sua password per confermare
  ///la modifica dei suoi dati personali. La password è necessaria per la riautenticazione
  Widget _buildDialogue() {
    return AlertDialog(
        title: Text("Inserisci la tua password"),
        content: TextField(
            decoration: InputDecoration(hintText: "Password"),
            controller: _passwordListener,
            obscureText: true),
        actions: <Widget>[
          TextButton(
            child: Text("Chiudi"),
            onPressed: () {
              Navigator.pop(context, 'Cancel');
            },
          ),
          TextButton(
              child: Text("Conferma"),
              onPressed: () {
                _reauthenticate();
                Navigator.pop(context);
              })
        ]);
  }

  ///Questa funzione riautentica l'utente con la password che ha inserito nel popup,
  ///e se questa va a buon fine fa partire la modifica del profilo
  void _reauthenticate() async {
    AuthCredential credential =
        EmailAuthProvider.credential(email: _oldEmail, password: _password);
    await FirebaseAuth.instance.currentUser!
        .reauthenticateWithCredential(credential)
        .then((value) {
      _passwordListener.text = "";
      _modifyProfile();
    }).catchError((onError) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("C'è stato un errore nell'autenticazione")));
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_needUserInfo) getUserInfo();
    _needUserInfo = false;
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.title),
          leading: BackButton(
            onPressed: () {
              if (_status == Status.show)
                Navigator.pushNamed(context, '/');
              else
                _statusChange();
            },
          )),
      body: Center(
          child: Column(
        children: <Widget>[
          _buildImage(),
          _buildFields(),
        ],
      )),
      floatingActionButton: buildFab(),
    );
  }
}
