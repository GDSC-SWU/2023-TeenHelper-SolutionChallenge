import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google/Login/loading.dart';
import 'package:google/Login/main_screen.dart';
import 'package:google/google_map/scrap_model.dart';
import 'package:google/map/map_detail.dart';
import 'package:google/map/review_model.dart';
import 'package:google/mypage/nick_model.dart';
import 'package:google_sign_in/google_sign_in.dart';

class scrap_screen extends StatefulWidget {

  @override
  _scrap_screen createState() => _scrap_screen();
}

class _scrap_screen extends State<scrap_screen> {

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
        title: Text("즐겨찾는 쉼터",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xff353535),
            fontSize: 16,
            fontFamily: "Spoqa Han Sans Neo",
            fontWeight: FontWeight.w500,),
        ),
      ),
      body: SingleChildScrollView(
        child: StreamBuilder<List<ScrapModel>>(
            stream: streamScrap(), // streamReview(review),
            builder: (context, asyncSnapshot) {
              if(!asyncSnapshot.hasData) {
                return Container(
                  margin: EdgeInsets.fromLTRB(ScreenUtil().setWidth(48), ScreenUtil().setWidth(40), 0, 0),
                  child: Text("즐겨찾는 쉼터가 없습니다.\n지도에서 즐겨찾는 쉼터를 추가해보세요!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF6B6B6B),
                        fontSize: 14,
                      )
                  ),
                );
              } else if (asyncSnapshot.hasError){
                return const Center(
                  child: Text('오류가 발생했습니다.'),);
              } else {
                List<ScrapModel> scrap = asyncSnapshot.data!;
                return ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: scrap.length,
                  itemBuilder: (context, index) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          child: Container(
                              padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(16), ScreenUtil().setHeight(16), ScreenUtil().setWidth(16), ScreenUtil().setHeight(16)),
                              decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(
                                      color: Colors.grey,
                                      width: 1.0)),
                                  color: Color(0xFFF3F3F3)
                              ),
                              width: ScreenUtil().setWidth(360),
                              child: Row(
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(scrap[index].shelter_name,
                                          style: TextStyle( color: Color(0XFF353535), fontSize: 16,)),
                                      Container(
                                        margin: EdgeInsets.fromLTRB(ScreenUtil().setWidth(0), ScreenUtil().setHeight(10), 0, 0),
                                        child: Text(scrap[index].shelter_location,
                                            style: TextStyle( color: Color(0XFF353535), fontSize: 12,)),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(left: ScreenUtil().setWidth(16)),
                                    child: InkWell(
                                      child: Image.asset(scrap[index].scrap == true ? 'images/staron_btn.png' : 'images/staroff_btn.png'),
                                      onTap: () => {
                                        scrapEdit(!scrap[index].scrap, scrap[index].shelter_id)
                                      }
                                    ),
                                  )
                                ],
                              )
                          ),
                          onTap: () => {
                            Navigator.push(
                                context, MaterialPageRoute(builder: (_) => map_detail(scrap[index].shelter_id)))
                          },
                        ),
                      ],
                    );
                  },
                );
              }
            }
        ),
      ),
    );
  }

  Stream<List<ScrapModel>> streamScrap() {
    try{
      // print("id는 $hospital");
      var db = FirebaseFirestore.instance;
      db.settings = const Settings(persistenceEnabled: false);
      final Stream<QuerySnapshot> snapshots = db.collection('scrap')
          .where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid.toString())
          .where("scrap", isEqualTo: true).snapshots();
      return snapshots.map((querySnapshot){
        List<ScrapModel> scrap = [];//querySnapshot을 message로 옮기기 위해 List<MessageModel> 선언
        querySnapshot.docs.forEach((element) { //해당 컬렉션에 존재하는 모든 docs를 순회하며 messages 에 데이터를 추가한다.
          scrap.add(
              ScrapModel.fromMap(
                  map:element.data() as Map<String, dynamic>
              )
          );
        });
        print("scrap 길이는 ${scrap.length}");
        return scrap; //QuerySnapshot에서 List<MessageModel> 로 변경이 됐으니 반환
      });
    } catch(ex){
      log('error)',error: ex.toString(),stackTrace: StackTrace.current);
      return Stream.error(ex.toString());
    }
  }

  Future<void> scrapEdit(bool scrap, int shelter_id) async {
    await FirebaseFirestore.instance.collection("scrap").doc(FirebaseAuth.instance.currentUser!.uid + shelter_id.toString()).update(
        {
          "scrap": scrap,
        });
  }

}