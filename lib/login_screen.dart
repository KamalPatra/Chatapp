import 'package:chat_app/chat_screen.dart';
import 'package:chat_app/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  static const String id = "LOGIN";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email;
  String password;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> loginUser() async {
    final FirebaseUser user = (await _auth.signInWithEmailAndPassword(
        email: email, password: password))
        .user;

    Navigator.push(context, MaterialPageRoute(builder: (context) => ChatWindow(user: user,)));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Chat"),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Hero(
              tag: "logo",
              child: Container(
                child: Image.asset("assets/images/face.png"),
              ),
            ),
          ),
          SizedBox(height: 40.0,),
          TextField(
            keyboardType: TextInputType.emailAddress,
            onChanged: (value) => email = value,
            decoration: InputDecoration(
                hintText: "Enter your Email",
                border: const OutlineInputBorder()
            ),
          ),
          SizedBox(height: 40.0,),
          TextField(
            autocorrect: false,
            onChanged: (value) => password = value,
            obscureText: true,
            decoration: InputDecoration(
              hintText: "Enter your Password",
              border: const OutlineInputBorder(),

            ),
          ),
          CustomButton(
            text: "Login In",
            callback: () async{
              await loginUser();
            },
          ),

        ],
      ),
    );
  }
}
