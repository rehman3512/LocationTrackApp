import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:locationapp/controllers/locationController.dart';

class MapAppBar extends StatelessWidget {
  final bool isDark;
  final bool showHistoryPath;
  final VoidCallback onBack;
  final VoidCallback onTogglePath;

  const MapAppBar({
    super.key,
    required this.isDark,
    required this.showHistoryPath,
    required this.onBack,
    required this.onTogglePath,
  });

  @override
  Widget build(BuildContext context) {
    final locationController = Get.find<LocationController>();

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [Colors.black87, Colors.transparent]
                : [Colors.white, Colors.transparent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                buildBackButton(),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Live Location Map",
                        style: TextStyle(
                          color: isDark ? Colors.white : Color(0xFF1A1A1A),
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Obx(() {
                        final loc = locationController.currentLocation.value;
                        return Text(
                          loc?.city?.isNotEmpty ?? false ? loc!.city! : "Tracking Movement",
                          style: TextStyle(
                            color: isDark ? Colors.white70 : Color(0xFF666666),
                            fontSize: 14,
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                buildHistoryToggle(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildBackButton() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: isDark ? Color(0xFF1E1E1E) : Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(Icons.arrow_back_rounded),
        color: isDark ? Colors.white : Colors.black,
        onPressed: onBack,
      ),
    );
  }

  Widget buildHistoryToggle() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: isDark ? Color(0xFF1E1E1E) : Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(
          showHistoryPath ? Icons.timeline : Icons.timeline_outlined,
          color: showHistoryPath
              ? Colors.blueAccent
              : (isDark ? Colors.white70 : Colors.grey),
        ),
        onPressed: onTogglePath,
        tooltip: showHistoryPath ? "Hide Path" : "Show Path",
      ),
    );
  }
}