import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google/Login/main_screen.dart';

class home_screen extends StatelessWidget {
  const home_screen();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: ScreenUtil().setWidth(656),
        height: ScreenUtil().setWidth(200),
        child: ElevatedButton(
          onPressed: (){
            final FirebaseAuth _auth = FirebaseAuth.instance;
            final GoogleSignIn googleSignIn = GoogleSignIn();
            _auth.signOut();
            googleSignIn.signOut();
            Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => main_screen()));
          },
          child: Text("로그아웃"),
          ),
      ),
    );
  }
}