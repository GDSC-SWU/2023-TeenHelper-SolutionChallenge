import 'package:mysql1/mysql1.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


class Mysql {
  static String host = '34.64.143.145',
      user = 'root',
      password = dotenv.env['pwd']!, // 'Pink0914!!',
      db = 'teenhelper1';
  static int port = 3306;

  Mysql();

  Future<MySqlConnection> getConnection() async{
    var settings = ConnectionSettings(
        host: host,
        port: port,
        user: user,
        password: password,
        db: db
    );
    //data반환하기 전에 연결할수 있도록하기위해
    return await MySqlConnection.connect(settings);
  }
}

class DetailModel{
  String shelter_name;
  String shelter_email;
  String shelter_phnum;
  String shelter_location;
  String shelter_type;
  int shelter_id;
  String shelter_gender;
  String shelter_time;

  DetailModel({
    required this.shelter_name,
    required this.shelter_email,
    required this.shelter_phnum,
    required this.shelter_location,
    required this.shelter_type,
    required this.shelter_id,
    required this.shelter_gender,
    required this.shelter_time,

  });
}

Future<List<DetailModel>> getmySQLDetailData(int id) async{

  var db = Mysql();
  String sql = 'select shelter_name,shelter_email, shelter_phnum, shelter_location, shelter_type, shelter_id, shelter_gender, shelter_time from shelter where shelter_id = '"$id"'';

  final List<DetailModel> mylist = [];
  await db.getConnection().then((conn) async{
    await conn.query(sql).then((results){
      for(var res in results){
        final DetailModel myuser = DetailModel(
          shelter_name: res['shelter_name'].toString(),
          shelter_email: res['shelter_email'].toString(),
          shelter_phnum: res['shelter_phnum'].toString(),
          shelter_location: res['shelter_location'].toString(),
          shelter_type: res['shelter_type'].toString(),
          shelter_id: res['shelter_id'].toInt(),
          shelter_gender: res['shelter_gender'].toString(),
          shelter_time: res['shelter_time'].toString()
        );

        mylist.add(myuser);
      }

    }).onError((error, stackTrace){
      print(error);
      return null;
    });
    conn.close();
  });
  return mylist;
}