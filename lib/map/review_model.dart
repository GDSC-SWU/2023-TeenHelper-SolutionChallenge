class ReviewModel {
  final String content;
  final String date;
  final String uid;
  final int hospital_id;
  final String shelter_name;
  final int shelter_id;

  ReviewModel({
    this.content = '',
    this.date = '',
    this.uid = '',
    this.hospital_id = 0,
    this.shelter_name = '',
    this.shelter_id = 0
  });

  //서버로부터 map형태의 자료를 MessageModel형태의 자료로 변환해주는 역할을 수행함.
  factory ReviewModel.fromMap({required Map<String,dynamic> map}){
    return ReviewModel(
      content: map['content']??'',
      date: map['date']??'',
      uid: map['uid']??'',
      hospital_id: map['hospital_id']??'',
      shelter_name: map['shelter_name']??'',
      shelter_id: map['shelter_id']??'',
    );
  }

  Map<String,dynamic> toMap(){
    Map<String,dynamic> data = {};
    data['content']= content;
    data['date']= date;
    data['uid']= uid;
    data['hospital_id'] = hospital_id;
    data['shelter_name'] = shelter_name;
    data['shelter_id'] = shelter_id;
    return data;
  }

}