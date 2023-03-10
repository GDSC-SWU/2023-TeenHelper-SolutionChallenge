import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:geolocator/geolocator.dart';
//검색창 import
import 'package:permission_handler/permission_handler.dart';
import 'package:hexcolor/hexcolor.dart';
import 'dart:convert';
//데이터베이스 통신용 패키지
import 'AddressModel.dart';

//주소-> 위경도 값 변환 패키지
import 'package:geocoding/geocoding.dart';
//반응형 앱 코딩을 위해
import 'package:flutter_screenutil/flutter_screenutil.dart';


//<이 파일이 최종 파일임 여기에 각자 구현 기능들 추가>

class MapPractice extends StatefulWidget{
  const MapPractice({super.key});

  @override
  State<MapPractice> createState() => MapPracticeState();
}

class MapPracticeState extends State<MapPractice>{
  LatLng _center =const LatLng(37.382782, 127.1189054);
  //데베 속 주소 가져오는 리스트로 사용예정
  List<String> _myDataList=[];
  //태그 버튼 상태 변화용
  bool _buttonPressed1=false;
  bool _buttonPressed2=false;
  bool _buttonPressed3=false;
  bool _buttonPressed4=false;
  bool _buttonPressed5=false;
  final Completer<GoogleMapController> _controller = Completer();
  final MapType _googleMapType = MapType.normal;
  final Set<Marker> _markers= {};
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final CameraPosition _initialCameraPosition = const CameraPosition(
    target: LatLng(37.382782, 127.1189054),
    zoom:14,
  );


  _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
    loadandaddMarkers();
  }

  //db에서 데이터 불러와 마커 찍는 기능
  Future<void> loadandaddMarkers() async{
    final datalist = await getmySQLData();
    final mydatalist = datalist.map((data) => data.shelter_location).toList();
    setState(() {
      _myDataList = mydatalist;
    });
    for(String address in _myDataList){
     try{
       List<Location> locations = await locationFromAddress(address);
       if(locations.length>0){
         LatLng latLng = LatLng(locations[0].latitude, locations[0].longitude);
         BitmapDescriptor bitmapDescriptor = await BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(25,32)), 'images/map_icon_mark.png');
         Marker marker = Marker(
           markerId: MarkerId(address),
           position: latLng,
           //icon: bitmapDescriptor,
           infoWindow: InfoWindow(
             title: address,
           ),
         );
         setState(() {
           _markers.add(marker);
         });
       }
     } on TimeoutException catch (e){
       print('Timeoutexception:$e');
     }on SocketException catch (e){
       print('socketexception:$e');
     }catch(e){
       print(e);
     }
    }
  }

  //현재 위치 가져오기
  Future<void> _getCurrentLocation() async{
    final GoogleMapController mapController = await _controller.future;
    final Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _center = LatLng(position.latitude, position.longitude);
      mapController.animateCamera(
          CameraUpdate.newCameraPosition(CameraPosition(target: _center, zoom:15.0,),),);
    });

  }


  //지도 화면을 켰을때 초기화면
  @override
  void initState(){
    super.initState();
  }
  

