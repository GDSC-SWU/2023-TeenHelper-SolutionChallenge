import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google/navigationbar_screen.dart';
import 'package:hexcolor/hexcolor.dart';
import '../mypage/nick_model.dart';
import 'event_model.dart';
import 'package:url_launcher/url_launcher.dart';

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
        Positioned(top: (MediaQuery.of(context).size.height * 0.4125),
            child:_buildmiddle() ),
        Positioned(top:(MediaQuery.of(context).size.height * 0.67),
            child:_buildbottom() )
      ],
    );
}

Widget _buildTop()
{
  return CarouselSlider(
    options: CarouselOptions(height: (MediaQuery.of(context).size.height * 0.655),
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
          height: (MediaQuery.of(context).size.height * 0.03),
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
                  borderRadius: BorderRadius.circular(26.0),
                ),
                minimumSize: Size(ScreenUtil().setWidth(328),ScreenUtil().setWidth(48)),
              ),

              child: Text(
                "TeenHelper에게 건강 질문하기", textAlign: TextAlign.center,
                style: TextStyle(
                color: Colors.white, fontSize: ScreenUtil().setSp(14.0)
              ),
              )),
        ),
      ],
    );
}

  Widget _buildbottom(){
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: (MediaQuery.of(context).size.width * 0.065)),
            child: Text("최근 이벤트",
              style: TextStyle(
                color: Color(0xff353535),
                fontSize: 16,
                fontFamily: "Spoqa Han Sans Neo",
                fontWeight: FontWeight.bold,
              ),),
          ),
          SizedBox(height: (MediaQuery.of(context).size.height * 0.01)),
          StreamBuilder<List<EventModel>>(
                stream: streamEvent(), // streamReview(review),
                builder: (context, asyncSnapshot) {
                  if(!asyncSnapshot.hasData) {
                    return Container(
                      margin: EdgeInsets.fromLTRB(ScreenUtil().setWidth(48), ScreenUtil().setWidth(40), 0, 0),
                      child: Text("",
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
                    List<EventModel> event = asyncSnapshot.data!;
                    return SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: (MediaQuery.of(context).size.height * 0.25),
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: event.length,
                        itemBuilder: (context, index) {
                          final url = Uri.parse(event[index].URL);
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InkWell(
                                child: SizedBox(
                                    width: ScreenUtil().setWidth(170),
                                    height: ScreenUtil().setWidth(78),
                                    child: Image.asset('images/event_image.png')),
                                onTap: () => {
                                  launchUrl(url, mode: LaunchMode.externalApplication),
                                },
                              ),
                              SizedBox(height: (MediaQuery.of(context).size.height * 0.005)),
                              Container(
                                margin: EdgeInsets.only(left: (MediaQuery.of(context).size.width * 0.06)),
                                width: ScreenUtil().setWidth(125),
                                child: Text(
                                  event[index].title,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Color(0xff353535),
                                    fontSize: 10,
                                    fontFamily: "Spoqa Han Sans Neo",
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB((MediaQuery.of(context).size.width * 0.06), ScreenUtil().setHeight(4), 0, 0),
                                width: ScreenUtil().setWidth(144),
                                child: Text(
                                  event[index].timeStamp,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Color(0xff6b6b6b),
                                    fontSize: 10,
                                    fontFamily: "Spoqa Han Sans Neo",
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    );
                  }
                }
            ),
        ],
      ),
    );
  }

  Stream<List<EventModel>> streamEvent() {
    try{
      // print("id는 $hospital");
      var db = FirebaseFirestore.instance;
      db.settings = const Settings(persistenceEnabled: false);
      final Stream<QuerySnapshot> snapshots = db.collection('Notification2').snapshots();
      return snapshots.map((querySnapshot){
        List<EventModel> event = [];//querySnapshot을 message로 옮기기 위해 List<MessageModel> 선언
        querySnapshot.docs.forEach((element) { //해당 컬렉션에 존재하는 모든 docs를 순회하며 messages 에 데이터를 추가한다.
          event.add(
              EventModel.fromMap(
                  map:element.data() as Map<String, dynamic>
              )
          );
        });
        print("길이는 ${event.length}");
        return event; //QuerySnapshot에서 List<MessageModel> 로 변경이 됐으니 반환
      });
    } catch(ex){
      log('error)',error: ex.toString(),stackTrace: StackTrace.current);
      return Stream.error(ex.toString());
    }
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