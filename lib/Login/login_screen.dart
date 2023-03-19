import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class login_screen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  late User currentUser;

  User? result;
  Future<String>? idTokenResult;

  Future<void> UserWrite() async {
    await FirebaseFirestore.instance.collection("user").doc(FirebaseAuth.instance.currentUser!.uid).set({
      "uid": FirebaseAuth.instance.currentUser!.uid,
      "email": FirebaseAuth.instance.currentUser!.email,
    });
  }

  Future<UserCredential> google_SignIn() async {
    final GoogleSignInAccount? account = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await account!.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final UserCredential authResult = await _auth.signInWithCredential(credential);
    final User? user = authResult.user;

    assert(!user!.isAnonymous);
    assert(await user!.getIdToken() != null);

    currentUser = await _auth.currentUser!;
    assert(user!.uid == currentUser.uid);

    // UserWrite();
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
                margin: EdgeInsets.fromLTRB(16.w,0,16.w,48.h),
                child: InkWell(
                  child: Image.asset('images/login_button.png'),
                  onTap: () => {
                    google_SignIn(),

                  },
                )
                /*SizedBox(
                  width: double.infinity,
                  height: 96.h,
                  child: IconButton(
                    onPressed: () {
                      google_SignIn();
                      },
                    icon: Image.asset('images/login_button.png'),
                    constraints: const BoxConstraints(),
                  ),
                )*/
            ),
          ],
        ),
      ),
    );
  }

}