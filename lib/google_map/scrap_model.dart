class ScrapModel {
  final bool scrap;
  final String uid;
  final String shelter_name;
  final int shelter_id;
  final String shelter_location;

  ScrapModel({
    this.scrap = false,
    this.uid = '',
    this.shelter_name = '',
    this.shelter_id = 0,
    this.shelter_location = ''
  });

  //서버로부터 map형태의 자료를 MessageModel형태의 자료로 변환해주는 역할을 수행함.
  factory ScrapModel.fromMap({required Map<String,dynamic> map}){
    return ScrapModel(
        scrap: map['scrap']??'',
        uid: map['uid']??'',
        shelter_name: map['shelter_name']??'',
        shelter_id: map['shelter_id']??'',
        shelter_location: map['shelter_location']
    );
  }

  Map<String,dynamic> toMap(){
    Map<String,dynamic> data = {};
    data['scrap']= scrap;
    data['uid']= uid;
    data['shelter_name'] = shelter_name;
    data['shelter_id'] = shelter_id;
    data['shelter_location'] = shelter_location;
    return data;
  }

}