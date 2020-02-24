import 'package:chat_app/chat_screen.dart';
import 'package:chat_app/login_screen.dart';
import 'package:chat_app/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  static const String id = "SIGNUP";

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String email;
  String password;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> signUpUser() async {
    final FirebaseUser user = (await _auth.createUserWithEmailAndPassword(
            email: email, password: password))
        .user;

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
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
            text: "Sign Up",
            callback: () async{
              await signUpUser();
            },
          ),

        ],
      ),
    );
  }
}
