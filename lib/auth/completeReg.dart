import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class CompleteRegScreen extends StatefulWidget {
  CompleteRegScreen({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<StatefulWidget> createState() => _CompleteRegScreen();
}

class _CompleteRegScreen extends State<CompleteRegScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  String _userUid = "";
  TextEditingController _userListener = TextEditingController();
  String _username = "";
  File? _image;

  _CompleteRegScreen() {
    _userListener.addListener(_userListen);
    _userUid = auth.currentUser!.uid;
  }

  void _userListen() {
    if (_userListener.text.isEmpty)
      _username = "";
    else
      _username = _userListener.text;
  }

  void _userInfo() async {
    if (_username != "") {
      auth.currentUser!.updateDisplayName(_username);
      var storageRef = storage.ref().child(_userUid);
      /*
    try {
      await storageRef.putFile(file);
    } on firebase_core.FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
    }
    MI DA' ERRORE L'EXCEPTION ANCHE SE L'HO PRESA DAL SITO...
     */
      if (_image != null) await storageRef.putFile(_image!);

      var recordRef = firestore.collection("userRecords");
      await recordRef.doc(auth.currentUser!.uid).set({
        'impRecord': 0
      });

      Navigator.pushNamed(context, '/');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Inserisci un nome utente"),
      ));
    }
  }

  void pickImage() async {
    var picker = ImagePicker();
    var pickedImage = await picker.getImage(source: ImageSource.gallery);
    _image = File(pickedImage!.path);
    setState(() {});
  }

  Widget buildImage() {
    if (_image == null)
      return Image.asset('imgs/default_profile.jpg', width: 150, height: 150);
    else {
      return Image.file(_image!, width: 150, height: 150);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(widget.title)),
        body: Center(
            child: Column(
          children: <Widget>[
            Text('Scegli il tuo username e la tua foto profilo',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40)),
            Container(
                width: 300,
                margin: EdgeInsets.only(top: 80),
                child: TextField(
                  controller: _userListener,
                  decoration: InputDecoration(labelText: 'Nome utente'),
                )),
            Container(
                margin: EdgeInsets.only(top: 30),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      buildImage(),
                      ElevatedButton(
                          onPressed: () {
                            pickImage();
                          },
                          child: Text("Scegli l'immagine"),
                          style: ElevatedButton.styleFrom(
                              primary: Color(0xFFF9AA33)))
                    ])),
            Container(
                margin: EdgeInsets.only(top: 50),
                child: ElevatedButton(
                    child: Text("Conferma"),
                    onPressed: () {
                      _userInfo();
                    },
                    style:
                        ElevatedButton.styleFrom(primary: Color(0xFFF9AA33))))
          ],
        )));
  }
}
