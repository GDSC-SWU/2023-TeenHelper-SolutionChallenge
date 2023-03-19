import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google/Login/choice.dart';
import 'package:google/Login/login_screen.dart';

class main_screen extends StatefulWidget {
  @override
  _main_screen createState() => _main_screen();
}

class _main_screen extends State<main_screen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (BuildContext context, AsyncSnapshot<User?> user) {
            if (user.hasData) {
              return choice();
            } else {
              return login_screen();
            }
          },
        )
    );
  }

}