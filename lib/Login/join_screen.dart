import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google/login/nick_screen.dart';

class join_screen extends StatelessWidget {

  @override
  void googleSignOut() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();
    await _auth.signOut();
    await googleSignIn.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(ScreenUtil().setWidth(44),ScreenUtil().setHeight(110),ScreenUtil().setWidth(44),ScreenUtil().setHeight(0)),
              child: Image.asset('images/login_image_complete.png'),
            ),
            Container(
                margin: EdgeInsets.only(top: 75.h),
                child: Text('회원가입 완료!',
                  style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w700, color: Color(0xff353535)),
                  textAlign: TextAlign.center,
                )
            ),
            Container(
                margin: EdgeInsets.only(top: 16.h),
                child: Text('닉네임, 성별 등 기본 정보를 입력하면 \n'
                    '보다 맞춤화된 기능을 사용할 수 있습니다.',
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w400, color: Color(0xff6B6B6B)),
                  textAlign: TextAlign.center,
                )
            ),
            Container(
              margin: EdgeInsets.only(top: 55.h),
              child: InkWell(
                child: Image.asset('images/join_input_button.png'),
                onTap: () => {
                  Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (_) => nick_screen())),
                  // googleSignOut()
                },
              )
            )
            ],
        )
      )
    );
  }

}