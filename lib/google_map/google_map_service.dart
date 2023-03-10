
class GoogleMapServices{

  static Future<String> getAddFromLocation(double lat, double lng) async{
    final String baseUrl = 'https://maps/googleapis.com/maps/api/geocode/json';
    String url= '$baseUrl?latlng=$lat, $lng&key=AIzaSyCGOqBSN2pJYL99zLCAmxmS5-ck0kBAYGo&language=ko';
    return url;
  }
}

