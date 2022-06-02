import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:khsplan/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);


  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("KHS-Plan"),
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(24),
            child: const Text("Bitte gebe das Passwort für den Vertretungplan ein", style: TextStyle(fontSize: 20), textAlign: TextAlign.center,),
          ),
          Container(
            padding: const EdgeInsets.all(24),
            child: TextField(
              controller: _controller,
              obscureText: true,
              textAlign: TextAlign.center,
              onEditingComplete: () {_checklogin();},
            ),
          ),
          GFButton(
            onPressed: () {_checklogin();},
            text: "Check",
            shape: GFButtonShape.pills,)
        ],
      ),
    );
  }

  Future<void> _checklogin() async {

    var hashpw = "6cb64feedbc50e6f431569c3d38e02c3c80302560cd31b701c507d01135b74577fc92cb5ffbee24ba84460144c33856271a584454ea93a59e098bce82d77a026";
    var hashdinput = sha512.convert(utf8.encode(_controller.text));
    if(hashdinput.toString()==hashpw.toString()) {
      setloginbool();
      Navigator.push(context,
          MaterialPageRoute(
            builder: (context) => const MyHomePage(),
          )
      );
    }
  }
  setloginbool() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("isLoggedIn", true);
  }

}

