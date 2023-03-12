class ReviewModel {
  final String content;
  final String date;

  ReviewModel({
    this.content = '',
    this.date = ''
  });

  //서버로부터 map형태의 자료를 MessageModel형태의 자료로 변환해주는 역할을 수행함.
  factory ReviewModel.fromMap({required Map<String,dynamic> map}){
    return ReviewModel(
      content: map['content']??'',
      date: map['date']??'',
    );
  }

  Map<String,dynamic> toMap(){
    Map<String,dynamic> data = {};
    data['content']= content;
    data['date']= date;
    return data;
  }

}