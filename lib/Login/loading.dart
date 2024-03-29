import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class loading extends StatefulWidget {
  @override
  _loading createState() => _loading();
}

class _loading extends State<loading> {

  @override
  void initState() {
    super.initState();
    /*Timer(const Duration(seconds: 3), () {
    });*/
    Future.delayed(Duration(seconds: 5)).then((value) {

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
                child: SizedBox(width:ScreenUtil().setWidth(216), height: ScreenUtil().setHeight(130),
                    child: Image.asset('images/loading.gif'))
            ),
          ],
        ),
      ),
    );
  }

}