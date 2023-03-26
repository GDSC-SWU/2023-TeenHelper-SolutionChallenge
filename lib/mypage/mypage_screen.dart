import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google/Login/main_screen.dart';
import 'package:google/mypage/information_screen.dart';
import 'package:google/mypage/nick_model.dart';
import 'package:google/mypage/review_list_screen.dart';
import 'package:google/mypage/scrap_screen.dart';
import 'package:google/notification/notification_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';

class mypage_screen extends StatefulWidget {

  @override
  _mypage_screen createState() => _mypage_screen();
}

class _mypage_screen extends State<mypage_screen> {

  String? image_url = FirebaseAuth.instance.currentUser!.photoURL.toString();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          children: [
            Container(
              width: ScreenUtil().setWidth(360),
              height: ScreenUtil().setHeight(246),
              color: Color(0xffe76d3b),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Row(
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(ScreenUtil().setWidth(24), ScreenUtil().setHeight(64), 0, 0),
                            width: ScreenUtil().setWidth(62),
                            height: ScreenUtil().setHeight(62),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: NetworkImage(image_url!),
                              ),
                            ),
                          ),
                          StreamBuilder<List<NickModel>>(
                            stream: streamNickname(),
                            builder: (context, asyncSnapshot) {
                              if(!asyncSnapshot.hasData){
                                return Container(
                                  margin: EdgeInsets.fromLTRB(ScreenUtil().setWidth(16), ScreenUtil().setHeight(64), 0, 0),
                                  child: Text(
                                    "닉네임이 없습니다",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontFamily: "Spoqa Han Sans Neo",
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                );
                              } else if (asyncSnapshot.hasError){
                                List<NickModel> nickname = asyncSnapshot.data!;
                                return Container(
                                  margin: EdgeInsets.fromLTRB(ScreenUtil().setWidth(16), ScreenUtil().setHeight(64), 0, 0),
                                  child: Text(
                                    "오류가 발생했습니다.",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: ScreenUtil().setSp(16),
                                      fontFamily: "Spoqa Han Sans Neo",
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                );
                              } else {
                                List<NickModel> nickname = asyncSnapshot.data!;
                                return Container(
                                  margin: EdgeInsets.fromLTRB(ScreenUtil().setWidth(16), ScreenUtil().setHeight(50), 0, 0),
                                  child: Text(
                                    nickname[0].nickname,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: ScreenUtil().setSp(16),
                                      fontFamily: "Spoqa Han Sans Neo",
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                );
                              }
                            }
                          ),
                              Container(
                                margin: EdgeInsets.fromLTRB(ScreenUtil().setWidth(4), ScreenUtil().setHeight(56), 0, 0),
                                child: Text(
                                      "청소년",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: ScreenUtil().setSp(12),
                                        fontFamily: "Spoqa Han Sans Neo",
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                              ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(ScreenUtil().setWidth(102), ScreenUtil().setHeight(110), 0, 0),
                        child: Text(
                          FirebaseAuth.instance.currentUser!.email.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: ScreenUtil().setSp(12),
                            fontFamily: "Spoqa Han Sans Neo",
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: ScreenUtil().setWidth(328),
                    height: ScreenUtil().setHeight(78),
                    margin: EdgeInsets.fromLTRB(ScreenUtil().setWidth(16), ScreenUtil().setHeight(20), ScreenUtil().setWidth(16), ScreenUtil().setHeight(16)),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [ BoxShadow(
                        color: Color(0xffe76d3b),
                        blurRadius: 8,
                        offset: Offset(0,0)
                      ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: ScreenUtil().setWidth(35)),
                          child: InkWell(
                            child: Image.asset('images/mypage_button_shelter.png'),
                            onTap: () => {
                              Navigator.push(
                                  context, MaterialPageRoute(builder: (_) => scrap_screen()))
                            },
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: ScreenUtil().setWidth(35)),
                          child: InkWell(
                            child: Image.asset('images/mypage_button_review.png'),
                            onTap: () => {
                              Navigator.push(
                                  context, MaterialPageRoute(builder: (_) => review_list_screen()))
                            },
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: ScreenUtil().setWidth(35)),
                          child: InkWell(
                            child: Image.asset('images/mypage_button_notification.png'),
                            onTap: () => {
                              Navigator.push(context, MaterialPageRoute(builder: (_) => notification()))
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )
            ),
            InkWell(
              child: Container(
                padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(16), ScreenUtil().setWidth(22), 0, 0),
                width: ScreenUtil().setWidth(360),
                height: ScreenUtil().setHeight(64),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(
                      color: Color(0xffE9E9E9),
                      width: 1.0)),),
                child: Text(
                  "회원 정보",
                  style: TextStyle(
                    color: Color(0xff353535),
                    fontSize: ScreenUtil().setSp(14),
                  ),
                ),
              ),
              onTap: () => {
                Navigator.push(
                context, MaterialPageRoute(builder: (_) => information_screen()))
              },
            ),
            InkWell(
              onTap: () => {
                information_screen()
              },
              child: Container(
                padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(16), ScreenUtil().setWidth(22), 0, 0),
                width: ScreenUtil().setWidth(360),
                height: ScreenUtil().setHeight(64),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(
                      color: Color(0xffE9E9E9),
                      width: 1.0)),),
                child: Text(
                  "고객 센터",
                  style: TextStyle(
                    color: Color(0xff353535),
                    fontSize: ScreenUtil().setSp(14),
                  ),
                ),
              ),
            ),
            InkWell(
              child: Container(
                padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(16), ScreenUtil().setWidth(22), 0, 0),
                width: ScreenUtil().setWidth(360),
                height: ScreenUtil().setHeight(64),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(
                      color: Color(0xffE9E9E9),
                      width: 1.0)),),
                child: Text(
                  "로그아웃",
                  style: TextStyle(
                    color: Color(0xff353535),
                    fontSize: ScreenUtil().setSp(14),
                  ),
                ),
              ),
              onTap: () => {
                FirebaseAuth.instance.signOut(),
                GoogleSignIn().signOut(),
                Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => main_screen()))
              },
            )
          ],
        ),
    );
  }

  Stream<List<NickModel>> streamNickname() {
    try{
      var db = FirebaseFirestore.instance;
      db.settings = const Settings(persistenceEnabled: false);
      final Stream<QuerySnapshot> snapshots = db.collection('user')
      .where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid.toString()).snapshots();
      return snapshots.map((querySnapshot){
        List<NickModel> nickname = [];//querySnapshot을 message로 옮기기 위해 List<MessageModel> 선언
        querySnapshot.docs.forEach((element) { //해당 컬렉션에 존재하는 모든 docs를 순회하며 messages 에 데이터를 추가한다.
          nickname.add(
              NickModel.fromMap(
                  map:element.data() as Map<String, dynamic>
              )
          );
        });
        return nickname; //QuerySnapshot에서 List<MessageModel> 로 변경이 됐으니 반환
      });
    } catch(ex){
      log('error)',error: ex.toString(),stackTrace: StackTrace.current);
      return Stream.error(ex.toString());
    }
  }

}