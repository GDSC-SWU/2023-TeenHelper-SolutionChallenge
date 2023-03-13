import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google/Login/loading.dart';
import 'package:google/map/detail_model.dart';
import 'package:google/map/review_model.dart';
import 'package:google/map/review_write_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class map_detail extends StatefulWidget {

  @override
  _map_detail createState() => _map_detail();
}

class _map_detail extends State<map_detail> {

  int id = 42;
  int hospital = 1;
  String hospital_subject = "내과";
  bool hospital_1 = false;
  bool hospital_2 = false;
  bool hospital_3 = false;
  bool hospital_4 = false;
  bool hospital_5 = false;
  bool hospital_6 = false;
  bool hospital_7 = false;
  bool hospital_8 = false;
  bool hospital_9 = false;

  List<String> _mynamelist=[];
  List<String> _myemaillist=[];
  List<String> _myphnumlist=[];
  List<String> _mylocationlist=[];
  List<String> _mytypelist=[];
  List<String> _mygenderlist=[];
  List<String> _mytimelist=[];
  late List<int> _myidlist;

  Future<void> loadDetailData() async {
    final datalist = await getmySQLDetailData(id);
    final mynamelist = datalist.map((data) => data.shelter_name).toList();
    final myemaillist = datalist.map((data) => data.shelter_email).toList();
    final myphnumlist = datalist.map((data) => data.shelter_phnum).toList();
    final mylocationlist = datalist.map((data) => data.shelter_location).toList();
    final mytypelist = datalist.map((data) => data.shelter_type).toList();
    final mygenderlist = datalist.map((data) => data.shelter_gender).toList();
    final mytimelist = datalist.map((data) => data.shelter_time).toList();
    final myidlist = datalist.map((data) => data.shelter_id).toList();

    setState(() {
      _mynamelist = mynamelist;
      _myemaillist = myemaillist;
      _myphnumlist = myphnumlist;
      _mylocationlist = mylocationlist;
      _mytypelist = mytypelist;
      _mygenderlist = mygenderlist;
      _mytimelist = mytimelist;
      _myidlist = myidlist;

    });
  }


