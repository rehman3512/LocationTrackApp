// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:locationapp/Models/locationModel.dart';
// import 'package:locationapp/controllers/locationController.dart';
// import 'package:intl/intl.dart';
//
// class MapView extends StatefulWidget {
//   const MapView({super.key});
//
//   @override
//   State<MapView> createState() => _MapViewState();
// }
//
// class _MapViewState extends State<MapView> {
//   GoogleMapController? _mapController;
//   final locationController = Get.find<LocationController>();
//   BitmapDescriptor? _customMarkerIcon;
//   bool _showHistoryPath = true;
//   double _mapZoom = 15.0;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadCustomMarker();
//   }
//
//   Future<void> _loadCustomMarker() async {
//     _customMarkerIcon = await BitmapDescriptor.fromAssetImage(
//       ImageConfiguration(size: Size(48, 48)),
//       'assets/location_pin.png',
//     );
//   }
//
//   void _onMapCreated(GoogleMapController controller) {
//     _mapController = controller;
//     _animateToCurrentLocation();
//   }
//
//   void _animateToCurrentLocation() {
//     final loc = locationController.currentLocation.value;
//     if (loc != null && _mapController != null) {
//       _mapController!.animateCamera(
//         CameraUpdate.newCameraPosition(
//           CameraPosition(
//             target: LatLng(loc.latitude, loc.longitude),
//             zoom: _mapZoom,
//             bearing: 30,
//             tilt: 45,
//           ),
//         ),
//       );
//     }
//   }
//
//   void _zoomIn() {
//     setState(() => _mapZoom = (_mapZoom + 1).clamp(5.0, 20.0));
//     _animateToCurrentLocation();
//   }
//
//   void _zoomOut() {
//     setState(() => _mapZoom = (_mapZoom - 1).clamp(5.0, 20.0));
//     _animateToCurrentLocation();
//   }
//
//   void _toggleHistoryPath() {
//     setState(() => _showHistoryPath = !_showHistoryPath);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     final loc = locationController.currentLocation.value;
//
//     return Scaffold(
//       body: Stack(
//         children: [
//           // MAP BACKGROUND
//           Obx(() {
//             if (loc == null) {
//               return _buildNoLocationState(isDark);
//             }
//
//             final initial = CameraPosition(
//               target: LatLng(loc.latitude, loc.longitude),
//               zoom: _mapZoom,
//               bearing: 30,
//               tilt: 45,
//             );
//
//             final markers = <Marker>{
//               Marker(
//                 markerId: const MarkerId("current"),
//                 position: LatLng(loc.latitude, loc.longitude),
//                 icon: _customMarkerIcon ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
//                 infoWindow: InfoWindow(
//                   title: "📍 Your Location",
//                   snippet: (loc.city?.isNotEmpty ?? false) ? loc.city! : "Current Position", // ✅ FIXED NULL CHECK
//                 ),
//                 rotation: 45,
//                 anchor: Offset(0.5, 0.5),
//                 consumeTapEvents: true,
//                 onTap: () => _showLocationDetails(loc, isDark),
//               )
//             };
//
//             final historyPoints = locationController.history
//                 .map((e) => LatLng(e.latitude, e.longitude))
//                 .toList();
//
//             final polylines = <Polyline>{};
//             if (_showHistoryPath && historyPoints.length >= 2) {
//               polylines.add(
//                 Polyline(
//                   polylineId: const PolylineId("path"),
//                   points: historyPoints,
//                   width: 4,
//                   color: isDark ? Colors.cyanAccent : Colors.deepPurple,
//                   patterns: [
//                     PatternItem.dash(10),
//                     PatternItem.gap(5),
//                   ],
//                 ),
//               );
//             }
//
//             return GoogleMap(
//               initialCameraPosition: initial,
//               markers: markers,
//               polylines: polylines,
//               onMapCreated: _onMapCreated,
//               myLocationEnabled: true,
//               myLocationButtonEnabled: false,
//               zoomControlsEnabled: false,
//               mapToolbarEnabled: false,
//               compassEnabled: true,
//               rotateGesturesEnabled: true,
//               tiltGesturesEnabled: true,
//               mapType: MapType.normal,
//               indoorViewEnabled: true,
//               trafficEnabled: true,
//               buildingsEnabled: true,
//               padding: EdgeInsets.only(bottom: 80, top: 100),
//             );
//           }),
//
//           // CUSTOM APP BAR
//           Positioned(
//             top: 0,
//             left: 0,
//             right: 0,
//             child: Container(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: isDark
//                       ? [Colors.black87, Colors.transparent]
//                       : [Colors.white, Colors.transparent],
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                 ),
//               ),
//               child: SafeArea(
//                 bottom: false,
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Row(
//                     children: [
//                       // BACK BUTTON
//                       Container(
//                         width: 50,
//                         height: 50,
//                         decoration: BoxDecoration(
//                           color: isDark ? Color(0xFF1E1E1E) : Colors.white,
//                           shape: BoxShape.circle,
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black.withOpacity(0.2),
//                               blurRadius: 10,
//                               spreadRadius: 1,
//                             ),
//                           ],
//                         ),
//                         child: IconButton(
//                           icon: Icon(Icons.arrow_back_rounded),
//                           color: isDark ? Colors.white : Colors.black,
//                           onPressed: () => Get.back(),
//                         ),
//                       ),
//                       SizedBox(width: 12),
//
//                       // TITLE
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               "Live Location Map",
//                               style: TextStyle(
//                                 color: isDark ? Colors.white : Color(0xFF1A1A1A),
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.w700,
//                               ),
//                             ),
//                             Obx(() {
//                               final loc = locationController.currentLocation.value;
//                               return Text(
//                                 (loc?.city?.isNotEmpty ?? false) ? loc!.city! : "Tracking Movement", // ✅ FIXED
//                                 style: TextStyle(
//                                   color: isDark ? Colors.white70 : Color(0xFF666666),
//                                   fontSize: 14,
//                                 ),
//                               );
//                             }),
//                           ],
//                         ),
//                       ),
//
//                       // HISTORY TOGGLE
//                       Container(
//                         width: 50,
//                         height: 50,
//                         decoration: BoxDecoration(
//                           color: isDark ? Color(0xFF1E1E1E) : Colors.white,
//                           shape: BoxShape.circle,
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black.withOpacity(0.2),
//                               blurRadius: 10,
//                               spreadRadius: 1,
//                             ),
//                           ],
//                         ),
//                         child: IconButton(
//                           icon: Icon(
//                             _showHistoryPath ? Icons.timeline : Icons.timeline_outlined,
//                             color: _showHistoryPath
//                                 ? Colors.blueAccent
//                                 : (isDark ? Colors.white70 : Colors.grey),
//                           ),
//                           onPressed: _toggleHistoryPath,
//                           tooltip: _showHistoryPath ? "Hide Path" : "Show Path",
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//
//           // BOTTOM INFO CARD
//           Positioned(
//             bottom: 0,
//             left: 0,
//             right: 0,
//             child: Obx(() {
//               final loc = locationController.currentLocation.value;
//               if (loc == null) return SizedBox.shrink();
//
//               return Container(
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: isDark
//                         ? [Color(0xFF1E1E1E), Color(0xFF1E1E1E)]
//                         : [Colors.white, Colors.white],
//                     begin: Alignment.topCenter,
//                     end: Alignment.bottomCenter,
//                   ),
//                   borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.3),
//                       blurRadius: 20,
//                       spreadRadius: 5,
//                       offset: Offset(0, -5),
//                     ),
//                   ],
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(20.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // LOCATION INFO HEADER
//                       Row(
//                         children: [
//                           Container(
//                             width: 40,
//                             height: 40,
//                             decoration: BoxDecoration(
//                               gradient: LinearGradient(
//                                 colors: [Color(0xFF2196F3), Color(0xFF21CBF3)],
//                               ),
//                               shape: BoxShape.circle,
//                             ),
//                             child: Center(
//                               child: Icon(
//                                 Icons.gps_fixed,
//                                 color: Colors.white,
//                                 size: 20,
//                               ),
//                             ),
//                           ),
//                           SizedBox(width: 12),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   "Current Position",
//                                   style: TextStyle(
//                                     color: isDark ? Colors.white : Color(0xFF1A1A1A),
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                                 Text(
//                                   DateFormat('hh:mm a').format(loc.timestamp),
//                                   style: TextStyle(
//                                     color: Color(0xFF666666),
//                                     fontSize: 12,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Container(
//                             padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                             decoration: BoxDecoration(
//                               color: Colors.green.withOpacity(0.1),
//                               borderRadius: BorderRadius.circular(20),
//                               border: Border.all(color: Colors.green.withOpacity(0.3)),
//                             ),
//                             child: Row(
//                               children: [
//                                 Container(
//                                   width: 6,
//                                   height: 6,
//                                   decoration: BoxDecoration(
//                                     color: Colors.green,
//                                     shape: BoxShape.circle,
//                                   ),
//                                 ),
//                                 SizedBox(width: 6),
//                                 Text(
//                                   "LIVE",
//                                   style: TextStyle(
//                                     color: Colors.green,
//                                     fontSize: 10,
//                                     fontWeight: FontWeight.w700,
//                                     letterSpacing: 1,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 16),
//
//                       // COORDINATES
//                       Container(
//                         padding: EdgeInsets.all(16),
//                         decoration: BoxDecoration(
//                           color: isDark ? Color(0xFF252525) : Color(0xFFF8F9FA),
//                           borderRadius: BorderRadius.circular(16),
//                           border: Border.all(
//                             color: isDark ? Color(0xFF404040) : Color(0xFFE0E0E0),
//                           ),
//                         ),
//                         child: Row(
//                           children: [
//                             _buildCoordinateItem(
//                               "Latitude",
//                               loc.latitude.toStringAsFixed(6),
//                               Icons.north,
//                               Color(0xFF2196F3),
//                               isDark,
//                             ),
//                             SizedBox(width: 20),
//                             _buildCoordinateItem(
//                               "Longitude",
//                               loc.longitude.toStringAsFixed(6),
//                               Icons.east,
//                               Color(0xFF9C27B0),
//                               isDark,
//                             ),
//                           ],
//                         ),
//                       ),
//                       SizedBox(height: 12),
//
//                       // ACTION BUTTONS
//                       Row(
//                         children: [
//                           Expanded(
//                             child: _buildActionButton(
//                               icon: Icons.refresh,
//                               label: "Refresh",
//                               color: Color(0xFF2196F3),
//                               onTap: () {
//                                 locationController.refreshNow();
//                                 _animateToCurrentLocation();
//                               },
//                             ),
//                           ),
//                           SizedBox(width: 12),
//                           Expanded(
//                             child: _buildActionButton(
//                               icon: Icons.share,
//                               label: "Share",
//                               color: Color(0xFF4CAF50),
//                               onTap: () => _shareLocation(loc),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             }),
//           ),
//
//           // ZOOM CONTROLS (RIGHT SIDE)
//           Positioned(
//             right: 16,
//             bottom: 200,
//             child: Column(
//               children: [
//                 // ZOOM IN
//                 Container(
//                   width: 44,
//                   height: 44,
//                   decoration: BoxDecoration(
//                     color: isDark ? Color(0xFF1E1E1E) : Colors.white,
//                     shape: BoxShape.circle,
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.2),
//                         blurRadius: 8,
//                         spreadRadius: 1,
//                       ),
//                     ],
//                   ),
//                   child: IconButton(
//                     icon: Icon(Icons.add, size: 20),
//                     color: isDark ? Colors.white : Colors.black,
//                     onPressed: _zoomIn,
//                   ),
//                 ),
//                 SizedBox(height: 12),
//                 // ZOOM OUT
//                 Container(
//                   width: 44,
//                   height: 44,
//                   decoration: BoxDecoration(
//                     color: isDark ? Color(0xFF1E1E1E) : Colors.white,
//                     shape: BoxShape.circle,
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.2),
//                         blurRadius: 8,
//                         spreadRadius: 1,
//                       ),
//                     ],
//                   ),
//                   child: IconButton(
//                     icon: Icon(Icons.remove, size: 20),
//                     color: isDark ? Colors.white : Colors.black,
//                     onPressed: _zoomOut,
//                   ),
//                 ),
//                 SizedBox(height: 12),
//                 // MY LOCATION
//                 Container(
//                   width: 44,
//                   height: 44,
//                   decoration: BoxDecoration(
//                     color: isDark ? Color(0xFF1E1E1E) : Colors.white,
//                     shape: BoxShape.circle,
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.2),
//                         blurRadius: 8,
//                         spreadRadius: 1,
//                       ),
//                     ],
//                   ),
//                   child: IconButton(
//                     icon: Icon(Icons.my_location, size: 20),
//                     color: Color(0xFF2196F3),
//                     onPressed: _animateToCurrentLocation,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           // HISTORY COUNTER (TOP RIGHT)
//           Positioned(
//             top: 100,
//             right: 16,
//             child: Container(
//               padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               decoration: BoxDecoration(
//                 color: isDark ? Color(0xFF1E1E1E) : Colors.white,
//                 borderRadius: BorderRadius.circular(20),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.2),
//                     blurRadius: 10,
//                     spreadRadius: 1,
//                   ),
//                 ],
//               ),
//               child: Row(
//                 children: [
//                   Icon(
//                     Icons.history,
//                     size: 16,
//                     color: Color(0xFFFF9800),
//                   ),
//                   SizedBox(width: 6),
//                   Obx(() => Text(
//                     "${locationController.history.length} points",
//                     style: TextStyle(
//                       color: isDark ? Colors.white : Color(0xFF1A1A1A),
//                       fontSize: 12,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   )),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildNoLocationState(bool isDark) {
//     return Container(
//       color: isDark ? Color(0xFF121212) : Color(0xFFF8F9FA),
//       child: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               width: 120,
//               height: 120,
//               decoration: BoxDecoration(
//                 color: Color(0xFF2196F3).withOpacity(0.1),
//                 shape: BoxShape.circle,
//               ),
//               child: Icon(
//                 Icons.map_outlined,
//                 size: 60,
//                 color: Color(0xFF2196F3),
//               ),
//             ),
//             SizedBox(height: 24),
//             Text(
//               "No Location Data",
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.w700,
//                 color: isDark ? Colors.white : Color(0xFF1A1A1A),
//               ),
//             ),
//             SizedBox(height: 12),
//             Text(
//               "Enable location services to view map",
//               style: TextStyle(
//                 color: Color(0xFF666666),
//                 fontSize: 14,
//               ),
//             ),
//             SizedBox(height: 24),
//             ElevatedButton(
//               onPressed: () => Get.back(),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Color(0xFF2196F3),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 padding: EdgeInsets.symmetric(horizontal: 32, vertical: 14),
//               ),
//               child: Text(
//                 "Go Back",
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 14,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildCoordinateItem(String title, String value, IconData icon, Color color, bool isDark) {
//     return Expanded(
//       child: Container(
//         padding: EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: isDark ? Color(0xFF2C2C2C) : Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: color.withOpacity(0.2)),
//         ),
//         child: Column(
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(icon, size: 14, color: color),
//                 SizedBox(width: 6),
//                 Text(
//                   title,
//                   style: TextStyle(
//                     color: color,
//                     fontSize: 11,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 6),
//             SelectableText(
//               value,
//               style: TextStyle(
//                 color: isDark ? Colors.white : Color(0xFF1A1A1A),
//                 fontSize: 13,
//                 fontWeight: FontWeight.w700,
//                 fontFamily: 'RobotoMono',
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildActionButton({
//     required IconData icon,
//     required String label,
//     required Color color,
//     required VoidCallback onTap,
//   }) {
//     return Container(
//       height: 44,
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: color.withOpacity(0.3)),
//       ),
//       child: Material(
//         color: Colors.transparent,
//         borderRadius: BorderRadius.circular(12),
//         child: InkWell(
//           onTap: onTap,
//           borderRadius: BorderRadius.circular(12),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(icon, size: 18, color: color),
//               SizedBox(width: 8),
//               Text(
//                 label,
//                 style: TextStyle(
//                   color: color,
//                   fontSize: 14,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   void _showLocationDetails(LocationModel loc, bool isDark) {
//     Get.bottomSheet(
//       Container(
//         height: Get.height * 0.6,
//         decoration: BoxDecoration(
//           color: isDark ? Color(0xFF1E1E1E) : Colors.white,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Center(
//                 child: Container(
//                   width: 40,
//                   height: 4,
//                   decoration: BoxDecoration(
//                     color: Colors.grey.withOpacity(0.3),
//                     borderRadius: BorderRadius.circular(2),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 20),
//               Text(
//                 "📍 Location Details",
//                 style: TextStyle(
//                   fontSize: 22,
//                   fontWeight: FontWeight.w700,
//                   color: isDark ? Colors.white : Color(0xFF1A1A1A),
//                 ),
//               ),
//               SizedBox(height: 20),
//               Expanded(
//                 child: ListView(
//                   children: [
//                     _buildDetailItem("City", loc.city ?? "Unknown", Icons.location_city), // ✅ NULL CHECK
//                     _buildDetailItem("State", loc.state ?? "Unknown", Icons.map), // ✅ NULL CHECK
//                     _buildDetailItem("Pincode", loc.postalCode ?? "000000", Icons.pin_drop), // ✅ NULL CHECK + FIXED
//                     _buildDetailItem("Latitude", loc.latitude.toStringAsFixed(6), Icons.north),
//                     _buildDetailItem("Longitude", loc.longitude.toStringAsFixed(6), Icons.east),
//                     _buildDetailItem("Time", DateFormat('yyyy-MM-dd hh:mm a').format(loc.timestamp), Icons.access_time),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildDetailItem(String label, String value, IconData icon) {
//     final isDark = Theme.of(Get.context!).brightness == Brightness.dark;
//
//     return Container(
//       margin: EdgeInsets.only(bottom: 12),
//       padding: EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: isDark ? Color(0xFF252525) : Color(0xFFF8F9FA),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Row(
//         children: [
//           Icon(icon, color: Color(0xFF2196F3), size: 20),
//           SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   label,
//                   style: TextStyle(
//                     color: Color(0xFF666666),
//                     fontSize: 12,
//                   ),
//                 ),
//                 SizedBox(height: 4),
//                 SelectableText(
//                   value,
//                   style: TextStyle(
//                     color: isDark ? Colors.white : Color(0xFF1A1A1A),
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _shareLocation(LocationModel loc) {
//     final message = "📍 My Location:\n"
//         "Latitude: ${loc.latitude.toStringAsFixed(6)}\n"
//         "Longitude: ${loc.longitude.toStringAsFixed(6)}\n"
//         "Address: ${loc.city ?? 'Unknown'}, ${loc.state ?? 'Unknown'}\n" // ✅ NULL CHECK
//         "Pincode: ${loc.postalCode ?? '000000'}\n" // ✅ NULL CHECK + FIXED
//         "Time: ${DateFormat('hh:mm a').format(loc.timestamp)}";
//
//     Get.snackbar(
//       "Share Location",
//       "Copy the location details to clipboard",
//       snackPosition: SnackPosition.TOP,
//       duration: Duration(seconds: 2),
//       backgroundColor: Color(0xFF2196F3),
//       colorText: Colors.white,
//     );
//   }
// }


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