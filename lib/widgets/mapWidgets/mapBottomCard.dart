import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:locationapp/Models/locationModel.dart';
import 'package:locationapp/controllers/locationController.dart';
import 'package:locationapp/widgets/mapWidgets/coordinatesItem.dart';
import 'package:locationapp/widgets/mapWidgets/mapActionButton.dart';


class MapBottomCard extends StatelessWidget {
  final bool isDark;
  final VoidCallback onRefresh;

  const MapBottomCard({
    super.key,
    required this.isDark,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LocationController>(
      builder: (locationController) {
        final loc = locationController.currentLocation.value;
        if (loc == null) return SizedBox.shrink();

        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? [Color(0xFF1E1E1E), Color(0xFF1E1E1E)]
                  : [Colors.white, Colors.white],
            ),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 20,
                spreadRadius: 5,
                offset: Offset(0, -5),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildHeader(loc),
                SizedBox(height: 16),
                buildCoordinates(loc),
                SizedBox(height: 12),
                buildActionButtons(locationController),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildHeader(LocationModel loc) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF2196F3), Color(0xFF21CBF3)],
            ),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.gps_fixed, color: Colors.white, size: 20),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Current Position",
                style: TextStyle(
                  color: isDark ? Colors.white : Color(0xFF1A1A1A),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                DateFormat('hh:mm a').format(loc.timestamp),
                style: TextStyle(color: Color(0xFF666666), fontSize: 12),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.green.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(color: Colors.green, shape: BoxShape.circle),
              ),
              SizedBox(width: 6),
              Text("LIVE", style: TextStyle(color: Colors.green, fontSize: 10)),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildCoordinates(LocationModel loc) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Color(0xFF252525) : Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Color(0xFF404040) : Color(0xFFE0E0E0),
        ),
      ),
      child: Row(
        children: [
          CoordinateItem(
            title: "Latitude",
            value: loc.latitude.toStringAsFixed(6),
            icon: Icons.north,
            color: Color(0xFF2196F3),
            isDark: isDark,
          ),
          SizedBox(width: 20),
          CoordinateItem(
            title: "Longitude",
            value: loc.longitude.toStringAsFixed(6),
            icon: Icons.east,
            color: Color(0xFF9C27B0),
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget buildActionButtons(LocationController locationController) {
    return Row(
      children: [
        Expanded(
          child: MapActionButton(
            icon: Icons.refresh,
            label: "Refresh",
            color: Color(0xFF2196F3),
            onTap: onRefresh,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: MapActionButton(
            icon: Icons.share,
            label: "Share",
            color: Color(0xFF4CAF50),
            onTap: () => shareLocation(locationController),
          ),
        ),
      ],
    );
  }

  void shareLocation(LocationController locationController) {
    final loc = locationController.currentLocation.value;
    if (loc == null) return;

    final message = "My Location:\n"
        "Latitude: ${loc.latitude.toStringAsFixed(6)}\n"
        "Longitude: ${loc.longitude.toStringAsFixed(6)}\n"
        "Address: ${loc.city ?? 'Unknown'}, ${loc.state ?? 'Unknown'}\n"
        "Pincode: ${loc.postalCode ?? '000000'}\n"
        "Time: ${DateFormat('hh:mm a').format(loc.timestamp)}";

    Get.snackbar(
      "Share Location",
      "Copy the location details to clipboard",
      snackPosition: SnackPosition.TOP,
      duration: Duration(seconds: 2),
      backgroundColor: Color(0xFF2196F3),
      colorText: Colors.white,
    );
  }
}