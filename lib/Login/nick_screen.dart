import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google/Login/gender_screen.dart';

class nick_screen extends StatefulWidget {
  @override
  _nickscreen createState() => _nickscreen();
}

class _nickscreen extends State<nick_screen> {

  final _nickTextEditController = TextEditingController();

  Future<void> UserWrite(String nickname) async {
    await FirebaseFirestore.instance.collection("user").doc(FirebaseAuth.instance.currentUser!.uid).set({
      "uid": FirebaseAuth.instance.currentUser!.uid,
      "email": FirebaseAuth.instance.currentUser!.email,
      "nickname": nickname,
    });
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => gender_screen()));
  }

  void showToast(String text)
  {
   Fluttertoast.showToast(
      msg: text,
     gravity: ToastGravity.CENTER,
     backgroundColor: Color(0xFFE76D3B),
     fontSize: ScreenUtil().setSp(16),
     textColor: Colors.white,
     toastLength: Toast.LENGTH_SHORT
    );
  }

  @override
  void dispose() {
    _nickTextEditController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                  margin: EdgeInsets.fromLTRB(ScreenUtil().setWidth(18), ScreenUtil().setHeight(104), ScreenUtil().setWidth(90), 0),
                  child: Text('닉네임을 설정해주세요',
                        style: TextStyle(fontSize: ScreenUtil().setSp(24), fontWeight: FontWeight.w700, color: Color(0xff353535)),
                        )
              ),
              Container(
                  margin: EdgeInsets.fromLTRB(ScreenUtil().setWidth(16), ScreenUtil().setHeight(10), ScreenUtil().setWidth(130), 0),
                  child: Text('닉네임은 10자 이하로 설정해주세요.',
                    style: TextStyle(fontSize: ScreenUtil().setSp(12), fontWeight: FontWeight.w200, color: Color(0xff353535)),
                  )
              ),
              Container(
                  margin: EdgeInsets.fromLTRB(ScreenUtil().setWidth(16), ScreenUtil().setHeight(24), ScreenUtil().setWidth(16), 0),
                  child: TextField(
                    controller: _nickTextEditController,
                    maxLength: 10,
                    decoration: InputDecoration(
                      hintText: '닉네임',
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFE76D3B))),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFE76D3B))),
                      ),
                    ),
                  ), // MediaQuery.of(context).viewInsets.bottom
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                    margin: EdgeInsets.fromLTRB(ScreenUtil().setWidth(16),ScreenUtil().setHeight(420),ScreenUtil().setWidth(16),ScreenUtil().setHeight(48) ),
                    child: InkWell(
                      child: Image.asset('images/nick_button.png'),
                      onTap: () => {
                        _nickTextEditController.text.length > 0 && _nickTextEditController.text.length <=10 ? UserWrite(_nickTextEditController.text) : "",
                        _nickTextEditController.text.length > 0 ? "" : showToast("닉네임을 입력해주세요."),
                        _nickTextEditController.text.length > 10 ? showToast("닉네임을 10자 이하로 설정해주세요.") : ""
                      }
                    )
                )
              )
            ],
          ),
        ),
      ),
    );
  }

}