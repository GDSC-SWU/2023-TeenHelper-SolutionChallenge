import 'package:mysql1/mysql1.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Mysql {
  static String host = dotenv.get('HOST'),
      user = dotenv.get('USER'),
      password = dotenv.get('PASSWORD'),
      db = dotenv.get('DB');
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
