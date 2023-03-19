import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google/mypage/review_list_screen.dart';

class my_loading extends StatefulWidget {
  @override
  _my_loading createState() => _my_loading();
}

class _my_loading extends State<my_loading> {

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3)).then((value) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => review_list_screen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                margin: EdgeInsets.fromLTRB(ScreenUtil().setSp(16), 0, ScreenUtil().setSp(16), 0),
                child: Image.asset('images/loading.gif')
            ),
          ],
        ),
      ),
    );
  }

}