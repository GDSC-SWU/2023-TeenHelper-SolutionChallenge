import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google/google_map/MapPractice.dart';
import 'package:google/home/HomeScreen.dart';
import 'package:google/map/map_screen.dart';
import 'package:google/mypage/mypage_screen.dart';
import "package:google/AIchatbot/chat_bot.dart";

class navigationbar_screen extends StatefulWidget {

  final int number;
  const navigationbar_screen(this.number);

  @override
  _navigationbar_screen createState() => _navigationbar_screen();
}

class _navigationbar_screen extends State<navigationbar_screen> {

  late int _selectedIndex = widget.number;

  static List<Widget> pages = <Widget>[
    HomeScreen(),
    // map_detail(),
    MapPractice(),
    //map_screen(),
    ChatBotScreen(),
    mypage_screen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          backgroundColor: Colors.white,
          selectedItemColor: Color(0xffE76D3B),
          unselectedItemColor: Color(0xffC3C3C3),
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: [
            BottomNavigationBarItem(
                label: 'home',
                icon: Image.asset('images/home_off.png',
                    width: ScreenUtil().setWidth(48),
                    height: ScreenUtil().setHeight(48)),
                activeIcon: Image.asset('images/home_on.png',
                    width: ScreenUtil().setWidth(48),
                    height: ScreenUtil().setHeight(48))),
            BottomNavigationBarItem(
                label: 'map',
                icon: Image.asset('images/map_off.png',
                    width: ScreenUtil().setWidth(48),
                    height: ScreenUtil().setHeight(48)),
                activeIcon: Image.asset('images/map_on.png',
                    width: ScreenUtil().setWidth(48),
                    height: ScreenUtil().setHeight(48))),
            BottomNavigationBarItem(
                label: 'chat',
                icon: Image.asset('images/chat_off.png',
                    width: ScreenUtil().setWidth(48),
                    height: ScreenUtil().setHeight(48)),
                activeIcon: Image.asset('images/chat_on.png',
                    width: ScreenUtil().setWidth(48),
                    height: ScreenUtil().setHeight(48))),
            BottomNavigationBarItem(
                label: 'mypage',
                icon: Image.asset('images/mypage_off.png',
                    width: ScreenUtil().setWidth(48),
                    height: ScreenUtil().setHeight(48)),
                activeIcon: Image.asset('images/mypage_on.png',
                    width: ScreenUtil().setWidth(48),
                    height: ScreenUtil().setHeight(48))),
          ],
        ));
  }
}
