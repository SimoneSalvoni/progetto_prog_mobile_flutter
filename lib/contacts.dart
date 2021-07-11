import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactsScreen extends StatefulWidget {
  ContactsScreen({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<StatefulWidget> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  void _launchMail() async {
    final url = Uri.encodeFull('mailto:email@email.com');
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Applicazione per gestire le e-mail non trovata")));
    }
  }

  void _launchURL() async {
    const url = 'https://univpm.it';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Browser non trovato, impossibile aprire il link")));
    }
  }

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
              margin: EdgeInsets.only(left: 10, top: 50, bottom: 80),
              child: Text(
                  "Contattaci pure per qualunque cose. Saremo lieti di risolvere qualunque tuo problema o di rispondere a qualsiasi tuo dubbio!",
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.fade,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ListTile(
                    title: Text('email@email.com',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 22)),
                    leading: ElevatedButton(
                        child: Icon(Icons.alternate_email),
                        onPressed: () {
                          _launchMail();
                        },
                        style: ElevatedButton.styleFrom(
                            primary: Color(0xFFF9AA33),
                            textStyle: TextStyle(fontSize: 22)))),
                ListTile(
                    title: Text('univpm.it',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 22)),
                    leading: ElevatedButton(
                        child: Icon(Icons.web),
                        onPressed: () {
                          _launchURL();
                        },
                        style: ElevatedButton.styleFrom(
                            primary: Color(0xFFF9AA33),
                            textStyle: TextStyle(fontSize: 22)))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
