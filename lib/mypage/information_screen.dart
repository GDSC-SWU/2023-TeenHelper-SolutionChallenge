import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google/Login/main_screen.dart';
import 'package:google/mypage/nick_model.dart';
import 'package:google_sign_in/google_sign_in.dart';

class information_screen extends StatefulWidget {

  @override
  _information_screen createState() => _information_screen();
}

class _information_screen extends State<information_screen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        shadowColor: Color(0xffE9E9E9),
        backgroundColor: Colors.white,
        leading: InkWell(
          child: Image.asset('images/detail_back_btn.png'),
          onTap: () =>
          {
            Navigator.pop(context)
          },
        ),
        title: Text("회원 정보",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xff353535),
            fontSize: 16,
            fontFamily: "Spoqa Han Sans Neo",
            fontWeight: FontWeight.w500,),
        ),
      ),
      body: Column(
        children: [
          InkWell(
            child: Container(
              padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(16), ScreenUtil().setWidth(20), 0, ScreenUtil().setWidth(0)),
              width: ScreenUtil().setWidth(360),
              height: ScreenUtil().setHeight(65),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(
                    color: Color(0xffE9E9E9),
                    width: ScreenUtil().setWidth(1))),),
              child: Text(
                "이메일 정보",
                style: TextStyle(
                  color: Color(0xff353535),
                  fontSize: ScreenUtil().setSp(14),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          InkWell(
            child: Container(
              padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(16), ScreenUtil().setWidth(14), 0, ScreenUtil().setWidth(0)),
              width: ScreenUtil().setWidth(360),
              height: ScreenUtil().setHeight(56),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(
                    color: Color(0xffE9E9E9),
                    width: ScreenUtil().setWidth(8))),),
              child: Text(
                FirebaseAuth.instance.currentUser!.email.toString(),
                style: TextStyle(
                  color: Color(0xff353535),
                  fontSize: ScreenUtil().setSp(13),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          InkWell(
            child: Container(
              padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(16), ScreenUtil().setWidth(20), 0, ScreenUtil().setWidth(0)),
              width: ScreenUtil().setWidth(360),
              height: ScreenUtil().setHeight(65),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(
                    color: Color(0xffE9E9E9),
                    width: ScreenUtil().setWidth(1))),),
              child: Text(
                "기타",
                style: TextStyle(
                  color: Color(0xff353535),
                  fontSize: ScreenUtil().setSp(14),
                  fontWeight: FontWeight.w400,
                ),
              ),
            )
          ),
          InkWell(
            child: Container(
              padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(16), ScreenUtil().setWidth(14), 0, ScreenUtil().setWidth(0)),
              width: ScreenUtil().setWidth(360),
              height: ScreenUtil().setHeight(49),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(
                    color: Color(0xffE9E9E9),
                    width: ScreenUtil().setWidth(1))),),
              child: Text(
                "서비스 이용약관",
                style: TextStyle(
                  color: Color(0xff353535),
                  fontSize: ScreenUtil().setSp(13),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          InkWell(
            child: Container(
              padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(16), ScreenUtil().setWidth(14), 0, ScreenUtil().setWidth(0)),
              width: ScreenUtil().setWidth(360),
              height: ScreenUtil().setHeight(49),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(
                    color: Color(0xffE9E9E9),
                    width: ScreenUtil().setWidth(1))),),
              child: Text(
                "개인정보 처리방침",
                style: TextStyle(
                  color: Color(0xff353535),
                  fontSize: ScreenUtil().setSp(13),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          InkWell(
            child: Container(
              padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(16), ScreenUtil().setWidth(14), 0, ScreenUtil().setWidth(0)),
              width: ScreenUtil().setWidth(360),
              height: ScreenUtil().setHeight(56),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(
                    color: Color(0xffE9E9E9),
                    width: ScreenUtil().setWidth(8))),),
              child: Text(
                "위치기반서비스 이용약관",
                style: TextStyle(
                  color: Color(0xff353535),
                  fontSize: ScreenUtil().setSp(13),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          InkWell(
            child: Container(
              padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(16), ScreenUtil().setWidth(20), 0, ScreenUtil().setWidth(0)),
              width: ScreenUtil().setWidth(360),
              height: ScreenUtil().setHeight(65),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(
                    color: Color(0xffE9E9E9),
                    width: ScreenUtil().setWidth(1))),),
              child: Text(
                "회원 탈퇴",
                style: TextStyle(
                  color: Color(0xff353535),
                  fontSize: ScreenUtil().setSp(14),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            onTap: () => {
              FirebaseFirestore.instance.collection('user').doc(FirebaseAuth.instance.currentUser!.uid).delete(),
              FirebaseAuth.instance.currentUser!.delete(),
              FirebaseAuth.instance.signOut(),
              GoogleSignIn().signOut(),
              Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => main_screen()))
            },
          ),
        ],
      ),
    );
  }
}