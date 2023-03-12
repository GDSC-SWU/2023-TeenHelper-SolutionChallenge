import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google/map/map_detail.dart';

class map_screen extends StatelessWidget {
  const map_screen();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: ScreenUtil().setWidth(656),
        height: ScreenUtil().setWidth(200),
        child: ElevatedButton(
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (_) => map_detail()));
          },
          child: Text("지도 상세화면 보기"),
        ),
      ),
    );
  }
}