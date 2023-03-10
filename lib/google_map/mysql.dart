import 'package:mysql1/mysql1.dart';


class Mysql {
  static String host = '34.64.143.145',
      user = 'root',
      password = 'root',
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
