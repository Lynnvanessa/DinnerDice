import "package:http/http.dart" as http;

class BaseRepo {
  final String MAPS_API_KEY = "AIzaSyDfu-g_FALey5pyI-9NvCk_49kTIAp0u6Q";
  final String _baseUrl =
      "https://maps.googleapis.com/maps/api/place/nearbysearch";

  Future<http.Response> get(String path) async {
    return http.get(Uri.parse("$_baseUrl/$path"));
  }
}
