import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google/google_map/scrap_model.dart';
import 'package:google/map/map_detail.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:geolocator/geolocator.dart';
//검색창 import
import 'package:permission_handler/permission_handler.dart';
import 'package:hexcolor/hexcolor.dart';
//데이터베이스 통신용 패키지
import 'AddressModel.dart';
//주소-> 위경도 값 변환 패키지
import 'package:geocoding/geocoding.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'mysql.dart';

class MapPractice extends StatefulWidget{
  const MapPractice({super.key});

  @override
  State<MapPractice> createState() => MapPracticeState();
}

class MapPracticeState extends State<MapPractice>{
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
  LatLng _center =const LatLng(37.382782, 127.1189054);
  //데베 속 주소 가져오는 리스트로 사용예정(마커찍기용)
  List<String> _myDataList=[];
  //db속 지역구 리스트로 가져온다
  List<String> _suggestions=[];
  //태그 버튼 상태 변화용
  final Completer<GoogleMapController> _controller = Completer();
  final MapType _googleMapType = MapType.normal;
  final Set<Marker> _markers= {};
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final CameraPosition _initialCameraPosition = const CameraPosition(
    target: LatLng(37.382782, 127.1189054),
    zoom:14,
  );
  //검색창 입력 내용 controller
  TextEditingController  _searchController = TextEditingController();
  final _scrollController = ScrollController();
  bool _isFocused = false;
  final FocusNode _focusNode=FocusNode();
  String searchingword='';
  List<String> _locations = [];
  List<String> _names = [];
  List<int> _shelterId = [];
  int id=0;
  List<String> _searchHistory=[];
  List<String> review_num=[];
  List<String> review_hospital=[];
  List<Widget> reviewButtons=[];
  bool _isDraggableSheetVisible = false;
  bool _islistex = false;

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


