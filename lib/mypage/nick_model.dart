class NickModel {
  final String nickname;

  NickModel({
    this.nickname = ''
  });

  //서버로부터 map형태의 자료를 MessageModel형태의 자료로 변환해주는 역할을 수행함.
  factory NickModel.fromMap({required Map<String,dynamic> map}){
    return NickModel(
      nickname: map['nickname']??'',
    );
  }

  Map<String,dynamic> toMap(){
    Map<String,dynamic> data = {};
    data['nickname']= nickname;
    return data;
  }

}