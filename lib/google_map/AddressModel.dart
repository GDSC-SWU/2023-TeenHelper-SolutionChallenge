import 'mysql.dart';
class AddressModel{
  String shelter_name;
  String shelter_location;
  String shelter_id;
  String shelter_gender;
  String shelter_part;
  AddressModel({
    required this.shelter_name,
    required this.shelter_location,
    required this.shelter_gender,
    required this.shelter_id,
    required this.shelter_part,

  });
}

Future<List<AddressModel>> getmySQLData() async{

  var db = Mysql();
  String sql = 'select shelter_name, shelter_location,shelter_id, shelter_gender, shelter_part from shelter;';

  final List<AddressModel> mylist = [];
  await db.getConnection().then((conn) async{
    await conn.query(sql).then((results){
      for(var res in results){
        final AddressModel myuser = AddressModel(
          shelter_name: res['shelter_name'].toString(),
            shelter_location: res['shelter_location'].toString(),
            shelter_id: res['shelter_id'].toString(),
            shelter_gender: res['shelter_gender'].toString(),
            shelter_part: res['shelter_part'].toString(),
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

