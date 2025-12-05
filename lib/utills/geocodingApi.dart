import 'dart:convert';
import 'package:locationapp/Constants/appConstants.dart';
import 'package:http/http.dart' as http;

class GeocodingApi {
  static Future<Map<String, String>> getAddressFromLatLng(double lat, double lng) async {
    try {
      final url = Uri.parse("${AppConstants.geocodingUrl}?latlng=$lat,$lng&key=${AppConstants.googleApiKey}");
      final response = await http.get(url).timeout(Duration(seconds: 10));

      if (response.statusCode != 200) {
        print("Geocoding API Error: ${response.statusCode}");
        return getDefaultAddress("API Error: ${response.statusCode}");
      }

      final body = json.decode(response.body);

      if (body["status"] != "OK" || (body["results"] as List).isEmpty) {
        print("Geocoding API Status: ${body["status"]}");
        return getDefaultAddress("API Status: ${body["status"]}");
      }

      return parseAddressComponents(body["results"][0]["address_components"]);
    } catch (e) {
      print("Geocoding Exception: $e");
      return getDefaultAddress("Network Error");
    }
  }

  static Map<String, String> parseAddressComponents(List<dynamic> components) {
    String city = "";
    String state = "";
    String postalCode = "";

    for (final comp in components) {
      final types = (comp["types"] as List).cast<String>();

      if (types.contains("postal_code")) postalCode = comp["long_name"];
      if (types.contains("administrative_area_level_1")) state = comp["long_name"];
      if (types.contains("locality")) city = comp["long_name"];

      if (city.isEmpty && types.contains("administrative_area_level_2")) {
        city = comp["long_name"];
      }
      if (city.isEmpty && types.contains("sublocality")) {
        city = comp["long_name"];
      }
      if (city.isEmpty && types.contains("administrative_area_level_3")) {
        city = comp["long_name"];
      }
    }

    return {
      "city": city.isNotEmpty ? city : "Unknown City",
      "state": state.isNotEmpty ? state : "Unknown State",
      "postalCode": postalCode.isNotEmpty ? postalCode : "29111",
    };
  }

  static Map<String, String> getDefaultAddress(String error) {
    return {
      "city": "Service Unavailable",
      "state": "Error: $error",
      "postalCode": "29111",
    };
  }
}