//검색창 입력 내용 controller
  TextEditingController searchTextEditingController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
      body: Stack(
        children: <Widget>[
          //검색창 입력시 혹은 미입력시 여부에 따른 화면 호출
          //만약 입력시라면 검색창 만큼의 여백을 주고 화면 호출
          displayNoSearchResultScreen(),
          Padding( padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setSp(16),vertical: ScreenUtil().setSp(56)),
            child: Align(alignment: Alignment.topCenter,
              child: SizedBox(width: ScreenUtil().setWidth(328),height: ScreenUtil().setHeight(44),
                child: TextFormField(
                  controller: searchTextEditingController,
                  //검색창 내부 디자인
                  decoration: InputDecoration(
                    prefixIcon: Image.asset("images/map_icon_address.png", width:ScreenUtil().setWidth(10), height:ScreenUtil().setHeight(10)),
                    suffixIcon: IconButton(icon:Image.asset('images/map_icon_search.png',width:ScreenUtil().setWidth(18), height: ScreenUtil().setHeight(18)),
                      //search버튼 누를때 행동은 데베 연동 후 구현
                      onPressed: () {
                        //검색후 나오는 bottom drawer 구현
                      },),
                    hintText: '쉼터 지역 또는 진료 분야 검색',
                    hintStyle: TextStyle(color: HexColor('#BBBBBB'), fontSize: ScreenUtil().setSp(14)),
                    contentPadding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height*0.013),

                    //외곽 디자인 outline=모든면에 선이 존재
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      borderSide: BorderSide(color:Colors.white),
                    ),
                    //검색창 내부 색깔 집어넣기
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
            ),
          ),

        ],
      )
    );

  }

  //검색창 밑에 놓일 지도, 등등 widget들
  displayNoSearchResultScreen(){
    return Scaffold(
      body:Stack(
        children: <Widget> [
          GoogleMap(
            mapType: _googleMapType,
            initialCameraPosition: _initialCameraPosition,
            onMapCreated: _onMapCreated,
            myLocationEnabled: true,
            //기본제공 내위치 버튼
            myLocationButtonEnabled: false,
            //확대축소 기본제공 버튼
            zoomControlsEnabled: false,
            zoomGesturesEnabled: true,
            markers: _markers,
          ),
          //현재 위치 가져올수 있는 버튼
          Container(
            child: Positioned(bottom:ScreenUtil().setHeight(88), right:ScreenUtil().setHeight(16),//네비게이션바 크기만큼 bottom으로 지정할것
                child: FloatingActionButton(
                  child: Image.asset(
                    'images/location_current_icon.png',
                    width: ScreenUtil().setWidth(24),
                    height: ScreenUtil().setHeight(24),
                ),
                  backgroundColor: Colors.white,
                  onPressed: _getCurrentLocation,

                )),
          ),
          //검색창 밑 태그 버튼
              Container(
                        child: Padding( padding: EdgeInsets.only(top:ScreenUtil().setSp(110) , left: ScreenUtil().setSp(32)),//반응형으로 다시 수정padding: EdgeInsets.only(left:ScreenUtil().setSp(4.0)
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child:Row(
                              children: [
                                  ElevatedButton(
                                      onPressed: (){
                                        setState(() {
                                          _buttonPressed1 = !_buttonPressed1;
                                          //밑에 데이터 받아와서 뜨도록 함수 호출
                                        });
                                      },

                                      child: Text('전체',
                                        style:TextStyle(color:_buttonPressed1 ? Colors.white : Colors.black, fontSize: ScreenUtil().setSp(12)),
                                      ),
                                    style: ButtonStyle(
                                      backgroundColor: _buttonPressed1 ? MaterialStateProperty.all<Color>(HexColor('#E76D3B')) : MaterialStateProperty.all<Color>(Colors.white),
                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(26.0),
                                        )
                                      )
                                    ),

                                    ),
                                     Padding( padding: EdgeInsets.only(left:ScreenUtil().setSp(4.0)),
                                       child: ElevatedButton(
                                        onPressed: (){
                                          setState(() {
                                            _buttonPressed2 = !_buttonPressed2;
                                            //밑에 데이터 받아와서 뜨도록 함수 호출
                                          });
                                        },

                                        child: Text('내과 연계',
                                          style:TextStyle(color:_buttonPressed2 ? Colors.white : Colors.black, fontSize: ScreenUtil().setSp(12)),
                                        ),
                                        style: ButtonStyle(
                                            backgroundColor: _buttonPressed2 ? MaterialStateProperty.all<Color>(HexColor('#E76D3B')) : MaterialStateProperty.all<Color>(Colors.white),
                                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(26.0),
                                                )
                                            )
                                        ),

                                    ),
                                     ),
                                SizedBox( width: ScreenUtil().setWidth(4.0)),
                                ElevatedButton(
                                  onPressed: (){
                                    setState(() {
                                      _buttonPressed3 = !_buttonPressed3;
                                      //밑에 데이터 받아와서 뜨도록 함수 호출
                                    });
                                  },

                                  child: Text('산부인과 연계',
                                    style:TextStyle(color:_buttonPressed3 ? Colors.white : Colors.black, fontSize: ScreenUtil().setSp(12)),
                                  ),
                                  style: ButtonStyle(
                                      backgroundColor: _buttonPressed3 ? MaterialStateProperty.all<Color>(HexColor('#E76D3B')) : MaterialStateProperty.all<Color>(Colors.white),
                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(26.0),
                                          )
                                      )
                                  ),

                                ),
                                SizedBox( width: ScreenUtil().setWidth(4.0)),
                                ElevatedButton(
                                  onPressed: (){
                                    setState(() {
                                      _buttonPressed4 = !_buttonPressed4;
                                      //밑에 데이터 받아와서 뜨도록 함수 호출
                                    });

                                  },

                                  child: Text('치과 연계',
                                    style:TextStyle(color:_buttonPressed4 ? Colors.white : Colors.black, fontSize: ScreenUtil().setSp(12)),
                                  ),
                                  style: ButtonStyle(
                                      backgroundColor: _buttonPressed4 ? MaterialStateProperty.all<Color>(HexColor('#E76D3B')) : MaterialStateProperty.all<Color>(Colors.white),
                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(26.0),
                                          )
                                      )
                                  ),

                                ),
                                SizedBox( width: ScreenUtil().setWidth(4.0)),
                                ElevatedButton(
                                  onPressed: (){
                                    setState(() {
                                      _buttonPressed5 = !_buttonPressed5;
                                      //밑에 데이터 받아와서 뜨도록 함수 호출
                                    });

                                  },

                                  child: Text('정신과 연계',
                                    style:TextStyle(color:_buttonPressed5 ? Colors.white : Colors.black, fontSize: ScreenUtil().setSp(12)),
                                  ),
                                  style: ButtonStyle(
                                      backgroundColor: _buttonPressed5 ? MaterialStateProperty.all<Color>(HexColor('#E76D3B')) : MaterialStateProperty.all<Color>(Colors.white),
                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(26.0),
                                          )
                                      )
                                  ),

                                ),


                              ],
                            )
                          ),
                        ),


              ),


        ],
      )
    );
  }

  //위치 권한 접근 조정하는 기능
  void _permission() async{
    var requestStatus = await Permission.location.request();
    var status = await Permission.location.status;
    if(requestStatus.isGranted && status.isLimited){
      //제한적 동의를 한경우 중 요청에 동의하였을때
      print("isGranted");
      if(await Permission.locationWhenInUse.serviceStatus.isEnabled){
        //요청동의 + gps켜짐
        _getCurrentLocation;
      }else{
        //요청 동의 + gps 꺼짐
        print("serviceStatus IsDisabled");
      }
    }
    else if(requestStatus.isPermanentlyDenied || status.isPermanentlyDenied){
      //권한 요청 거부, 설정화면에서 변경해야할 경우, 다시묻지 않음 선택
      print("isPermanentlyDenied");
      openAppSettings();
    }else if(status.isRestricted){
      //권한 요청 거부, 해당 권한에 대해 요청을 표시하지 않도록 선택해 설정 화면에서 변경해야함
      print("isRestricted");
      openAppSettings();
    }else if(status.isDenied){
      //권한 요청 거절
      print("isDenied");
    }

  }


}