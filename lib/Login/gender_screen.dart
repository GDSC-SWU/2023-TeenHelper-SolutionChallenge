import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google/navigationbar_screen.dart';

class gender_screen extends StatefulWidget {
  @override
  _genderscreen createState() => _genderscreen();
}

class _genderscreen extends State<gender_screen> {

  Future<void> UserWrite(String gender) async {

    await FirebaseFirestore.instance.collection("user").doc(FirebaseAuth.instance.currentUser!.uid).update({
      "gender": gender,
    });
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

  var male_image = true;
  var female_image = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                  margin: EdgeInsets.fromLTRB(ScreenUtil().setWidth(16), ScreenUtil().setHeight(104), ScreenUtil().setWidth(140), 0), // EdgeInsets.fromLTRB(16.w, 104.h, 140.w, 0.h),
                  child: Text('성별을 알려주세요',
                    style: TextStyle(fontSize: ScreenUtil().setSp(24), fontFamily: "Spoqa Han Sans Neo",fontWeight: FontWeight.w700, color: Color(0xff353434)),
                  )
              ),
              Container(
                  margin: EdgeInsets.fromLTRB(ScreenUtil().setWidth(18), ScreenUtil().setHeight(10), ScreenUtil().setWidth(75), 0.h),
                  child: Text('성별에 따라 적절한 쉼터를 추천받을 수 있습니다.',
                    style: TextStyle(fontSize: ScreenUtil().setSp(12), fontFamily: "Spoqa Han Sans Neo", fontWeight: FontWeight.w100, color: Color(0xff353434)),
                  )
              ),
              Container(
                  margin: EdgeInsets.fromLTRB(ScreenUtil().setWidth(16),ScreenUtil().setHeight(24).h,ScreenUtil().setWidth(16),0),
                  child: Row(
                    children: [
                      InkWell(
                        child: Image.asset(male_image ? 'images/male_off.png': 'images/male_on.png', height: ScreenUtil().setHeight(88), width: ScreenUtil().setWidth(88)),
                        onTap: () => {
                          setState((){
                            male_image = !male_image;
                          }),
                          male_image == true && female_image == true ? showToast("성별을 선택해주세요.") : "",
                          male_image == false && female_image == true ? UserWrite("male") : UserWrite("female")
                        },
                      ),
                      Container(
                        child: InkWell(
                          child: Image.asset(female_image ? 'images/female_off.png': 'images/female_on.png', height: ScreenUtil().setHeight(88), width: ScreenUtil().setWidth(88)),
                          onTap: () => {
                            setState((){
                             female_image = !female_image;
                            }),
                            male_image == true && female_image == false ? UserWrite("female") : UserWrite("male")
                          },
                        ),
                      ),
                    ],
                  )
              ),
              Container(
                  margin: EdgeInsets.fromLTRB(ScreenUtil().setWidth(16),ScreenUtil().setHeight(400),ScreenUtil().setWidth(16),ScreenUtil().setHeight(48)),
                  child: InkWell(
                    child: Image.asset('images/join_button.png'),
                    onTap: () => {
                      male_image == true && female_image == true ? showToast("성별을 선택해주세요.") : Navigator.pushReplacement(
                          context, MaterialPageRoute(builder: (_) => navigationbar_screen())),
                    },
                  )
              )
            ],
          ),
        ),
      ),
    );
  }

}