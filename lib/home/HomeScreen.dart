import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:hexcolor/hexcolor.dart';
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
        Positioned(top:ScreenUtil().setHeight(388.0),
            child:_buildmiddle() )
      ],
    );
}

Widget _buildTop()
{
  return CarouselSlider(
    options: CarouselOptions(height: ScreenUtil().setHeight(524.0),
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
          child: Image(image: image, fit: BoxFit.fitHeight,),
        );
      }
    );
  }).toList(),
  );
}

Widget _buildmiddle(){
    return Column(
      children: [
        Text('김하마님.\n오늘도 건강한 하루 되세요!', textAlign: TextAlign.left,
          style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(20),
          fontWeight: FontWeight.bold,
          ),),
        SizedBox(
          height: ScreenUtil().setHeight(24.0),
        ),
        
        ElevatedButton(onPressed: (){
          //챗봇으로 연결
        },
            style: ElevatedButton.styleFrom(
              primary: HexColor('#E76D3B'),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0),
              ),
              minimumSize: Size(ScreenUtil().setWidth(328),ScreenUtil().setWidth(48)),
            ),

            child: Text(
              , textAlign: TextAlign.center,
              style: TextStyle(
              color: Colors.white, fontSize: ScreenUtil().setSp(14.0)
            ),
            ))
      ],
    );
}
}