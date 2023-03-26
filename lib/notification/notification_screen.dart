import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import '../home/event_model.dart';

class notification extends StatefulWidget {
  // const notification({super.key});

  @override
  State<notification> createState() => _notificationState();
}

class _notificationState extends State<notification> {
  bool value = true;
  @override
  void initState() {
    super.initState();

    // Listen to changes in the Firebase collection
    FirebaseFirestore.instance
        .collection('Notification')
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      // When new data is available, build and send the notification
      snapshot.docChanges.forEach((change) {
        if (change.type == DocumentChangeType.added) {
          String? title = '알림';
          String? body = change.doc.data().toString();

          AwesomeNotifications().createNotification(
            content: NotificationContent(
              id: 123,
              channelKey: "call_channel",
              color: Colors.white,
              title: title,
              body: body,
              category: NotificationCategory.Call,
              wakeUpScreen: true,
              fullScreenIntent: true,
              autoDismissible: false,
              backgroundColor: Colors.orange,
            ),
          );
        }
      });
    });

    /*FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      String? title = message.notification!.title;
      String? body = message.notification!.body;

      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 123,
          channelKey: "call_channel",
          color: Colors.white,
          title: title,
          body: body,
          category: NotificationCategory.Call,
          wakeUpScreen: true,
          fullScreenIntent: true,
          autoDismissible: false,
          backgroundColor: Colors.orange,
        ),
        
          actionButtons: [
            NotificationActionButton(
              key: "ACCEPT",
              label: "Accept Call",
              color: Colors.green,
              autoDismissible: true,
            ),
            NotificationActionButton(
              key: "REJECT",
              label: "Reject Call",
              color: Colors.red,
              autoDismissible: true,
            ),
          ]
      );
      AwesomeNotifications().actionStream.listen((event) {
        if (event.buttonKeyPressed == "REJECT") {
          print("Call rejected");
        } else if (event.buttonKeyPressed == 'ACCEPT') {
          print("Call Accepted");
        } else {
          print("Clicked on notification");
        }
      });
    });*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: Container(
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset(0, 0.1),
                  blurRadius: 4.0,
                )
              ]),
              child: AppBar(
                elevation: 0,
                title: Text("알림 설정",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xff353535),
                    fontSize: 16,
                    fontFamily: "Spoqa Han Sans Neo",
                    fontWeight: FontWeight.w500,),
                ),
                backgroundColor: Colors.white,
                centerTitle: true,
                shadowColor: Color(0xFF353535),
                leading: IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Color(0xFF0E0D0D),
                      size: 5 * 5,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
              ),
            )),
        body: SingleChildScrollView(
          child: Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 90,
                    width: double.infinity,
                    //color: Colors.ornge,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Color(0xFFE9E9E9),
                          width: 3.0,
                        ),
                      ),
                    ),
                    child: Row(children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Text(
                          '이벤트 알림 받기',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      SizedBox(
                        width: 170,
                      ),
                      //SwitchExample()
                      buildSwith()
                    ]),
                  ),
                  Container(
                    height: 90,
                    width: double.infinity,
                    //color: Colors.ornge,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Color(0xFFE9E9E9),
                          width: 3.0,
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0, top: 25),
                      child: Text(
                        '이벤트 알림 내역',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                 Container(
                      width: MediaQuery.of(context).size.width,
                      child: SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        child: StreamBuilder<List<EventModel>>(
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
                                return Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    itemCount: event.length,
                                    itemBuilder: (context, index) {
                                      final url = Uri.parse(event[index].URL);
                                      return Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          InkWell(
                                            child: Container(
                                                padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(16), ScreenUtil().setHeight(16), ScreenUtil().setWidth(16), ScreenUtil().setHeight(16)),
                                                decoration: BoxDecoration(
                                                    border: Border(bottom: BorderSide(
                                                        color: Color(0xffE9E9E9),
                                                        width: 1.0)),
                                                    color: Color(0xFFFFF7F3)
                                                ),
                                                width: ScreenUtil().setWidth(360),
                                                child: Row(
                                                  children: [
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Container(
                                                          width: 360,
                                                          child: Text(event[index].title,
                                                              overflow: TextOverflow.ellipsis,
                                                              style: TextStyle( color: Color(0XFF353535), fontSize: 14,)),
                                                        ),
                                                        Container(
                                                          margin: EdgeInsets.fromLTRB(ScreenUtil().setWidth(0), ScreenUtil().setHeight(10), 0, 0),
                                                          child: Text(event[index].timeStamp,
                                                              style: TextStyle( color: Color(0XFF353535), fontSize: 12,)),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                )
                                            ),
                                            onTap: () => {
                                              launchUrl(url, mode: LaunchMode.externalApplication),
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                );
                              }
                            }
                        ),
                      ),
                    ),
                  //ListView.builder()
                ],
              ),
            ),
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

  Widget buildSwith() => Transform.scale(
      scale: 1,
      child: Switch(
          activeColor: Colors.white,
          activeTrackColor: Color(0xFFE76D3B),
          inactiveThumbColor: Colors.white,
          inactiveTrackColor: Color(0xFFFCD8C6),
          value: value,
          onChanged: (newValue) async {
            setState(() {
              value = newValue;
            });
            if (value) {
              //String? token = await FirebaseMessaging.instance.getToken();
              //print(token);
              sendPushNotification();
            } else {
              FirebaseMessaging.instance.deleteToken();
            }
          }));

  Future<void> sendPushNotification() async {
    print("캬캬ㅑㅋ");
    try {
      print("들어옴");
      final serverKey = dotenv.env['SERVER_KEY'];
      String? token = await FirebaseMessaging.instance.getToken();
      print(token);
      //final token = dotenv.env['devicetoken'];
      //print(token);

      http.Response response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverKey',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': "TeenHelper",
              'title': 'Incoming Call',
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done'
            },
            'to': token,
          },
        ),
      );
      response;
    } catch (e) {
      e;
    }
  }

  Future<void> deleteToken() async {
    try {} catch (e) {
      e;
    }
  }
}
