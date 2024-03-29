class EventModel {
  final String URL;
  final String timeStamp;
  final String title;
  final String Img;

  EventModel({
    this.URL = '',
    this.timeStamp = '',
    this.title = '',
    this.Img = '',
  });

  //서버로부터 map형태의 자료를 MessageModel형태의 자료로 변환해주는 역할을 수행함.
  factory EventModel.fromMap({required Map<String,dynamic> map}){
    return EventModel(
      URL: map['URL']??'',
      timeStamp: map['timeStamp']??'',
      title: map['title']??'',
      Img: map['Img']??'',
    );
  }

  Map<String,dynamic> toMap(){
    Map<String,dynamic> data = {};
    data['URL']= URL;
    data['timeStamp']= timeStamp;
    data['title']= title;
    data['Img']= Img;
    return data;
  }

}