import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google/Login/loading.dart';
import 'package:google/Login/main_screen.dart';
import 'package:google/map/map_detail.dart';
import 'package:google/map/review_model.dart';
import 'package:google/mypage/nick_model.dart';
import 'package:google_sign_in/google_sign_in.dart';

class review_list_screen extends StatefulWidget {

  @override
  _review_list_screen createState() => _review_list_screen();
}

class _review_list_screen extends State<review_list_screen> {

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
        title: Text("내가 쓴 후기",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xff353535),
            fontSize: 16,
            fontFamily: "Spoqa Han Sans Neo",
            fontWeight: FontWeight.w500,),
        ),
      ),
      body: StreamBuilder<List<ReviewModel>>(
          stream: streamReview(FirebaseAuth.instance.currentUser!.uid.toString()), // streamReview(review),
          builder: (context, asyncSnapshot) {
            if(!asyncSnapshot.hasData) {
              return Container(
                margin: EdgeInsets.fromLTRB(ScreenUtil().setWidth(48), ScreenUtil().setWidth(40), 0, 0),
                child: Text("내가 쓴 후기가 없습니다.\n쉼터를 통해 의료적 지원을 받은 경험이 있다면 \n후기를 공유해주세요!",
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
              List<ReviewModel> review = asyncSnapshot.data!;
              return ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: review.length,
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
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(review[index].shelter_name,
                                        style: TextStyle( color: Color(0XFF353535), fontSize: 16,)),
                                    Container(
                                      margin: EdgeInsets.fromLTRB(ScreenUtil().setWidth(0), ScreenUtil().setHeight(10), 0, 0),
                                      child: Text(review[index].content,
                                          style: TextStyle( color: Color(0XFF353535), fontSize: 12,)),
                                    ),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.fromLTRB(ScreenUtil().setWidth(0), ScreenUtil().setHeight(10), ScreenUtil().setWidth(0), ScreenUtil().setHeight(0)),
                                                child: Image.asset('images/mylist_${review[index].hospital_id.toString()}.png', height: ScreenUtil().setHeight(16))
                                          ),
                                          Container(
                                            margin: EdgeInsets.fromLTRB(ScreenUtil().setWidth(8), ScreenUtil().setHeight(12), ScreenUtil().setWidth(0), ScreenUtil().setHeight(0)),
                                            child: Text(review[index].date,
                                                style: TextStyle( color: Color(0XFF6B6B6B), fontSize: 10,)),
                                          ),
                                        ],
                                    )
                                  ],
                                )
                            ),
                            onTap: () => {
                            Navigator.push(
                            context, MaterialPageRoute(builder: (_) => map_detail(review[index].shelter_id)))
                            },
                          ),
                        ],
                      );
                    },
                  );
            }
          }
      ),
    );
  }

  Stream<List<ReviewModel>> streamReview(String uid) {
    try{
      // print("id는 $hospital");
      var db = FirebaseFirestore.instance;
      db.settings = const Settings(persistenceEnabled: false);
      final Stream<QuerySnapshot> snapshots = db.collection('review')
          .where("uid", isEqualTo: uid)
          .orderBy('timeStamp', descending: true).snapshots();
      return snapshots.map((querySnapshot){
        List<ReviewModel> review = [];//querySnapshot을 message로 옮기기 위해 List<MessageModel> 선언
        querySnapshot.docs.forEach((element) { //해당 컬렉션에 존재하는 모든 docs를 순회하며 messages 에 데이터를 추가한다.
          review.add(
              ReviewModel.fromMap(
                  map:element.data() as Map<String, dynamic>
              )
          );
        });
        print("길이는 ${review.length}");
        return review; //QuerySnapshot에서 List<MessageModel> 로 변경이 됐으니 반환
      });
    } catch(ex){
      log('error)',error: ex.toString(),stackTrace: StackTrace.current);
      return Stream.error(ex.toString());
    }
  }
}