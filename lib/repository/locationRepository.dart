import 'package:locationapp/Models/locationModel.dart';
import 'package:locationapp/Utills/geocodingApi.dart';

class LocationRepository{
  Future<LocationModel> buildLocation(double lat,double lng)async{
    final addr = await GeocodingApi.getAddressFromLatLng(lat, lng);
    return LocationModel(
        latitude: lat,
        longitude: lng,
        city: addr["city"] ?? "N/A",
        state: addr["state"] ?? "N/A",
        postalCode: addr["postalCode"] ?? "N/A",
        timestamp: DateTime.now(),
    );
  }
}