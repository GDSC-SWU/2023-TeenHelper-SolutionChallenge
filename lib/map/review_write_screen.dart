import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google/map/detail_model.dart';
import 'package:intl/intl.dart';

class review_write_screen extends StatefulWidget {

  final String name;
  final int id;
  const review_write_screen(this.name, this.id);


  @override
  _review_write_screen createState() => _review_write_screen();
}

class _review_write_screen extends State<review_write_screen> {

  void showToast(String text)
  {
    Fluttertoast.showToast(
        msg: text,
        gravity: ToastGravity.CENTER,
        backgroundColor: Color(0xFFE76D3B),
        fontSize: ScreenUtil().setSp(16),
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT
    );
  }

  final _reviewTextEditController = TextEditingController();

  String getToday() {
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    var strToday = formatter.format(now);
    return strToday;
  }

  Future<void> reviewWrite(String content, String hospital, int hospitalId) async {
    await FirebaseFirestore.instance.collection("review").add({
      "uid": FirebaseAuth.instance.currentUser!.uid,
      "content": content,
      "hospital_subject": hospital,
      "hospital_id" : hospitalId,
      "shelter_id" : widget.id,
      "shelter_name" : widget.name,
      "date" : getToday(),
      "timeStamp" : Timestamp.now()
    });
    // Navigator.push(context, MaterialPageRoute(builder: (_) => map_detail()));
    Navigator.pop(context);
  }

  Future<void> mysqlReview(String shelter_name, int hospital_id) async{
      var db = Mysql();
      var conn = await db.getConnection();
      String sql = " update hospital set review_cnt = review_cnt+1 where shelter_name='${shelter_name}' and hospital_id = ${hospital_id};";
      final results = await conn.query(sql);
      results;
  }



  String hospital = "";
  int hospitalId = 0;
  bool hospital_1 = false;
  bool hospital_2 = false;
  bool hospital_3 = false;
  bool hospital_4 = false;
  bool hospital_5 = false;
  bool hospital_6 = false;
  bool hospital_7 = false;
  bool hospital_8 = false;
  bool hospital_9 = false;

