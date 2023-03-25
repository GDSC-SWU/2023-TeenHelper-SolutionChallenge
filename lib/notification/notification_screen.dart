import 'dart:async';
import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class notification extends StatefulWidget {
  const notification({super.key});

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
                title: Text('알림 설정'),
                centerTitle: true,
                shadowColor: Color(0xFF353535),
                leading: IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Color(0xFF0E0D0D),
                      size: 5 * 5,
                    ),
                    onPressed: () {
                      print("Icon Button clicked");
                    }),
              ),
            )),
        body: Column(
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
                  width: 180,
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
            //ListView.builder()
          ],
        ));
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
