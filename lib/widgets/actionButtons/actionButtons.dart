import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:locationapp/Routes/appRoutes.dart';
import 'package:locationapp/controllers/locationController.dart';

class ActionButtons extends StatelessWidget {
  const ActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final locationController = Get.find<LocationController>();

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: isDark ? Color(0xFF1E1E1E) : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
            blurRadius: 20,
            spreadRadius: 1,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [

            Row(
              children: [
                Expanded(
                  child: Obx(() => buildPrimaryButton(
                    icon: Icons.refresh_rounded,
                    label: "Refresh",
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF2196F3),
                        Color(0xFF21CBF3),
                      ],
                    ),
                    isLoading: locationController.isRefreshing.value,
                    onTap: () => refreshLocation(locationController),
                  )),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: buildPrimaryButton(
                    icon: Icons.map_rounded,
                    label: "Open Map",
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF9C27B0),
                        Color(0xFFE91E63),
                      ],
                    ),
                    isLoading: false,
                    onTap: () => openMap(locationController),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? Color(0xFF404040) : Color(0xFFE0E0E0),
                  width: 2,
                ),
              ),
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(16),
                child: InkWell(
                  onTap: () => requestPermissionManually(locationController),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Obx(() => Icon(
                          getPermissionIcon(locationController.permissionStatus.value),
                          color: getPermissionColor(locationController.permissionStatus.value),
                          size: 20,
                        )),
                        SizedBox(width: 8),
                        Obx(() => Text(
                          getPermissionButtonText(locationController.permissionStatus.value),
                          style: TextStyle(
                            color: getPermissionColor(locationController.permissionStatus.value),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        )),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPrimaryButton({
    required IconData icon,
    required String label,
    required Gradient gradient,
    required bool isLoading,
    required Function onTap,
  }) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: gradient.colors.first.withOpacity(0.4),
            blurRadius: 12,
            spreadRadius: 1,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: isLoading ? null : () => onTap(),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            alignment: Alignment.center,
            child: isLoading
                ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  ),
                ),
                SizedBox(width: 12),
                Text(
                  "Updating...",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            )
                : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white, size: 22),
                SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  void refreshLocation(LocationController controller) async {
    if (controller.isRefreshing.value) return;

    controller.isRefreshing.value = true;

    Get.snackbar(
      "Refreshing",
      "Updating your current location...",
      snackPosition: SnackPosition.TOP,
      duration: Duration(seconds: 1),
      backgroundColor: Color(0xFF2196F3).withOpacity(0.9),
      colorText: Colors.white,
      icon: Icon(Icons.refresh, color: Colors.white),
    );

    try {
      await controller.refreshNow();
      Get.snackbar(
        "Location Updated",
        "Successfully refreshed your location",
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 2),
        backgroundColor: Color(0xFF4CAF50).withOpacity(0.9),
        colorText: Colors.white,
        icon: Icon(Icons.check_circle, color: Colors.white),
      );

    } catch (e) {
      // Error notification
      Get.snackbar(
        "Update Failed",
        "Could not refresh location: $e",
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 3),
        backgroundColor: Color(0xFFF44336).withOpacity(0.9),
        colorText: Colors.white,
        icon: Icon(Icons.error, color: Colors.white),
      );
    } finally {
      controller.isRefreshing.value = false;
    }
  }


  void openMap(LocationController controller) async {

    if (controller.currentLocation.value == null) {
      Get.snackbar(
        "No Location",
        "Please wait for location to load first",
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 2),
        backgroundColor: Color(0xFFFF9800).withOpacity(0.9),
        colorText: Colors.white,
        icon: Icon(Icons.warning, color: Colors.white),
      );
      return;
    }

    // Show loading notification
    Get.snackbar(
      "🗺Loading Map",
      "Preparing map view...",
      snackPosition: SnackPosition.TOP,
      duration: Duration(seconds: 1),
      backgroundColor: Color(0xFF9C27B0).withOpacity(0.9),
      colorText: Colors.white,
      icon: Icon(Icons.map, color: Colors.white),
    );
    await Future.delayed(Duration(milliseconds: 300));

    Get.toNamed(AppRoutes.mapScreen);
  }

  void requestPermissionManually(LocationController controller) async {
    Get.dialog(
      Center(
        child: Container(
          padding: EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Theme.of(Get.context!).brightness == Brightness.dark
                ? Color(0xFF1E1E1E)
                : Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Color(0xFF2196F3).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Stack(
                  children: [
                    Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Color(0xFF2196F3)),
                        strokeWidth: 4,
                      ),
                    ),
                    Center(
                      child: Icon(
                        Icons.location_on,
                        color: Color(0xFF2196F3),
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Requesting Permission",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(Get.context!).brightness == Brightness.dark
                      ? Colors.white
                      : Color(0xFF1A1A1A),
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Please allow location access when prompted",
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF666666),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );

    try {
      await controller.requestPermissionManually();
      Get.back(); // Close dialog

      // Check permission status after request
      final status = await controller.checkPermissionStatus();
      if (status == LocationPermission.denied || status == LocationPermission.deniedForever) {
        Get.snackbar(
          "Permission Required",
          "Location permission is still denied. Please enable it from app settings.",
          snackPosition: SnackPosition.TOP,
          duration: Duration(seconds: 3),
          backgroundColor: Color(0xFFFF9800),
          colorText: Colors.white,
          icon: Icon(Icons.warning, color: Colors.white),
        );
      }
    } catch (e) {
      Get.back();
      Get.snackbar(
        "Error",
        "Failed to request permission: $e",
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 3),
        backgroundColor: Color(0xFFF44336),
        colorText: Colors.white,
      );
    }
  }

  Color getPermissionColor(String status) {
    if (status.contains("Allowed") || status.contains("whileInUse") || status.contains("always")) {
      return Color(0xFF4CAF50);
    } else if (status.contains("Denied")) {
      return Color(0xFFFF9800);
    } else if (status.contains("Checking") || status.contains("Asking")) {
      return Color(0xFF2196F3);
    } else if (status.contains("Unable")) {
      return Color(0xFF9E9E9E);
    }
    return Color(0xFF666666);
  }

  IconData getPermissionIcon(String status) {
    if (status.contains("Allowed") || status.contains("whileInUse") || status.contains("always")) {
      return Icons.check_circle;
    } else if (status.contains("Denied")) {
      return Icons.warning;
    } else if (status.contains("Checking") || status.contains("Asking")) {
      return Icons.hourglass_empty;
    } else if (status.contains("Unable")) {
      return Icons.help_outline;
    }
    return Icons.location_disabled;
  }

  String getPermissionButtonText(String status) {
    if (status.contains("Allowed") || status.contains("whileInUse") || status.contains("always")) {
      return "Permission Granted";
    } else if (status.contains("Denied")) {
      return "Request Permission";
    } else if (status.contains("Checking") || status.contains("Asking")) {
      return "Checking...";
    } else if (status.contains("Unable")) {
      return "Check Permission";
    }
    return "Permissions";
  }


  showPermissionOptions(LocationController controller, BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          margin: EdgeInsets.only(top: 50),
          decoration: BoxDecoration(
            color: isDark ? Color(0xFF1E1E1E) : Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              Container(
                margin: EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Color(0xFF666666).withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Color(0xFF2196F3).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.security_rounded,
                          color: Color(0xFF2196F3),
                          size: 24,
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Location Permissions",
                        style: TextStyle(
                          color: isDark ? Colors.white : Color(0xFF1A1A1A),
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.close_rounded,
                        color: Color(0xFF666666),
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? Color(0xFF252525) : Color(0xFFF8F9FA),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Obx(() => Icon(
                        getPermissionIcon(controller.permissionStatus.value),
                        color: getPermissionColor(controller.permissionStatus.value),
                        size: 24,
                      )),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Current Status",
                              style: TextStyle(
                                color: Color(0xFF666666),
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(height: 4),
                            Obx(() => Text(
                              controller.permissionStatus.value,
                              style: TextStyle(
                                color: isDark ? Colors.white : Color(0xFF1A1A1A),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 2,
                            )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    buildPermissionOption(
                      title: "Request Permission",
                      subtitle: "Ask for location access again",
                      icon: Icons.location_on,
                      color: Color(0xFF2196F3),
                      onTap: () {
                        Navigator.pop(context);
                        requestPermissionManually(controller);
                      },
                      isDark: isDark,
                    ),

                    SizedBox(height: 12),

                    buildPermissionOption(
                      title: "Refresh Location",
                      subtitle: "Get current location again",
                      icon: Icons.refresh,
                      color: Color(0xFF4CAF50),
                      onTap: () {
                        Navigator.pop(context);
                        refreshLocation(controller);
                      },
                      isDark: isDark,
                    ),
                    SizedBox(height: 12),
                    buildPermissionOption(
                      title: "Open Map",
                      subtitle: "View location on Google Maps",
                      icon: Icons.map,
                      color: Color(0xFF9C27B0),
                      onTap: () {
                        Navigator.pop(context);
                        openMap(controller);
                      },
                      isDark: isDark,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
              // CLOSE BUTTON
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark ? Color(0xFF404040) : Color(0xFFE0E0E0),
                      width: 2,
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        alignment: Alignment.center,
                        child: Text(
                          "Close",
                          style: TextStyle(
                            color: isDark ? Colors.white70 : Color(0xFF666666),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).viewInsets.bottom + 20),
            ],
          ),
        );
      },
    );
  }

  Widget buildPermissionOption({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Function onTap,
    required bool isDark,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1.5,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: () => onTap(),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Icon(icon, color: color, size: 24),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: isDark ? Colors.white : Color(0xFF1A1A1A),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: Color(0xFF666666),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: Color(0xFF666666),
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}