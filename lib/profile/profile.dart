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

enum Status { show, modify }

class _ProfileScreenState extends State<ProfileScreen> {
  Status _status = Status.show;
  String _email = "";
  String _username = "";
  String _newPassword="";
  String _confNewPass="";
  String? _imageUrl;
  int _record = 0;
  TextEditingController _emailListener = TextEditingController();
  TextEditingController _usernameListener = TextEditingController();
  TextEditingController _passwordListener = TextEditingController();
  TextEditingController _confPassListener = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool _modifyPassword = false;
  File? _newImageFile;

  _ProfileScreenState() {
    _emailListener.addListener(_emailListen);
    _usernameListener.addListener(_usernameListen);
    _passwordListener.addListener(_passwordListen);
    _confPassListener.addListener(_confPassListen);
  }

  void getUserInfo() async {
    var storageRef = storage.ref().child(auth.currentUser!.uid);
    _imageUrl = await storageRef.getDownloadURL();
    if (_imageUrl == null) _imageUrl = "";
    var recordRef = firestore.collection('userRecords');
    await recordRef
        .doc(auth.currentUser!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      _record = documentSnapshot['impRecord'];
    });
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

  void _passwordListen(){
    if(_passwordListener.text.isEmpty) _newPassword ="";
    else _newPassword = _passwordListener.text;
  }

  void _confPassListen(){
    if(_confPassListener.text.isEmpty) _confNewPass="";
    else _confNewPass = _confPassListener.text;
  }

  Widget _buildImage() {
    if (_imageUrl == "" || _imageUrl == null) if (_status == Status.modify) {
      return Container(
          margin: EdgeInsets.only(top: 20),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            Image.asset('imgs/default_profile.jpg', width: 200, height: 200),
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
        child: Image.asset('imgs/default_profile.jpg', width: 200, height: 200),
      );
    }
    else if(_newImageFile!=null){
      return Container(
          margin: EdgeInsets.only(top: 20),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Image.file(_newImageFile!, width: 180, height: 180),
                ConstrainedBox(
                    constraints:
                    BoxConstraints.tightFor(width: 60, height: 60),
                    child: ElevatedButton(
                        onPressed: changeImage,
                        child: Icon(Icons.photo_outlined),
                        style: ElevatedButton.styleFrom(
                          shape: CircleBorder(),
                        ))),
              ]));
    }
    else {
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
                          ))),
                ]));
      } else {
        return Container(
          margin: EdgeInsets.only(top: 20),
          child: Image.network(_imageUrl!, width: 180, height: 180),
        );
      }
    }
  }

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
              )),
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
                          _statusChange();
                        },
                        child: Text("Annulla Modifiche")),
                    ElevatedButton(
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
          Container( //TODO NON MI FA SCRIVERE
              width: 300,
              // margin: EdgeInsets.only(top:80),
              child: TextField(
                controller: _emailListener,
                decoration: InputDecoration(labelText: "E-mail"),
              )),
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
              )),
          Container(
              width: 300,
              child: TextField(
                decoration: InputDecoration(labelText: "Conferma password"),
                obscureText: true,
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
                          _statusChange();
                        },
                        child: Text("Annulla Modifiche")),
                    ElevatedButton(
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

  Widget buildFab() {
    _username = auth.currentUser!.displayName!;
    _email = auth.currentUser!.email!;
    if (_status == Status.show)
      return FloatingActionButton.extended(
        onPressed: _statusChange,
        label: Text("Modifica profilo"),
        icon: Icon(Icons.mode_edit),
      );
    else
      return FloatingActionButton.extended(
          onPressed:(){
            _modifyProfile();
            _statusChange();
          },
          label: Text("Conferma modifica profilo"),
          icon: Icon(Icons.save));
  }

  void _modifyProfile() async{
    if(_modifyPassword){
      if(_newPassword==""){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Inserisci la nuova password")));
        return;
      }
      else if (_confNewPass=="") {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Conferma la password")));
        return;
      }
      else if (_newPassword!=_confNewPass){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Inserisci la nuova password")));
        return;
      }
      else await auth.currentUser!.updatePassword(_newPassword);
    }
    await auth.currentUser!.updateDisplayName(_username);
    await auth.currentUser!.updateEmail(_email);
    var storageRef = storage.ref().child(auth.currentUser!.uid);
    if(_newImageFile!=null){
      await storageRef.putFile(_newImageFile!);
      _newImageFile=null;
    }
  }

  void changeImage() async{
    var picker = ImagePicker();
    var pickedImage = await picker.getImage(source: ImageSource.gallery);
    _newImageFile = File(pickedImage!.path);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_imageUrl == null || _newImageFile!=null) getUserInfo();
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
          _buildImage(),
          _buildFields(),
        ],
      )),
      floatingActionButton: buildFab(),
    );
  }
}
