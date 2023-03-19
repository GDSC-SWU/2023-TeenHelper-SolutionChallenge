import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class splash_screen extends StatefulWidget {
  @override
  _splash_screen createState() => _splash_screen();
}

class _splash_screen extends State<splash_screen> {
  
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3)).then((value) {
      Navigator.pushReplacementNamed(context, '/main');
    });

    /*Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(
          context, '/main');
    });*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                margin: EdgeInsets.fromLTRB(ScreenUtil().setSp(82), 0, ScreenUtil().setSp(82), 0),
                child: Image.asset('images/loading.gif', height: ScreenUtil().setHeight(119), width: ScreenUtil().setWidth(196),)
            ),
            Container(
                margin: EdgeInsets.fromLTRB(ScreenUtil().setSp(72), ScreenUtil().setSp(15), ScreenUtil().setSp(72), 0),
                child: Image.asset('images/splash_logo.png', height: ScreenUtil().setHeight(22), width: ScreenUtil().setWidth(216),)
            ),
          ],
        ),
      ),
    );
  }



}