  @override
  Widget build(BuildContext context) {
    loadDetailData();
    if (_mynamelist.length <= 0) {
      return loading();
    } else {
      return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            shadowColor: Color(0xffE9E9E9),
            backgroundColor: Colors.white,
            leading: InkWell(
              child: Image.asset('images/detail_back_btn.png'),
              onTap: () => {
                Navigator.pop(context)
              },
            ),
            actions: [
              InkWell(
                child: Image.asset('images/staroff_btn.png'),
                onTap: () => {

                },
              ),],
            title: Text(_mynamelist[0],
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xff353535),
                fontSize: 16,
                fontFamily: "Spoqa Han Sans Neo",
                fontWeight: FontWeight.w500,),
            ),
          ),
          floatingActionButton: Padding(
            padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(8)),
            child: SizedBox(
              width: ScreenUtil().setWidth(56),
              height: ScreenUtil().setHeight(56),
              child: FloatingActionButton(
                elevation: 0,
                backgroundColor: Color(0xE76D3B),
                child: Image.asset('images/review_floating_btn.png'),
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => review_write_screen(_mynamelist[0], _myidlist[0])));
                },
              ),
            ),
          ),
          body: SingleChildScrollView (
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column (
              children: [
                Container(
                  // alignment: Alignment.center,
                  margin: EdgeInsets.fromLTRB(ScreenUtil().setWidth(16), ScreenUtil().setHeight(16), ScreenUtil().setWidth(0), ScreenUtil().setHeight(0)),
                  width: ScreenUtil().setWidth(360),
                  height: ScreenUtil().setHeight(70),
                  child: Row(
                    children: [
                      InkWell(
                        child: Image.asset('images/detail_btn_call.png', width: ScreenUtil().setWidth(160), height: ScreenUtil().setHeight(34)),
                        onTap: () => {
                        launch("tel://${_myphnumlist[0]}"),
                        },),
                      Container(
                        margin: EdgeInsets.fromLTRB(ScreenUtil().setWidth(8), ScreenUtil().setHeight(0), ScreenUtil().setWidth(16), ScreenUtil().setHeight(0)),
                        child: InkWell(
                          child: Image.asset('images/detail_btn_bell.png', width: ScreenUtil().setWidth(160), height: ScreenUtil().setHeight(34)),
                          onTap: () => {

                          },),
                      ),
                    ],
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(top: ScreenUtil().setWidth(16)),
                    width: ScreenUtil().setWidth(360),
                    height: ScreenUtil().setHeight(60),
                    decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide (
                            color: Color(0xffe9e9e9),
                            width: 1.0,
                          ),
                          bottom: BorderSide (
                            color: Color(0xffe9e9e9),
                            width: 1.0,
                          ),
                        )
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            margin: EdgeInsets.only(left: ScreenUtil().setWidth(16)),
                            child: Image.asset('images/detail_icon_address.png')),
                        Container(
                          margin: EdgeInsets.only(left: ScreenUtil().setWidth(8)),
                          child: Text(_mylocationlist[0],
                              style: TextStyle(
                                color: Color(0xFF353535),
                                fontSize: 14,
                              )),
                        )
                      ],
                    )
                ),
                Container(
                    width: ScreenUtil().setWidth(360),
                    height: ScreenUtil().setHeight(60),
                    decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide (
                            color: Color(0xffe9e9e9),
                            width: 1.0,
                          ),
                        )
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            margin: EdgeInsets.only(left: ScreenUtil().setWidth(16)),
                            child: Image.asset('images/detail_icon_gender.png')),
                        Container(
                          margin: EdgeInsets.only(left: ScreenUtil().setWidth(8)),
                          child: Text(_mygenderlist[0],
                              style: TextStyle(
                                color: Color(0xFF353535),
                                fontSize: 14,
                              )),
                        )
                      ],
                    )
                ),
                Container(
                    width: ScreenUtil().setWidth(360),
                    height: ScreenUtil().setHeight(60),
                    decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide (
                            color: Color(0xffe9e9e9),
                            width: 1.0,
                          ),
                        )
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            margin: EdgeInsets.only(left: ScreenUtil().setWidth(16)),
                            child: Image.asset('images/detail_icon_type.png')),
                        Container(
                          margin: EdgeInsets.only(left: ScreenUtil().setWidth(8)),
                          child: Text(_mytypelist[0],
                              style: TextStyle(
                                color: Color(0xFF353535),
                                fontSize: 14,
                              )),
                        )
                      ],
                    )
                ),
                Container(
                    width: ScreenUtil().setWidth(360),
                    height: ScreenUtil().setHeight(208),
                    decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide (
                            color: Color(0xffe9e9e9),
                            width: 1.0,
                          ),
                        )
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: ScreenUtil().setHeight(15)),
                            child: Row(
                              // mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    margin: EdgeInsets.fromLTRB(ScreenUtil().setWidth(16), ScreenUtil().setHeight(4), 0, 0),
                                    child: Image.asset('images/detail_icon_time.png')),
                                Container(
                                    margin: EdgeInsets.only(left: ScreenUtil().setWidth(8)),
                                    child: Row (
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text("월",
                                            style: TextStyle(
                                              color: Color(0xff6B6B6B),
                                              fontSize: 14,
                                            )),
                                        Container(
                                          margin: EdgeInsets.fromLTRB(ScreenUtil().setWidth(8), ScreenUtil().setHeight(3), 0, 0),
                                          child: Text(
                                            _mytimelist[0],
                                            style: TextStyle(
                                              color: Color(0xFF353535),
                                              fontSize: 14,),),
                                        )
                                      ],
                                    )
                                )
                              ],
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.fromLTRB(ScreenUtil().setWidth(38), ScreenUtil().setHeight(4), 0, 0),
                              child: Row (
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text("화",
                                      style: TextStyle(
                                        color: Color(0xff6B6B6B),
                                        fontSize: 14,
                                      )),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(ScreenUtil().setWidth(8), ScreenUtil().setHeight(3), 0, 0),
                                    child: Text(
                                      _mytimelist[0],
                                      style: TextStyle(
                                        color: Color(0xFF353535),
                                        fontSize: 14,),),
                                  )
                                ],
                              )
                          ),
                          Container(
                              margin: EdgeInsets.fromLTRB(ScreenUtil().setWidth(38), ScreenUtil().setHeight(4), 0, 0),
                              child: Row (
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text("수",
                                      style: TextStyle(
                                        color: Color(0xff6B6B6B),
                                        fontSize: 14,
                                      )),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(ScreenUtil().setWidth(8), ScreenUtil().setHeight(3), 0, 0),
                                    child: Text(
                                      _mytimelist[0],
                                      style: TextStyle(
                                        color: Color(0xFF353535),
                                        fontSize: 14,),),
                                  )
                                ],
                              )
                          ),
                          Container(
                              margin: EdgeInsets.fromLTRB(ScreenUtil().setWidth(38), ScreenUtil().setHeight(4), 0, 0),
                              child: Row (
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text("목",
                                      style: TextStyle(
                                        color: Color(0xff6B6B6B),
                                        fontSize: 14,
                                      )),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(ScreenUtil().setWidth(8), ScreenUtil().setHeight(3), 0, 0),
                                    child: Text(
                                      _mytimelist[0],
                                      style: TextStyle(
                                        color: Color(0xFF353535),
                                        fontSize: 14,),),
                                  )
                                ],
                              )
                          ),
                          Container(
                              margin: EdgeInsets.fromLTRB(ScreenUtil().setWidth(38), ScreenUtil().setHeight(4), 0, 0),
                              child: Row (
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text("금",
                                      style: TextStyle(
                                        color: Color(0xff6B6B6B),
                                        fontSize: 14,
                                      )),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(ScreenUtil().setWidth(8), ScreenUtil().setHeight(3), 0, 0),
                                    child: Text(
                                      _mytimelist[0],
                                      style: TextStyle(
                                        color: Color(0xFF353535),
                                        fontSize: 14,),),
                                  )
                                ],
                              )
                          ),
                          Container(
                              margin: EdgeInsets.fromLTRB(ScreenUtil().setWidth(38), ScreenUtil().setHeight(4), 0, 0),
                              child: Row (
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text("토",
                                      style: TextStyle(
                                        color: Color(0xff6B6B6B),
                                        fontSize: 14,
                                      )),
                                  Container(
                                    margin: EdgeInsets.only(left: ScreenUtil().setWidth(8)),
                                    child: Text(
                                      _mytimelist[0],
                                      style: TextStyle(
                                        color: Color(0xFF353535),
                                        fontSize: 14,),),
                                  )
                                ],
                              )
                          ),
                          Container(
                              margin: EdgeInsets.fromLTRB(ScreenUtil().setWidth(38), ScreenUtil().setHeight(4), 0, 0),
                              child: Row (
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text("일",
                                      style: TextStyle(
                                        color: Color(0xFF6B6B6B),
                                        fontSize: 14,
                                      )),
                                  Container(
                                    margin: EdgeInsets.only(left: ScreenUtil().setWidth(8)),
                                    child: Text(
                                      _mytimelist[0],
                                      style: TextStyle(
                                        color: Color(0xFF353535),
                                        fontSize: 14,),),
                                  )
                                ],
                              )
                          ),
                        ],
                      ),
                    )
                ),
                Container(
                    width: ScreenUtil().setWidth(360),
                    height: ScreenUtil().setHeight(60),
                    decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide (
                            color: Color(0xffe9e9e9),
                            width: 8.0,
                          ),
                        )
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            margin: EdgeInsets.only(left: ScreenUtil().setWidth(16)),
                            child: Image.asset('images/detail_icon_email.png')),
                        Container(
                          margin: EdgeInsets.only(left: ScreenUtil().setWidth(8)),
                          child: Text(_myemaillist[0],
                              style: TextStyle(
                                color: Color(0xFF353535),
                                fontSize: 14,
                              )),
                        )
                      ],
                    )
                ),
                Container(
                  width: ScreenUtil().setWidth(360),
                  decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide (
                          color: Color(0xffe9e9e9),
                          width: 1.0,
                        ),
                      )
                  ),
                  child: StreamBuilder<List<ReviewModel>>(
                      stream: streamReview(hospital), // streamReview(review),
                      builder: (context, asyncSnapshot) {
                        if(!asyncSnapshot.hasData) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.fromLTRB(ScreenUtil().setWidth(16), ScreenUtil().setHeight(24), 0, ScreenUtil().setHeight(7)),
                                child: Text("리뷰", style: TextStyle(
                                  color: Colors.black, fontSize: 14,)),
                              ),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Container(
                                  padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(16)),
                                  decoration: BoxDecoration(
                                    border: Border(bottom: BorderSide(
                                        color: Colors.grey,
                                        width: 1.0)),),
                                  child: Row(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(left: ScreenUtil().setWidth(16)),
                                        child: InkWell(
                                          child: Image.asset(hospital_1 ? 'images/detail_btn_1.png': 'images/detail_btn_1_on.png'),
                                          onTap: () => {

                                          },
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: ScreenUtil().setWidth(4)),
                                        child: InkWell(
                                          child: Image.asset(hospital_2 ? 'images/detail_btn_2_on.png': 'images/detail_btn_2.png'),
                                          onTap: () => {

                                          },
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: ScreenUtil().setWidth(4)),
                                        child: InkWell(
                                          child: Image.asset(hospital_3 ? 'images/detail_btn_3_on.png': 'images/detail_btn_3.png'),
                                          onTap: () => {

                                          },
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: ScreenUtil().setWidth(4)),
                                        child: InkWell(
                                          child: Image.asset(hospital_4 ? 'images/detail_btn_4_on.png': 'images/detail_btn_4.png'),
                                          onTap: () => {

                                          },
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: ScreenUtil().setWidth(4)),
                                        child: InkWell(
                                          child: Image.asset(hospital_5 ? 'images/detail_btn_5_on.png': 'images/detail_btn_5.png'),
                                          onTap: () => {

                                          },
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: ScreenUtil().setWidth(4)),
                                        child: InkWell(
                                          child: Image.asset(hospital_6 ? 'images/detail_btn_6_on.png': 'images/detail_btn_6.png'),
                                          onTap: () => {

                                          },
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: ScreenUtil().setWidth(4)),
                                        child: InkWell(
                                          child:Image.asset(hospital_7 ? 'images/detail_btn_7_on.png': 'images/detail_btn_7.png'),
                                          onTap: () => {

                                          },
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: ScreenUtil().setWidth(4)),
                                        child: InkWell(
                                          child: Image.asset(hospital_8 ? 'images/detail_btn_8_on.png': 'images/detail_btn_8.png'),
                                          onTap: () => {

                                          },
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: ScreenUtil().setWidth(4)),
                                        child: InkWell(
                                          child: Image.asset(hospital_9 ? 'images/detail_btn_9_on.png': 'images/detail_btn_9.png'),
                                          onTap: () => {

                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          );
                        } else if (asyncSnapshot.hasError){
                          return const Center(
                            child: Text('오류가 발생했습니다.'),);
                        } else {
                          List<ReviewModel> review = asyncSnapshot.data!;
                          return Column (
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.fromLTRB(ScreenUtil().setWidth(16), ScreenUtil().setHeight(24), 0, ScreenUtil().setHeight(7)),
                                child: Text("리뷰", style: TextStyle(
                                  color: Colors.black, fontSize: 14,)),
                              ),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Container(
                                  padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(16)),
                                  decoration: BoxDecoration(
                                    border: Border(bottom: BorderSide(
                                        color: Colors.grey,
                                        width: 1.0)),),
                                  child: Row(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(left: ScreenUtil().setWidth(16)),
                                        child: InkWell(
                                          child: Image.asset(hospital_1 ? 'images/detail_btn_1.png': 'images/detail_btn_1_on.png'),
                                          onTap: () => {
                                            setState((){
                                              hospital_subject = "내과";
                                              hospital = 1;
                                              hospital_1 = !hospital_1;
                                              hospital_2 == true ? (hospital_2 = !hospital_2) : '';
                                              hospital_3 == true ? (hospital_3 = !hospital_3) : '';
                                              hospital_4 == true ? (hospital_4 = !hospital_4) : '';
                                              hospital_5 == true ? (hospital_5 = !hospital_5) : '';
                                              hospital_6 == true ? (hospital_6 = !hospital_6) : '';
                                              hospital_7 == true ? (hospital_7 = !hospital_7) : '';
                                              hospital_8 == true ? (hospital_8 = !hospital_8) : '';
                                              hospital_9 == true ? (hospital_9 = !hospital_9) : '';
                                            }),
                                          },
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: ScreenUtil().setWidth(4)),
                                        child: InkWell(
                                          child: Image.asset(hospital_2 ? 'images/detail_btn_2_on.png': 'images/detail_btn_2.png'),
                                          onTap: () => {
                                            setState((){
                                              hospital = 2;
                                              hospital_subject = "산부인과";
                                              hospital_2 = !hospital_2;
                                              hospital_1 == false ? (hospital_1 = !hospital_1) : '';
                                              hospital_3 == true ? (hospital_3 = !hospital_3) : '';
                                              hospital_4 == true ? (hospital_4 = !hospital_4) : '';
                                              hospital_5 == true ? (hospital_5 = !hospital_5) : '';
                                              hospital_6 == true ? (hospital_6 = !hospital_6) : '';
                                              hospital_7 == true ? (hospital_7 = !hospital_7) : '';
                                              hospital_8 == true ? (hospital_8 = !hospital_8) : '';
                                              hospital_9 == true ? (hospital_9 = !hospital_9) : '';
                                            })
                                          },
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: ScreenUtil().setWidth(4)),
                                        child: InkWell(
                                          child: Image.asset(hospital_3 ? 'images/detail_btn_3_on.png': 'images/detail_btn_3.png'),
                                          onTap: () => {
                                            setState((){
                                              hospital = 3;
                                              hospital_subject = "치과";
                                              hospital_3 = !hospital_3;
                                              hospital_1 == false ? (hospital_1 = !hospital_1) : '';
                                              hospital_2 == true ? (hospital_2 = !hospital_2) : '';
                                              hospital_4 == true ? (hospital_4 = !hospital_4) : '';
                                              hospital_5 == true ? (hospital_5 = !hospital_5) : '';
                                              hospital_6 == true ? (hospital_6 = !hospital_6) : '';
                                              hospital_7 == true ? (hospital_7 = !hospital_7) : '';
                                              hospital_8 == true ? (hospital_8 = !hospital_8) : '';
                                              hospital_9 == true ? (hospital_9 = !hospital_9) : '';
                                            })
                                          },
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: ScreenUtil().setWidth(4)),
                                        child: InkWell(
                                          child: Image.asset(hospital_4 ? 'images/detail_btn_4_on.png': 'images/detail_btn_4.png'),
                                          onTap: () => {
                                            setState((){
                                              hospital = 4;
                                              hospital_subject = "정신과";
                                              hospital_4 = !hospital_4;
                                              hospital_1 == false ? (hospital_1 = !hospital_1) : '';
                                              hospital_2 == true ? (hospital_2 = !hospital_2) : '';
                                              hospital_3 == true ? (hospital_3 = !hospital_3) : '';
                                              hospital_5 == true ? (hospital_5 = !hospital_5) : '';
                                              hospital_6 == true ? (hospital_6 = !hospital_6) : '';
                                              hospital_7 == true ? (hospital_7 = !hospital_7) : '';
                                              hospital_8 == true ? (hospital_8 = !hospital_8) : '';
                                              hospital_9 == true ? (hospital_9 = !hospital_9) : '';
                                            })
                                          },
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: ScreenUtil().setWidth(4)),
                                        child: InkWell(
                                          child: Image.asset(hospital_5 ? 'images/detail_btn_5_on.png': 'images/detail_btn_5.png'),
                                          onTap: () => {
                                            setState((){
                                              hospital = 5;
                                              hospital_subject = "피부과";
                                              hospital_5 = !hospital_5;
                                              hospital_1 == false ? (hospital_1 = !hospital_1) : '';
                                              hospital_2 == true ? (hospital_2 = !hospital_2) : '';
                                              hospital_3 == true ? (hospital_3 = !hospital_3) : '';
                                              hospital_4 == true ? (hospital_4 = !hospital_4) : '';
                                              hospital_6 == true ? (hospital_6 = !hospital_6) : '';
                                              hospital_7 == true ? (hospital_7 = !hospital_7) : '';
                                              hospital_8 == true ? (hospital_8 = !hospital_8) : '';
                                              hospital_9 == true ? (hospital_9 = !hospital_9) : '';
                                            })
                                          },
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: ScreenUtil().setWidth(4)),
                                        child: InkWell(
                                          child: Image.asset(hospital_6 ? 'images/detail_btn_6_on.png': 'images/detail_btn_6.png'),
                                          onTap: () => {
                                            setState((){
                                              hospital = 6;
                                              hospital_subject = "안과";
                                              hospital_6 = !hospital_6;
                                              hospital_1 == false ? (hospital_1 = !hospital_1) : '';
                                              hospital_2 == true ? (hospital_2 = !hospital_2) : '';
                                              hospital_3 == true ? (hospital_3 = !hospital_3) : '';
                                              hospital_4 == true ? (hospital_4 = !hospital_4) : '';
                                              hospital_5 == true ? (hospital_5 = !hospital_5) : '';
                                              hospital_7 == true ? (hospital_7 = !hospital_7) : '';
                                              hospital_8 == true ? (hospital_8 = !hospital_8) : '';
                                              hospital_9 == true ? (hospital_9 = !hospital_9) : '';
                                            })
                                          },
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: ScreenUtil().setWidth(4)),
                                        child: InkWell(
                                          child:Image.asset(hospital_7 ? 'images/detail_btn_7_on.png': 'images/detail_btn_7.png'),
                                          onTap: () => {
                                            setState((){
                                              hospital = 7;
                                              hospital_subject = "정형외과";
                                              hospital_7 = !hospital_7;
                                              hospital_1 == false ? (hospital_1 = !hospital_1) : '';
                                              hospital_2 == true ? (hospital_2 = !hospital_2) : '';
                                              hospital_3 == true ? (hospital_3 = !hospital_3) : '';
                                              hospital_4 == true ? (hospital_4 = !hospital_4) : '';
                                              hospital_5 == true ? (hospital_5 = !hospital_5) : '';
                                              hospital_6 == true ? (hospital_6 = !hospital_6) : '';
                                              hospital_8 == true ? (hospital_8 = !hospital_8) : '';
                                              hospital_9 == true ? (hospital_9 = !hospital_9) : '';
                                            })
                                          },
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: ScreenUtil().setWidth(4)),
                                        child: InkWell(
                                          child: Image.asset(hospital_8 ? 'images/detail_btn_8_on.png': 'images/detail_btn_8.png'),
                                          onTap: () => {
                                            setState((){
                                              hospital = 8;
                                              hospital_subject = "이비인후과";
                                              hospital_8 = !hospital_8;
                                              hospital_1 == false ? (hospital_1 = !hospital_1) : '';
                                              hospital_2 == true ? (hospital_2 = !hospital_2) : '';
                                              hospital_3 == true ? (hospital_3 = !hospital_3) : '';
                                              hospital_4 == true ? (hospital_4 = !hospital_4) : '';
                                              hospital_5 == true ? (hospital_5 = !hospital_5) : '';
                                              hospital_6 == true ? (hospital_6 = !hospital_6) : '';
                                              hospital_7 == true ? (hospital_7 = !hospital_7) : '';
                                              hospital_9 == true ? (hospital_9 = !hospital_9) : '';
                                            }),
                                          },
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: ScreenUtil().setWidth(4)),
                                        child: InkWell(
                                          child: Image.asset(hospital_9 ? 'images/detail_btn_9_on.png': 'images/detail_btn_9.png'),
                                          onTap: () => {
                                            setState((){
                                              hospital = 9;
                                              hospital_subject = "기타";
                                              hospital_9 = !hospital_9;
                                              hospital_1 == false ? (hospital_1 = !hospital_1) : '';
                                              hospital_2 == true ? (hospital_2 = !hospital_2) : '';
                                              hospital_3 == true ? (hospital_3 = !hospital_3) : '';
                                              hospital_4 == true ? (hospital_4 = !hospital_4) : '';
                                              hospital_5 == true ? (hospital_5 = !hospital_5) : '';
                                              hospital_6 == true ? (hospital_6 = !hospital_6) : '';
                                              hospital_7 == true ? (hospital_7 = !hospital_7) : '';
                                              hospital_8 == true ? (hospital_8 = !hospital_8) : '';
                                            }),
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount: review.length,
                                itemBuilder: (context, index) {
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
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
                                              Text(review[index].content,
                                                  style: TextStyle( color: Color(0XFF353535), fontSize: 12,)),
                                              Container(
                                                margin: EdgeInsets.fromLTRB(ScreenUtil().setWidth(260), ScreenUtil().setHeight(10), ScreenUtil().setWidth(16), ScreenUtil().setHeight(0)),
                                                child: Text(review[index].date,
                                                    style: TextStyle( color: Color(0XFF6B6B6B), fontSize: 10,)),
                                              )
                                            ],
                                          )
                                      ),
                                    ],
                                  );
                                },
                              )
                            ],
                          );
                        }
                      }
                  ),
                ),
              ],
            ),
          )
      );
    }
  }

  Stream<List<ReviewModel>> streamReview(int hospital) {
    try{
      // print("id는 $hospital");
      var db = FirebaseFirestore.instance;
      db.settings = const Settings(persistenceEnabled: false);
      final Stream<QuerySnapshot> snapshots = db.collection('review')
          // .where("hospital_id", isEqualTo: hospital)
          .where("hospital_subject", isEqualTo: hospital_subject)
          .where("shelter_name", isEqualTo: _mynamelist[0])
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