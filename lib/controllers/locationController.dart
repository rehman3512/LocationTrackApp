import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:locationapp/Models/locationModel.dart';
import 'package:locationapp/Repository/locationRepository.dart';
import 'package:locationapp/Services/locationService.dart';
import 'package:get_storage/get_storage.dart';

class LocationController extends GetxController {
  final LocationService service = LocationService();
  final LocationRepository locationRepo = LocationRepository();
  final GetStorage getStorage = GetStorage();

  var permissionStatus = "Checking permission...".obs;
  var isRefreshing = false.obs;
  var isServiceEnabled = false.obs;
  var currentLocation = Rxn<LocationModel>();
  var history = <LocationModel>[].obs;
  var isLoading = true.obs;
  var errorMessage = "".obs;

  static String storageKey = "location_history_v1";

  @override
  void onInit() {
    super.onInit();
    loadFromStorage();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkAndRequestPermission();
    });
  }

  loadFromStorage() {
    final raw = getStorage.read(storageKey);
    if (raw != null && raw is List) {
      try {
        history.clear();
        for (final item in raw) {
          history.add(LocationModel.fromJson(Map<String, dynamic>.from(item)));
        }
      } catch (e) {
        print("Load storage error: $e");
      }
    }
  }

  saveToStorage() async {
    try {
      final list = history.map((e) => e.tojson()).toList();
      await getStorage.write(storageKey, list);
    } catch (e) {
      print("Save error: $e");
    }
  }

  checkAndRequestPermission() async {
    isLoading.value = true;
    errorMessage.value = "";

    try {

      isServiceEnabled.value = await service.isLocationServiceEnabled();

      if (!isServiceEnabled.value) {
        errorMessage.value = " Please turn ON location services";
        permissionStatus.value = "Location Service is OFF";
        isLoading.value = false;
        update();
        return;
      }


      permissionStatus.value = "Asking for permission...";
      update();

      await Future.delayed(Duration(milliseconds: 500));

      final perm = await service.requestPermission();
      permissionStatus.value = getPermissionText(perm);
      update();


      if (perm == LocationPermission.always || perm == LocationPermission.whileInUse) {
        await fetchCurrentLocation();

        service.getPositionStream().listen(
              (pos) => handleNewPosition(pos),
          onError: (e) => print("Location stream error: $e"),
        );
      } else {
        errorMessage.value = "Location permission is required";
      }
    } catch (e) {
      errorMessage.value = "Failed: ${e.toString()}";
      print("Initialize error: $e");
    } finally {
      isLoading.value = false;
      update();
    }
  }


  requestPermissionManually() async {
    isLoading.value = true;
    permissionStatus.value = "Requesting permission...";
    update();

    try {
      final perm = await service.requestPermission();
      permissionStatus.value = getPermissionText(perm);

      if (perm == LocationPermission.always || perm == LocationPermission.whileInUse) {
        await fetchCurrentLocation();
        Get.rawSnackbar(
          message: " Permission granted!",
          backgroundColor: Colors.green,
        );
      } else {
        Get.rawSnackbar(
          message: " Permission denied",
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      errorMessage.value = "Permission request failed: $e";
      Get.rawSnackbar(
        message: "Failed to request permission",
        backgroundColor: Colors.orange,
      );
    } finally {
      isLoading.value = false;
      update();
    }
  }

  fetchCurrentLocation() async {
    try {
      final pos = await service.getCurrentPosition().timeout(
        Duration(seconds: 15),
        onTimeout: () {
          throw TimeoutException("Location fetch timed out");
        },
      );
      await handleNewPosition(pos);
    } on TimeoutException {
      errorMessage.value = "Location fetch timed out. Please try again.";
      rethrow;
    } catch (e) {
      errorMessage.value = "Failed to get location: $e";
      rethrow;
    }
  }

  handleNewPosition(Position pos) async {
    try {
      final lm = await locationRepo.buildLocation(pos.latitude, pos.longitude);
      currentLocation.value = lm;

      if (history.isEmpty ||
          history.first.latitude != lm.latitude ||
          history.first.longitude != lm.longitude) {
        history.insert(0, lm);

        if (history.length > 50) history.removeLast();
        await saveToStorage();
      }

      errorMessage.value = "";
      update();
    } catch (e) {
      print("Handle position error: $e");
      currentLocation.value = LocationModel(
        latitude: pos.latitude,
        longitude: pos.longitude,
        city: "Unknown",
        state: "Unknown",
        postalCode: "00000",
        timestamp: DateTime.now(),
      );
      update();
    }
  }

  refreshNow() async {
    if (isRefreshing.value) return;

    isRefreshing.value = true;
    try {
      final pos = await service.getCurrentPosition().timeout(
        Duration(seconds: 10),
      );
      await handleNewPosition(pos);

      Get.rawSnackbar(
        message: "Location updated",
        backgroundColor: Colors.green,
      );
    } catch (e) {
      Get.rawSnackbar(
        message: "Refresh failed: $e",
        backgroundColor: Colors.red,
      );
      rethrow;
    } finally {
      isRefreshing.value = false;
    }
  }

  String getPermissionText(LocationPermission permission) {
    switch (permission) {
      case LocationPermission.denied:
        return "Permission Denied";
      case LocationPermission.deniedForever:
        return "Permission Denied Forever";
      case LocationPermission.whileInUse:
        return "Allowed While Using App";
      case LocationPermission.always:
        return "Always Allowed";
      case LocationPermission.unableToDetermine:
        return "Unable to Determine";
      default:
        return "Unknown";
    }
  }


  retryInit() {
    checkAndRequestPermission();
  }

  Future<LocationPermission> checkPermissionStatus() async {
    return await Geolocator.checkPermission();
  }

  openAppSettings() async {
    try {
      await service.openAppSettings();
    } catch (e) {
      print("Open settings error: $e");

      Get.dialog(
        AlertDialog(
          title: Text("Open Settings"),
          content: Text("Please open app settings manually and enable location permission"),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: Text("OK"),
            ),
          ],
        ),
      );
    }
  }
}