  _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
    loadandaddMarkers();
  }

  Future<BitmapDescriptor> _loadCustomMarkerImage() async{
    final ImageConfiguration config = ImageConfiguration(size:Size(ScreenUtil().setWidth(32.0),ScreenUtil().setHeight(32.0)));
    final bitmap = await BitmapDescriptor.fromAssetImage(config, 'images/map_icon_mark.png');
    return bitmap;
  }

  void addCustomIcon(){
    BitmapDescriptor.fromAssetImage(const ImageConfiguration(), "images/map_icon_mark.png")
        .then(
            (icon){
          setState(() {
            markerIcon = icon;
          });
        }
    );
  }

  //db에서 데이터 불러와 마커 찍는 기능
  Future<void> loadandaddMarkers() async{
    final datalist = await getmySQLData();
    final mydatalist = datalist.map((data) => data.shelter_location).toList();
    setState(() {
      _myDataList = mydatalist;
    });
    final shelterids = datalist.map((data) => data.shelter_id).toList();
    for(int i=0; i<_myDataList.length; i++){
      final address = _myDataList[i];
      int shelterid = int.parse(shelterids[i]);
      try{
        List<Location> locations = await locationFromAddress(address);
        if(locations.isNotEmpty){
          LatLng latLng = LatLng(locations[0].latitude, locations[0].longitude);
          Marker marker = Marker(
            markerId: MarkerId(address),
            position: latLng,
            icon:markerIcon,
            onTap: (){
              Navigator.push(
                context, MaterialPageRoute(builder: (context) => map_detail(shelterid))
              );
            }
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
  //db에서 suggestion리스트(지역구)들 가져오기용
  Future<void> loadpart() async{
    var db = Mysql();
    String sql = 'select distinct shelter_part from shelter;';
    var conn = await db.getConnection();
    final partlist = await conn.query(sql);
    final parts = partlist.map((row) => row[0] as String).toList();
    setState(() {
      _suggestions = parts;
    });
  }//_suggestions에 지역구 데이터 저장 완료

  Future<void> searchingname() async{//검색창에 입력한 값 db에서 검색
    if(searchingword !=null && searchingword.isNotEmpty){
      var db = Mysql();
      var conn = await db.getConnection();
      String sql1 = "select shelter_name, shelter_location, shelter_id from shelter where shelter_location like '%${searchingword}%';";
      String sql2 = "select distinct shelter_name from hospital;";
      final results = await conn.query(sql1);
      final namelists = results.map((row) => row[0] as String).toList();
      final loclists = results.map((row) => row[1] as String).toList();
      final idlists = results.map((row) => row[2] as int).toList();
      setState(() {
        _isDraggableSheetVisible = true;
        _names = namelists;
        _locations = loclists;
        _shelterId = idlists;
      });
      final results1 = await conn.query(sql2);
      final allList = results1.map((row) => row[0] as String).toList();//원본리스트
      bool hascommon = _names.any((element) => allList.contains(element));
      if(hascommon){
        for(int i=0; i<_names.length; i++) {
          String sql3 = "select s.shelter_name, s.shelter_location, s.shelter_id, h.hospital_subject, h.review_cnt, h.shelter_name from shelter s, hospital h where s.shelter_name='${_names[i]}' and s.shelter_name = h.shelter_name order by h.review_cnt desc;";
          final results2 = await conn.query(sql3);

          final numbersList = results2.map((row) => row[4].toString() as String)
              .toList();
          final hospitalsList = results2.map((row) => row[3].toString() as String)
              .toList();
          review_num.addAll(numbersList);
          review_hospital.addAll(hospitalsList);
        }
      }
      else{
        review_num = [];
        review_hospital=[];
      }
    }
  }

  Future<void> searchingtag() async{//태그 정보를 db에서 조회 리스트 저장
    if(id!=null && id !=0){
      var db = Mysql();
      String sql1 = "select shelter_name, shelter_location, shelter_id from hospital where hospital_id=${id};";
      String sql2 = "select distinct shelter_name from hospital;";
      var conn = await db.getConnection();
      final results1 = await conn.query(sql1);
      final tagnames = results1.map((row) => row[0] as String).toList();
      final taglocs=results1.map((row) => row[1] as String).toList();
      final tagid = results1.map((row) => row[2] as int).toList();
      setState(() {
        _names = tagnames;
        _locations = taglocs;
        _shelterId = tagid;
      });
      final sql2_result = await conn.query(sql2);
      final allList = sql2_result.map((row) => row[0] as String).toList();
      bool hascommon = _names.any((element) => allList.contains(element));
      if(hascommon){
      for(int i=0; i<_names.length; i++) {
      String sql3 = "select s.shelter_name, s.shelter_location, s.shelter_id, h.hospital_subject, h.review_cnt, h.shelter_name from shelter s, hospital h where s.shelter_name='${_names[i]}' and s.shelter_name = h.shelter_name order by h.review_cnt desc;";
      final sql3_results = await conn.query(sql3);
      final numbersList = sql3_results.map((row) => row[4].toString() as String)
          .toList();
      final hospitalsList = sql3_results.map((row) => row[3].toString() as String)
          .toList();
      review_num.addAll(numbersList);
      review_hospital.addAll(hospitalsList);
      }
      }
    }
    else if(id==0){
      var db = Mysql();
      String sql = "select shelter_name, shelter_location, shelter_id from shelter;";
      var conn = await db.getConnection();
      final results = await conn.query(sql);
      final tagnames = results.map((row) => row[0] as String).toList();
      final taglocs=results.map((row) => row[1] as String).toList();
      final tagid = results.map((row) => row[2] as int).toList();
      setState(() {
        _names = tagnames;
        _locations = taglocs;
        _shelterId = tagid;
      });
      review_num = [];
      review_hospital=[];
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
    addCustomIcon();
    super.initState();
    _loadData();
    loadpart();
    _focusNode.addListener(() {setState(() {
      _isFocused = _focusNode.hasFocus;
    });});

  }
  Future<void> _loadData() async{
    await searchingname();
  }

  //구글맵 위젯---------------------
  Widget googlemap(){
    return GoogleMap(
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
      );
  }

  //검색창 위젯--------------
  Widget searchingbar() {
    return Container(
      child: Column(
        children: [
          GestureDetector(
            onTap: _isFocused ? null : () => _searchController.clear(),
            child: Container(),
          ),

          Container(decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: HexColor('#0000000D'),
                  blurRadius: 4,
                  spreadRadius: 2,
                  offset: Offset(0,0),
                )
              ]

          ),
            width: ScreenUtil().setWidth(328),
            height: ScreenUtil().setHeight(44),
            child: TypeAheadField(
              textFieldConfiguration: TextFieldConfiguration(
                controller: _searchController,
                focusNode: _focusNode,
                decoration: InputDecoration(
                  prefixIcon: _isFocused ? IconButton(
                      onPressed: (){//_searchController.clear();
                        setState(() {
                          _searchController.clear();
                          searchingword="";
                        });}, icon: Image.asset("images/back_Key.png", width: ScreenUtil().setWidth(24.0), height: ScreenUtil().setHeight(24.0)))
                      :IconButton(onPressed: (){}, icon: Image.asset("images/map_icon_address.png", width: ScreenUtil().setWidth(16.0), height: ScreenUtil().setHeight(16.0))),
                  hintText: '쉼터 지역 또는 진료 분야 검색',
                  hintStyle: TextStyle(color: HexColor('#BBBBBB'), fontSize: ScreenUtil().setSp(14)),
                  contentPadding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height*0.013),
                  suffixIcon: IconButton(onPressed: () {
                    setState(() {
                      _names.clear();
                      _locations.clear();
                      _shelterId.clear();
                      searchingword= _searchController.text;
                      //최근 검색어 리스트에 저장하기 위함
                      if(!_searchHistory.contains(searchingword)){
                        _searchHistory.add(searchingword);
                      }
                    });
                    searchingname();
                  }, icon:Image.asset('images/map_icon_search.png',width:ScreenUtil().setWidth(18), height: ScreenUtil().setHeight(18)),
                  ),
                  //외곽 디자인 outline=모든면에 선이 존재
                  enabledBorder:  OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide(color:Colors.white),

                  ),

                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide(color:Colors.white),
                  ),
                  //검색창 내부 색깔 집어넣기
                  filled: true,
                  fillColor: Colors.white,
                ),


              ),
              suggestionsCallback: (pattern) async {
                if(pattern.isEmpty){
                  return _searchHistory;
                }
                else{
                  return _getSuggestions(pattern);
                }
              },
              itemBuilder: (context, suggestion) {
                return ListTile(
                  shape: Border(
                    bottom: BorderSide(color: HexColor('#E9E9E9'),width: 1.0,),
                  ),
                  leading: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 4, 16),
                    child: Image.asset('images/map_search_local.png',width: ScreenUtil().setWidth(16.0),height: ScreenUtil().setHeight(16.0)),
                  ),
                  title: Text(suggestion,
                    style: TextStyle(color: HexColor('#353535'),fontSize: ScreenUtil().setSp(14.0)),),
                  trailing: (_searchController.text.isEmpty) ? IconButton(onPressed: (){
                    setState(() {
                      _searchHistory.remove(suggestion);
                    });
                  },
                    icon: Image.asset('images/map_search_delete.png', width: ScreenUtil().setWidth(16.0),height: ScreenUtil().setHeight(16.0),),) :null ,
                );

              },
              onSuggestionSelected: (suggestion) {
                setState(() {
                  _names.clear();
                  _locations.clear();
                  _shelterId.clear();
                  _searchController.text = suggestion;
                  searchingword= _searchController.text;
                  if(!_searchHistory.contains(searchingword)){
                    _searchHistory.add(searchingword);
                  }
                });
                searchingname();
              },
              suggestionsBoxDecoration:  SuggestionsBoxDecoration(
                color:HexColor('#F3F3F3'),
              ),
            ),
          ),

        ],
      ),

    );

  }
  Future<List<String>> _getSuggestions(String query) async{
    List<String> matches = [];
    for(var suggestion in _suggestions){
      if(suggestion.contains(query)){
        matches.add(suggestion);
      }
    }
    return matches;
  }

  List<bool> _isSelected = List.generate(9,(index) => false);
  List<String> buttonlist = ['전체', '내과 연계', '산부인과 연계','치과 연계', '정신과 연계', '피부과 연계', '안과 연계', '이비인후과 연계', '기타 연계' ];
  List<Widget> _buildButtons(){
    return List.generate(buttonlist.length, (index) =>
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(decoration: BoxDecoration(
              boxShadow:[
                BoxShadow(
                  color: HexColor('#00000040'),
                  blurRadius:4,
                )
              ]
          ),
            child: ElevatedButton(onPressed: (){
              setState(() {
                _isDraggableSheetVisible = true;
                for(int i=0; i<_isSelected.length; i++){
                  _isSelected[i] = (i == index);
                }
                _names.clear();
                _locations.clear();
                _shelterId.clear();
                id=index;
              });
              searchingtag();
            },
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
                  primary: _isSelected[index] ? HexColor('#E76D3B') : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(26.0),
                  )
              ),
              child: Text("${buttonlist[index]}", style: TextStyle(
                color: _isSelected[index] ? Colors.white : Colors.black,
                fontSize: ScreenUtil().setSp(12),
              ),),
            ),
          ),

        ));
  }

  // 파이어베이스 스크랩

  Stream<List<ScrapModel>> streamScrap(String shelter_name) {
    try{
      // print("id는 $hospital");
      var db = FirebaseFirestore.instance;
      db.settings = const Settings(persistenceEnabled: false);
      final Stream<QuerySnapshot> snapshots = db.collection('scrap')
          .where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid.toString())
          .where("shelter_name", isEqualTo: shelter_name).snapshots();
      return snapshots.map((querySnapshot){
        List<ScrapModel> scrap = [];//querySnapshot을 message로 옮기기 위해 List<MessageModel> 선언
        querySnapshot.docs.forEach((element) { //해당 컬렉션에 존재하는 모든 docs를 순회하며 messages 에 데이터를 추가한다.
          scrap.add(
              ScrapModel.fromMap(
                  map:element.data() as Map<String, dynamic>
              )
          );
        });
        print("scrap 길이는 ${scrap.length}");
        return scrap; //QuerySnapshot에서 List<MessageModel> 로 변경이 됐으니 반환
      });
    } catch(ex){
      log('error)',error: ex.toString(),stackTrace: StackTrace.current);
      return Stream.error(ex.toString());
    }
  }

  Future<void> scrapEdit(bool scrap, int shelter_id) async {
    await FirebaseFirestore.instance.collection("scrap").doc(FirebaseAuth.instance.currentUser!.uid + shelter_id.toString()).update(
        {
          "scrap": scrap,
        });
  }

  Future<void> scrapWrite(bool scrap, String shelter_name, int shelter_id, String shelter_location) async {
    await FirebaseFirestore.instance.collection("scrap").doc(FirebaseAuth.instance.currentUser!.uid + shelter_id.toString()).set({
      "uid": FirebaseAuth.instance.currentUser!.uid,
      "shelter_id" : shelter_id,
      "shelter_name" : shelter_name,
      "scrap": scrap,
      "shelter_location" : shelter_location,
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    ScreenUtil.init(context);
    return Scaffold(
        body: Stack(
          children: [
            //밑에 깔리는 지도화면
            googlemap(),
            //검색창 기능들 구현
            Positioned(top: ScreenUtil().setHeight(56.0), left: ScreenUtil().setWidth(16.0),
                child: searchingbar()),

            //태그 버튼들
            Positioned(top: ScreenUtil().setHeight(116.0), left: ScreenUtil().setWidth(32.0),
              child: Container( width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView( scrollDirection: Axis.horizontal,
                  child: Row(
                      children:[
                        Row(
                          children:  _buildButtons(),
                        ),
                        SizedBox(
                          width: 30,
                        )
                      ]
                  ),
                ),
              ),
            ),


            Container(//내위치 가져오는 floating button
              child: Positioned(bottom:ScreenUtil().setHeight(16), right:ScreenUtil().setHeight(16),//네비게이션바 크기만큼 bottom으로 지정할것
                child: Container(decoration: BoxDecoration(
                    boxShadow:[
                      BoxShadow(color: HexColor('#00000033'),
                        blurRadius:4,
                      )
                    ]
                ),
                  child: FloatingActionButton(
                    backgroundColor: Colors.white,
                    onPressed: _getCurrentLocation,
                    child: Image.asset(
                      'images/location_current_icon.png',
                      width: ScreenUtil().setWidth(24),
                      height: ScreenUtil().setHeight(24),
                    ),
                  ),
                ),
              ),
            ),
            //drawer
              Visibility(visible: _isDraggableSheetVisible ,
                child: DraggableScrollableSheet(
                  initialChildSize: 0.39,
                  minChildSize: 0.39,
                  maxChildSize: 0.7,
                  builder:(BuildContext context, ScrollController myScrollController){
                    return ClipRRect(
                      borderRadius: const BorderRadius.vertical(top:Radius.circular(20.0)),
                      child:GestureDetector(
                        onTap: (){
                          setState(() {
                            _isDraggableSheetVisible = false;
                          });
                        },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                            child: Padding( padding:const EdgeInsets.only(top:30.0),

                              child: _names.isNotEmpty ? ListView.builder(
                                controller: myScrollController,
                                itemCount: _names.length,
                                itemBuilder: (BuildContext context , int index){
                                  return Container(decoration: BoxDecoration(
                                    border: Border.all(color: HexColor('#E9E9E9'),)
                                  ),
                                    child:ListTile(
                                      horizontalTitleGap: 16,
                                      minVerticalPadding: 20,
                                      shape: Border(bottom: BorderSide(color: HexColor('#E9E9E9'), width: 1.0)),
                                      title:Text(_names[index],textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontSize: ScreenUtil().setSp(16.0),
                                        ),),
                                      subtitle: Padding(
                                        padding: const EdgeInsets.only(top:4.0),
                                        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                          children:[
                                            Text(_locations[index],textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  fontSize: ScreenUtil().setSp(12.0)
                                              ),),
                                            SizedBox(height: 8.0,),
                                            Container(
                                              child: Row(
                                                children:[
                                                  if(index*3 <review_hospital.length && int.parse(review_num[index*3]) != 0)
                                                    SizedBox(height:ScreenUtil().setHeight(28.0),
                                                      child: Material(
                                                        borderRadius: BorderRadius.circular(14.0),
                                                        color: HexColor('#E9E9E9'),
                                                        child: TextButton(
                                                          onPressed: null,
                                                          child:Text('${review_hospital[index*3]}연계 ${review_num[index*3]}',
                                                          style: TextStyle(color:Colors.black, fontSize: ScreenUtil().setSp(10.0)),)
                                                        ),
                                                      ),
                                                    ),
                                                  SizedBox(
                                                    width: ScreenUtil().setWidth(4.0),
                                                  ),
                                                  if ((index * 3) + 1 < review_hospital.length && int.parse(review_num[(index*3)+1]) != 0)
                                                    SizedBox(height:ScreenUtil().setHeight(28.0),
                                                      child: Material(
                                                        borderRadius: BorderRadius.circular(14.0),
                                                        color: HexColor('#E9E9E9'),
                                                        child: TextButton(
                                                            onPressed: null,
                                                            child:Text('${review_hospital[(index*3)+1]}연계 ${review_num[(index*3)+1]}',
                                                              style: TextStyle(color:Colors.black, fontSize: ScreenUtil().setSp(10.0)),)
                                                        ),
                                                      ),
                                                    ),
                                                  SizedBox(
                                                    width: ScreenUtil().setWidth(4.0),
                                                  ),
                                                  if ((index * 3) + 2 < review_hospital.length && int.parse(review_num[(index*3)+2]) != 0)
                                                    SizedBox(height:ScreenUtil().setHeight(28.0),
                                                      child: Material(
                                                        borderRadius: BorderRadius.circular(14.0),
                                                        color: HexColor('#E9E9E9'),
                                                        child: TextButton(
                                                            onPressed: null,
                                                            child:Text('${review_hospital[(index*3)+2]}연계 ${review_num[(index*3)+2]}',
                                                              style: TextStyle(color:Colors.black, fontSize: ScreenUtil().setSp(10.0)),)
                                                        ),
                                                      ),
                                                    ),
                                                ]
                                              ),
                                            )
                                            //Row(children: rowChildren,),
                                          ],
                                        ),
                                      ),
                                      trailing:  StreamBuilder<List<ScrapModel>>(
                                          stream: streamScrap(_names[index]),
                                          builder: (context, asyncSnapshot) {
                                            if(asyncSnapshot.hasData && asyncSnapshot.data!.isNotEmpty) {
                                              List<ScrapModel> scrap = asyncSnapshot.data!;
                                              return InkWell(
                                                  child: Image.asset(scrap[0].scrap == true ? 'images/staron_btn.png' : 'images/staroff_btn.png'),
                                                  onTap: () => {
                                                    scrapEdit(!scrap[0].scrap, _shelterId[index])
                                                  }
                                              );
                                            } else if (asyncSnapshot.hasError) {
                                              return const Center(
                                                child: Text('오류가 발생했습니다.'),);
                                            } else {
                                              return InkWell(
                                                child: Image.asset('images/staroff_btn.png'),
                                                onTap: () => {
                                                  scrapWrite(true, _names[index], _shelterId[index], _locations[index]),
                                                },
                                              );
                                            }
                                          }
                                      ),
                                      onTap: (){
                                        Navigator.push(
                                            context, MaterialPageRoute(builder: (_) =>map_detail(_shelterId[index])));
                                        //상세페이지로 넘어가도록 명시
                                      },
                                    )
                                  );
                                },) : Center(
                                  child:Text('아직 정보가 없습니다')
                              )
                            ),


                      ),
                      ));
                  },),

              ),

          ],
        )
    );

  }

}