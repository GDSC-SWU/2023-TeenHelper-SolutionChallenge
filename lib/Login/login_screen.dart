import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

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
    final PageController controller = PageController(initialPage: 0,);
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Center(
                    child: SizedBox(
                      width: ScreenUtil().setWidth(272),
                      height: ScreenUtil().setHeight(660),
                      child: PageView(
                      controller: controller,
                      children: [
                        Column(
                          children: [
                            SizedBox(width: ScreenUtil().setWidth(272), height: ScreenUtil().setHeight(154)),
                            Image.asset('images/login_image_complete1.png', width: ScreenUtil().setWidth(272), height: ScreenUtil().setHeight(272)),
                            SizedBox(width: ScreenUtil().setWidth(272), height: ScreenUtil().setHeight(64)),
                            Image.asset('images/login_text_complete1.png'),
                      ]
                        ),
                        Column(
                            children: [
                              SizedBox(width: ScreenUtil().setWidth(272), height: ScreenUtil().setHeight(154)),
                              Image.asset('images/login_image_complete2.png', width: ScreenUtil().setWidth(272), height: ScreenUtil().setHeight(272)),
                              SizedBox(width: ScreenUtil().setWidth(272), height: ScreenUtil().setHeight(64)),
                              Image.asset('images/login_text_complete2.png'),
                            ]
                        ),
                        Column(
                            children: [
                              SizedBox(width: ScreenUtil().setWidth(272), height: ScreenUtil().setHeight(154)),
                              Image.asset('images/login_image_complete3.png', width: ScreenUtil().setWidth(272), height: ScreenUtil().setHeight(272)),
                              SizedBox(width: ScreenUtil().setWidth(272), height: ScreenUtil().setHeight(64)),
                              Image.asset('images/login_text_complete3.png'),
                            ]
                        ),
                        Column(
                            children: [
                              SizedBox(width: ScreenUtil().setWidth(272), height: ScreenUtil().setHeight(154)),
                              Image.asset('images/login_image_complete4.png', width: ScreenUtil().setWidth(272), height: ScreenUtil().setHeight(272)),
                              SizedBox(width: ScreenUtil().setWidth(272), height: ScreenUtil().setHeight(64)),
                              Image.asset('images/login_text_complete4.png'),
                            ]
                        ),
                      ],
                  ),
                    )
              ),
              SmoothPageIndicator(
                controller: controller,
                count:  4,
                axisDirection: Axis.horizontal,
                effect:  SlideEffect(
                    spacing:  8.0,
                    radius:  4.0,
                    dotWidth:  8.0,
                    dotHeight:  8.0,
                    paintStyle:  PaintingStyle.fill,
                    strokeWidth:  1.5,
                    dotColor:  Color(0xFFE9E9E9),
                    activeDotColor: Color(0xFFE76D3B)
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                    margin: EdgeInsets.fromLTRB(ScreenUtil().setWidth(16),ScreenUtil().setHeight(14),ScreenUtil().setWidth(16),ScreenUtil().setHeight(0)),
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
              ),
            ],
          ),
        ),
      ),
    );
  }

}