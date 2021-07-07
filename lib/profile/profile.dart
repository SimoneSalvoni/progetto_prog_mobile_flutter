import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ProfileScreen extends StatefulWidget{
  ProfileScreen({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<StatefulWidget> createState() => _ProfileScreenState();
}

enum Status{
  show,
  modify
}

class _ProfileScreenState extends State<ProfileScreen>{
  Status _status = Status.show;
  String _email="";
  String _username="";
  String? _imageUrl;
  int? _record;
  TextEditingController _emailListener = TextEditingController();
  TextEditingController _usernameListener = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  bool _modifyPassword = false;


  _ProfileScreenState(){
    _emailListener.addListener(_emailListen);
    _usernameListener.addListener(_usernameListen);
    _username = auth.currentUser!.displayName!;
    _email = auth.currentUser!.email!;
    getImage();
    getRecord();
  }

  void getImage() async{
    var storageRef = storage.ref().child(auth.currentUser!.uid);
    _imageUrl = await storageRef.getDownloadURL();
  }

  void getRecord() async{
    //TODO
  }

  void _emailListen(){
    if (_emailListener.text.isEmpty)
      _email= "";
    else
      _email = _emailListener.text;
  }

  void _usernameListen(){
    if (_usernameListener.text.isEmpty)
      _username = "";
    else
      _username = _usernameListener.text;
  }

  Widget buildImage() {
    if (_imageUrl == null)
      return Image.asset('imgs/default_profile.jpg', width: 150, height: 150);
    else {
      return Image.network(_imageUrl!, width: 100, height: 100);
    }
  }

  void statusChange(){
    setState(() {
      if (_status==Status.show) _status = Status.modify;
      else{
        _status = Status.show;
        _modifyPassword=false;
      }
    });
  }

  Widget buildFields() {
    if (_status == Status.show) {
      return Container(
          child: Column(
        children: <Widget>[
          Container(
              width: 300,
              // margin: EdgeInsets.only(top:80),
              child: Text(_email)),
          Container(
              width: 300,
              child: Text(_username)),
          Container(
            child: Text("Record nell'impiccato: "+ _record.toString())
          )
        ],
      ));
    } else if (!_modifyPassword) {
      return Container(
          child: Column(
        children: <Widget>[
          Container(
              width: 300,
              // margin: EdgeInsets.only(top:80),
              child: TextField(
                controller: _emailListener,
                decoration: InputDecoration(labelText: _email),
              )),
          Container(
              width: 300,
              child: TextField(
                controller: _usernameListener,
                decoration: InputDecoration(labelText: _username),
              )),
        ],
      ));
    } else {
      return Container(
          child: Column(
        children: <Widget>[
          Container(
              width: 300,
              // margin: EdgeInsets.only(top:80),
              child: TextField(
                controller: _emailListener,
                decoration: InputDecoration(labelText: _email),
              )),
          Container(
              width: 300,
              child: TextField(
                controller: _usernameListener,
                decoration: InputDecoration(labelText: _username),
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
          ElevatedButton(
              onPressed: () {
                setState(() {
                  _modifyPassword=false;
                });
              },
              child: Text("Annulla modifica password")),
        ],
      ));
    }
  }

  Widget buildFab() {
    if (_status == Status.show)
      return FloatingActionButton.extended(
        onPressed: statusChange,
        label: Text("Modifica profilo"),
        icon: Icon(Icons.mode_edit),
      );
    else return FloatingActionButton.extended(
        onPressed: statusChange,
        label: Text("Conferma modifica profilo"),
        icon: Icon(Icons.save));
  }

  @override
  Widget build(BuildContext context) {
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
            buildImage(),
            buildFields(),
            Container(
              child: Text(_record.toString())
            )
          ],
        )
      ),
      floatingActionButton: buildFab(),
    );
  }

}