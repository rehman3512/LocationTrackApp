import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:locationapp/Models/locationModel.dart';
import 'package:locationapp/controllers/locationController.dart';

class MapContainer extends StatelessWidget {
  final LocationModel location;
  final double mapZoom;
  final bool showHistoryPath;
  final BitmapDescriptor? customMarkerIcon;
  final Function(GoogleMapController) onMapCreated;

  const MapContainer({
    super.key,
    required this.location,
    required this.mapZoom,
    required this.showHistoryPath,
    this.customMarkerIcon,
    required this.onMapCreated,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final locationController = Get.find<LocationController>();

    final initial = CameraPosition(
      target: LatLng(location.latitude, location.longitude),
      zoom: mapZoom,
      bearing: 30,
      tilt: 45,
    );

    final markers = <Marker>{
      Marker(
        markerId: const MarkerId("current"),
        position: LatLng(location.latitude, location.longitude),
        icon: customMarkerIcon ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        infoWindow: InfoWindow(
          title: "Your Location",
          snippet: location.city?.isNotEmpty ?? false ? location.city! : "Current Position",
        ),
        rotation: 45,
        anchor: Offset(0.5, 0.5),
      )
    };

    final historyPoints = locationController.history
        .map((e) => LatLng(e.latitude, e.longitude))
        .toList();

    final polylines = <Polyline>{};
    if (showHistoryPath && historyPoints.length >= 2) {
      polylines.add(
        Polyline(
          polylineId: const PolylineId("path"),
          points: historyPoints,
          width: 4,
          color: isDark ? Colors.cyanAccent : Colors.deepPurple,
          patterns: [PatternItem.dash(10), PatternItem.gap(5)],
        ),
      );
    }

    return GoogleMap(
      initialCameraPosition: initial,
      markers: markers,
      polylines: polylines,
      onMapCreated: onMapCreated,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      mapToolbarEnabled: false,
      compassEnabled: true,
      rotateGesturesEnabled: true,
      tiltGesturesEnabled: true,
      mapType: MapType.normal,
      indoorViewEnabled: true,
      trafficEnabled: true,
      buildingsEnabled: true,
      padding: EdgeInsets.only(bottom: 80, top: 100),
    );
  }
}