  @override
  Widget build(BuildContext context) {
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
          title: Text(widget.name,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xff353535),
              fontSize: 16,
              fontFamily: "Spoqa Han Sans Neo",
              fontWeight: FontWeight.w500,),
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Column(
                    children: [
                      Container(
                          margin: EdgeInsets.fromLTRB(ScreenUtil().setWidth(16), ScreenUtil().setHeight(32), ScreenUtil().setWidth(90), 0),
                          child: Text('어떤 의료적 도움을 받으셨나요?',
                            style: TextStyle(fontSize: ScreenUtil().setSp(16), fontWeight: FontWeight.w600, color: Color(0xff353535)),
                          )
                      ),
                      Container(
                          margin: EdgeInsets.fromLTRB(ScreenUtil().setWidth(18), ScreenUtil().setHeight(4), ScreenUtil().setWidth(140), ScreenUtil().setHeight(16)),
                          child: Text('아래에서 한 가지만 선택해주세요.',
                            style: TextStyle(fontSize: ScreenUtil().setSp(12), fontWeight: FontWeight.w200, color: Color(0xff353535)),
                          )
                      ),
                      Column(
                        children: [
                          Container(
                            child: Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: ScreenUtil().setWidth(25)),
                                  child: InkWell(
                                    child: Image.asset(hospital_1 ? 'images/review_on_1.png': 'images/review_off_1.png'),
                                    onTap: () => {
                                      setState((){
                                        hospital = "내과";
                                        hospitalId = 1;
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
                                  margin: EdgeInsets.only(left: ScreenUtil().setWidth(11)),
                                  child: InkWell(
                                    child: Image.asset(hospital_2 ? 'images/review_on_2.png': 'images/review_off_2.png'),
                                    onTap: () => {
                                      setState((){
                                        hospital = "산부인과";
                                        hospitalId = 2;
                                        hospital_2 = !hospital_2;
                                        hospital_1 == true ? (hospital_1 = !hospital_1) : '';
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
                                  margin: EdgeInsets.only(left: ScreenUtil().setWidth(12)),
                                  child: InkWell(
                                    child: Image.asset(hospital_3 ? 'images/review_on_3.png': 'images/review_off_3.png'),
                                    onTap: () => {
                                      setState((){
                                        hospital = "치과";
                                        hospitalId = 3;
                                        hospital_3 = !hospital_3;
                                        hospital_1 == true ? (hospital_1 = !hospital_1) : '';
                                        hospital_2 == true ? (hospital_2 = !hospital_2) : '';
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
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: ScreenUtil().setHeight(6)),
                            child: Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: ScreenUtil().setWidth(25)),
                                  child: InkWell(
                                    child: Image.asset(hospital_4 ? 'images/review_on_4.png': 'images/review_off_4.png'),
                                    onTap: () => {
                                      setState((){
                                        hospital = "정신과";
                                        hospitalId = 4;
                                        hospital_4 = !hospital_4;
                                        hospital_2 == true ? (hospital_2 = !hospital_2) : '';
                                        hospital_3 == true ? (hospital_3 = !hospital_3) : '';
                                        hospital_1 == true ? (hospital_1 = !hospital_1) : '';
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
                                  margin: EdgeInsets.only(left: ScreenUtil().setWidth(12)),
                                  child: InkWell(
                                    child: Image.asset(hospital_5 ? 'images/review_on_5.png': 'images/review_off_5.png'),
                                    onTap: () => {
                                      setState((){
                                        hospital = "피부과";
                                        hospitalId = 5;
                                        hospital_5 = !hospital_5;
                                        hospital_1 == true ? (hospital_1 = !hospital_1) : '';
                                        hospital_3 == true ? (hospital_3 = !hospital_3) : '';
                                        hospital_4 == true ? (hospital_4 = !hospital_4) : '';
                                        hospital_2 == true ? (hospital_2 = !hospital_2) : '';
                                        hospital_6 == true ? (hospital_6 = !hospital_6) : '';
                                        hospital_7 == true ? (hospital_7 = !hospital_7) : '';
                                        hospital_8 == true ? (hospital_8 = !hospital_8) : '';
                                        hospital_9 == true ? (hospital_9 = !hospital_9) : '';
                                      }),
                                    },
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: ScreenUtil().setWidth(12)),
                                  child: InkWell(
                                    child: Image.asset(hospital_6 ? 'images/review_on_6.png': 'images/review_off_6.png'),
                                    onTap: () => {
                                      setState((){
                                        hospital = "안과";
                                        hospitalId = 6;
                                        hospital_6 = !hospital_6;
                                        hospital_1 == true ? (hospital_1 = !hospital_1) : '';
                                        hospital_2 == true ? (hospital_2 = !hospital_2) : '';
                                        hospital_4 == true ? (hospital_4 = !hospital_4) : '';
                                        hospital_5 == true ? (hospital_5 = !hospital_5) : '';
                                        hospital_3 == true ? (hospital_3 = !hospital_3) : '';
                                        hospital_7 == true ? (hospital_7 = !hospital_7) : '';
                                        hospital_8 == true ? (hospital_8 = !hospital_8) : '';
                                        hospital_9 == true ? (hospital_9 = !hospital_9) : '';
                                      }),
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: ScreenUtil().setHeight(6)),
                            child: Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: ScreenUtil().setWidth(25)),
                                  child: InkWell(
                                    child: Image.asset(hospital_7 ? 'images/review_on_7.png': 'images/review_off_7.png'),
                                    onTap: () => {
                                      setState((){
                                        hospital = "정형외과";
                                        hospitalId = 7;
                                        hospital_7 = !hospital_7;
                                        hospital_2 == true ? (hospital_2 = !hospital_2) : '';
                                        hospital_3 == true ? (hospital_3 = !hospital_3) : '';
                                        hospital_1 == true ? (hospital_1 = !hospital_1) : '';
                                        hospital_5 == true ? (hospital_5 = !hospital_5) : '';
                                        hospital_6 == true ? (hospital_6 = !hospital_6) : '';
                                        hospital_4 == true ? (hospital_4 = !hospital_4) : '';
                                        hospital_8 == true ? (hospital_8 = !hospital_8) : '';
                                        hospital_9 == true ? (hospital_9 = !hospital_9) : '';
                                      }),
                                    },
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: ScreenUtil().setWidth(6)),
                                  child: InkWell(
                                    child: Image.asset(hospital_8 ? 'images/review_on_8.png': 'images/review_off_8.png'),
                                    onTap: () => {
                                      setState((){
                                        hospital = "이비인후과";
                                        hospitalId = 8;
                                        hospital_8 = !hospital_8;
                                        hospital_1 == true ? (hospital_1 = !hospital_1) : '';
                                        hospital_3 == true ? (hospital_3 = !hospital_3) : '';
                                        hospital_4 == true ? (hospital_4 = !hospital_4) : '';
                                        hospital_2 == true ? (hospital_2 = !hospital_2) : '';
                                        hospital_6 == true ? (hospital_6 = !hospital_6) : '';
                                        hospital_7 == true ? (hospital_7 = !hospital_7) : '';
                                        hospital_5 == true ? (hospital_5 = !hospital_5) : '';
                                        hospital_9 == true ? (hospital_9 = !hospital_9) : '';
                                      }),
                                    },
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: ScreenUtil().setWidth(5)),
                                  child: InkWell(
                                    child: Image.asset(hospital_9 ? 'images/review_on_9.png': 'images/review_off_9.png'),
                                    onTap: () => {
                                      setState((){
                                        hospital = "안과";
                                        hospitalId = 9;
                                        hospital_9 = !hospital_9;
                                        hospital_1 == true ? (hospital_1 = !hospital_1) : '';
                                        hospital_2 == true ? (hospital_2 = !hospital_2) : '';
                                        hospital_4 == true ? (hospital_4 = !hospital_4) : '';
                                        hospital_5 == true ? (hospital_5 = !hospital_5) : '';
                                        hospital_3 == true ? (hospital_3 = !hospital_3) : '';
                                        hospital_7 == true ? (hospital_7 = !hospital_7) : '';
                                        hospital_8 == true ? (hospital_8 = !hospital_8) : '';
                                        hospital_6 == true ? (hospital_6 = !hospital_6) : '';
                                      }),
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                          margin: EdgeInsets.fromLTRB(ScreenUtil().setWidth(0), ScreenUtil().setHeight(48), ScreenUtil().setWidth(90), 0),
                          child: Text('구체적인 후기를 작성해주세요',
                            style: TextStyle(fontSize: ScreenUtil().setSp(16), fontWeight: FontWeight.w600, color: Color(0xff353535)),
                          )
                      ),
                      Container(
                          margin: EdgeInsets.fromLTRB(ScreenUtil().setWidth(5), ScreenUtil().setHeight(4), ScreenUtil().setWidth(75), ScreenUtil().setHeight(16)),
                          child: Text('작성한 후기는 삭제 및 수정이 불가능합니다.',
                            style: TextStyle(fontSize: ScreenUtil().setSp(12), fontWeight: FontWeight.w200, color: Color(0xff353535)),
                          )
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(ScreenUtil().setWidth(16), ScreenUtil().setHeight(24), ScreenUtil().setWidth(16), 0),
                  child: SizedBox(
                    height: ScreenUtil().setHeight(200),
                    width: ScreenUtil().setWidth(328),
                    child: TextField(
                      maxLines: null,
                      expands: true,
                      keyboardType: TextInputType.multiline,
                      controller: _reviewTextEditController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color(0xFFF3F3F3),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Color(0xFFF3F3F3))
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Color(0xFFF3F3F3))
                        ),
                        hintText: '여기에서 후기를 작성하세요.\n다른 사용자들이 후기를 볼 수 있으니,\n배려하는 마음을 담아 작성해주세요.',
                      ),
                    ),
                  ),
                ), // MediaQuery.of(context).viewInsets.bottom
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                      margin: EdgeInsets.fromLTRB(ScreenUtil().setWidth(16),ScreenUtil().setHeight(80),ScreenUtil().setWidth(16),ScreenUtil().setHeight(48)),
                      child: InkWell(
                        child: Image.asset('images/review_button.png'),
                        onTap: () => {
                          hospital.length > 0 && hospitalId > 0 ? mysqlReview(widget.name, hospitalId) : showToast("어떤 의료적 도움을 받았는지 선택해주세요."),
                          _reviewTextEditController.text.length > 0 ? "" : showToast("후기를 작성해주세요."),
                          hospital.length > 0 && _reviewTextEditController.text.length > 0 ? reviewWrite(_reviewTextEditController.text, hospital, hospitalId): ""
                        },
                      )
                  ),
                )
              ],
            ),
          ),
        ),
        );
  }

}