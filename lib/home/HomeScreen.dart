import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google/navigationbar_screen.dart';
import 'package:hexcolor/hexcolor.dart';

import '../AIchatbot/chat_bot.dart';
import '../mypage/nick_model.dart';
class HomeScreen extends StatefulWidget{
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}
class HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final imgList = [
    AssetImage('images/imgslider1.png'),
    AssetImage('images/imgslider2.png'),
    AssetImage('images/imgslider3.png'),
    AssetImage('images/imgslider4.png'),
  ];

  @override
  void initState(){
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: Colors.white,
        ),
        _buildTop(),
        Positioned(top:ScreenUtil().setHeight(340.0),
            child:_buildmiddle() )
      ],
    );
}

Widget _buildTop()
{
  return CarouselSlider(
    options: CarouselOptions(height: ScreenUtil().setHeight(524.0),
        aspectRatio: 2.0,
        autoPlay: true,autoPlayInterval: Duration(seconds:5),
    enlargeCenterPage: true,
      autoPlayCurve: Curves.fastOutSlowIn,
      viewportFraction: 1.0,
    ),
  items: imgList.map((image){
    return Builder(
      builder:(BuildContext context){
        return Container(
          width: MediaQuery.of(context).size.width,
          child: Image(image: image, fit: BoxFit.fill),
        );
      }
    );
  }).toList(),
  );
}

Widget _buildmiddle(){
    return Column(
      children: [
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
                return Text('${nickname[0].nickname}님.\n오늘도 건강한 하루 되세요!', textAlign: TextAlign.left,
                  style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(20),
                    fontWeight: FontWeight.bold,
                  ),);
              }
            }
        ),
        SizedBox(
          height: ScreenUtil().setHeight(24.0),
        ),
        
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
              onPressed: (){
            //챗봇으로 연결
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => navigationbar_screen(2.toInt())));
          },
              style: ElevatedButton.styleFrom(
                primary: HexColor('#E76D3B'),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.0),
                ),
                minimumSize: Size(ScreenUtil().setWidth(328),ScreenUtil().setWidth(48)),
              ),

              child: Text(
                "TeenHelper에게 건강 질문하기", textAlign: TextAlign.center,
                style: TextStyle(
                color: Colors.white, fontSize: ScreenUtil().setSp(14.0)
              ),
              )),
        )
      ],
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