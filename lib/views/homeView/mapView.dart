import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:locationapp/Models/locationModel.dart';
import 'package:locationapp/controllers/locationController.dart';
import 'package:locationapp/widgets/mapWidgets/historyCounter.dart';
import 'package:locationapp/widgets/mapWidgets/mapAppbar.dart';
import 'package:locationapp/widgets/mapWidgets/mapBottomCard.dart';
import 'package:locationapp/widgets/mapWidgets/mapContainer.dart';
import 'package:locationapp/widgets/mapWidgets/mapControls.dart';
import 'package:locationapp/widgets/mapWidgets/noLocationView.dart';

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<MapView> createState() => MapViewState();
}

class MapViewState extends State<MapView> {
  GoogleMapController? mapController;
  final locationController = Get.find<LocationController>();
  BitmapDescriptor? customMarkerIcon;
  bool showHistoryPath = true;
  double mapZoom = 15.0;

  @override
  void initState() {
    super.initState();
    loadCustomMarker();
  }

  Future<void> loadCustomMarker() async {
    customMarkerIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(48, 48)),
      'assets/location_pin.png',
    );
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
    animateToLocation();
  }

  void animateToLocation() {
    final loc = locationController.currentLocation.value;
    if (loc != null && mapController != null) {
      mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(loc.latitude, loc.longitude),
            zoom: mapZoom,
            bearing: 30,
            tilt: 45,
          ),
        ),
      );
    }
  }

  void zoomIn() {
    setState(() => mapZoom = (mapZoom + 1).clamp(5.0, 20.0));
    animateToLocation();
  }

  void zoomOut() {
    setState(() => mapZoom = (mapZoom - 1).clamp(5.0, 20.0));
    animateToLocation();
  }

  void toggleHistoryPath() {
    setState(() => showHistoryPath = !showHistoryPath);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [

          GetBuilder<LocationController>(
            builder: (controller) {
              final loc = controller.currentLocation.value;
              if (loc == null) {
                return NoLocationView(isDark: isDark);
              }

              return MapContainer(
                location: loc,
                mapZoom: mapZoom,
                showHistoryPath: showHistoryPath,
                customMarkerIcon: customMarkerIcon,
                onMapCreated: onMapCreated,
              );
            },
          ),

          MapAppBar(
            isDark: isDark,
            showHistoryPath: showHistoryPath,
            onBack: () => Get.back(),
            onTogglePath: toggleHistoryPath,
          ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: MapBottomCard(
              isDark: isDark,
              onRefresh: () {
                locationController.refreshNow();
                animateToLocation();
              },
            ),
          ),

          MapControls(
            isDark: isDark,
            onZoomIn: zoomIn,
            onZoomOut: zoomOut,
            onMyLocation: animateToLocation,
          ),

          HistoryCounter(isDark: isDark),
        ],
      ),
    );
  }
}