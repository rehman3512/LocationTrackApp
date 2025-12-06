import 'package:geolocator/geolocator.dart';

class LocationService {


  Future<LocationPermission> requestPermission() async {
    try {

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      return permission;

    } catch (e) {
      print("Permission error: $e");
      return LocationPermission.denied;
    }
  }

  Future<bool> isLocationServiceEnabled() async {
    try {
      return await Geolocator.isLocationServiceEnabled();
    } catch (e) {
      print("Service check error: $e");
      return false;
    }
  }

  Future<Position> getCurrentPosition({
    Duration? timeLimit,
  }) async {
    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: timeLimit ?? Duration(seconds: 10),
      );
    } catch (e) {
      print("Get position error: $e");
      rethrow;
    }
  }

  Stream<Position> getPositionStream() {
    return Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 10,
      ),
    ).handleError((error) {
      print("Position stream error: $error");
    });
  }


  Future<void> openAppSettings() async {
    try {
      await Geolocator.openAppSettings();
    } catch (e) {
      print("Open app settings error: $e");

      throw Exception("Cannot open settings: $e");
    }
  }


  Future<void> openLocationSettings() async {
    try {
      await Geolocator.openLocationSettings();
    } catch (e) {
      print("Open location settings error: $e");
      throw Exception("Cannot open location settings: $e");
    }
  }
}