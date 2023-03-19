import 'package:flutter_dotenv/flutter_dotenv.dart';
class GoogleMapServices{

  static Future<String> getAddFromLocation(double lat, double lng) async{
    const String baseUrl = 'https://maps/googleapis.com/maps/api/geocode/json';
    String url= '$baseUrl?latlng=$lat, $lng&key=${dotenv.get('API_KEY')}&language=ko';
    return url;
  }
}

