import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:locationapp/Models/locationModel.dart';
import 'package:locationapp/Widgets/LoadingIndicator/loadingIndicator.dart';
import 'package:locationapp/controllers/locationController.dart';

class LocationCard extends StatelessWidget {
  const LocationCard({super.key});

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
        child: Obx(() {
          final loc = locationController.currentLocation.value;
          final isLoading = locationController.isLoading.value;
          final error = locationController.errorMessage.value;

          if (loc != null) {
            print("LocationCard - City: ${loc.city}, State: ${loc.state}, PostalCode: ${loc.postalCode}");
          }

          if (error.isNotEmpty) {
            return buildErrorState(error, locationController, isDark);
          }

          if (isLoading && loc == null) {
            return buildLoadingState(isDark);
          }

          if (loc != null) {
            return buildLocationData(loc, isDark);
          }

          // NO LOCATION STATE
          return buildNoLocationState(locationController, isDark);
        }),
      ),
    );
  }

  Widget buildLocationData(LocationModel loc, bool isDark) {
    final fmt = DateFormat('hh:mm a');


    final city = loc.city ?? "Unknown City";
    final state = loc.state ?? "Unknown State";
    final postalCode = loc.postalCode ?? "29111";


    final isDefaultPostalCode = postalCode == "29111" || postalCode == "29111";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF2196F3),
                    Color(0xFF21CBF3),
                  ],
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Icon(
                  Icons.gps_fixed_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Live Location",
                    style: TextStyle(
                      color: isDark ? Colors.white : Color(0xFF1A1A1A),
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Updated ${fmt.format(loc.timestamp)}",
                    style: TextStyle(
                      color: Color(0xFF666666),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF00C853),
                    Color(0xFF64DD17),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 6),
                  Text(
                    "LIVE",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 24),
        Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? Color(0xFF252525) : Color(0xFFF8F9FA),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              buildCoordinateBox(
                title: "LATITUDE",
                value: loc.latitude.toStringAsFixed(6),
                icon: Icons.north,
                color: Color(0xFF2196F3),
                isDark: isDark,
              ),
              SizedBox(width: 20),
              buildCoordinateBox(
                title: "LONGITUDE",
                value: loc.longitude.toStringAsFixed(6),
                icon: Icons.east,
                color: Color(0xFF9C27B0),
                isDark: isDark,
              ),
            ],
          ),
        ),
        SizedBox(height: 24),
        buildAddressGrid(city, state, postalCode, isDefaultPostalCode, isDark),
      ],
    );
  }

  Widget buildAddressGrid(String city, String state, String postalCode, bool isDefaultPostalCode, bool isDark) {

    final maxLength = [city.length, state.length, postalCode.length].reduce((a, b) => a > b ? a : b);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            children: [
              Icon(
                Icons.location_on,
                size: 18,
                color: Color(0xFF2196F3),
              ),
              SizedBox(width: 8),
              Text(
                "Address Details",
                style: TextStyle(
                  color: isDark ? Colors.white : Color(0xFF1A1A1A),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),

        Row(
          children: [

            Expanded(
              child: buildAddressBox(
                title: "City",
                value: city,
                icon: Icons.location_city_rounded,
                color: Color(0xFFFF9800),
                isDark: isDark,
                textLength: maxLength,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: buildAddressBox(
                title: "State",
                value: state,
                icon: Icons.map_rounded,
                color: Color(0xFF4CAF50),
                isDark: isDark,
                textLength: maxLength,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  color: isDark ? Color(0xFF2C2C2C) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Color(0xFFF44336).withOpacity(0.2),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.pin_rounded,
                            size: 14,
                            color: Color(0xFFF44336),
                          ),
                          SizedBox(width: 6),
                          Text(
                            "PinCode",
                            style: TextStyle(
                              color: Color(0xFF666666),
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Container(
                        height: 40,
                        alignment: Alignment.center,
                        child: Text(
                          postalCode,
                          style: TextStyle(
                            color: isDark ? Colors.white : Color(0xFF1A1A1A),
                            fontSize: calculateFontSize(postalCode),
                            fontWeight: FontWeight.w700, // ✅ ALWAYS BOLD
                            height: 1.2,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildAddressBox({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required bool isDark,
    required int textLength,
    bool isDefault = false,
  }) {

    final boxHeight = textLength > 15 ? 100.0 : 90.0;

    return Container(
      height: boxHeight,
      decoration: BoxDecoration(
        color: isDark ? Color(0xFF2C2C2C) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(isDefault ? 0.1 : 0.2),
          width: 1.5,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 14,
                  color: color.withOpacity(isDefault ? 0.5 : 1.0),
                ),
                SizedBox(width: 6),
                Flexible(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: Color(0xFF666666),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      overflow: TextOverflow.ellipsis,
                    ),
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Container(
              height: 40,
              alignment: Alignment.center,
              child: Text(
                value,
                style: TextStyle(
                  color: isDark ? Colors.white : Color(0xFF1A1A1A),
                  fontSize: calculateFontSize(value),
                  fontWeight: isDefault ? FontWeight.w500 : FontWeight.w700,
                  fontStyle: isDefault ? FontStyle.italic : FontStyle.normal,
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  double calculateFontSize(String text) {
    if (text.length > 20) return 11;
    if (text.length > 15) return 12;
    if (text.length > 10) return 13;
    return 14;
  }

  Widget buildLoadingState(bool isDark) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        LoadingIndicator(label: "Getting location..."),
        SizedBox(height: 20),
        Text(
          "Requesting permission...",
          style: TextStyle(
            color: Color(0xFF666666),
            fontSize: 14,
          ),
        ),
        SizedBox(height: 16),
        Text(
          "Please allow location access when prompted",
          style: TextStyle(
            color: Color(0xFF999999),
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget buildErrorState(String error, LocationController controller, bool isDark) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.error_outline,
          size: 60,
          color: Colors.orange,
        ),
        SizedBox(height: 20),
        Text(
          "Location Error",
          style: TextStyle(
            color: isDark ? Colors.white : Color(0xFF1A1A1A),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 10),
        Text(
          error,
          style: TextStyle(
            color: Color(0xFF666666),
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () => controller.retryInit(),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF2196F3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: Text(
            "Retry",
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildNoLocationState(LocationController controller, bool isDark) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.location_off,
          size: 60,
          color: Color(0xFF999999),
        ),
        SizedBox(height: 20),
        Text(
          "Location Not Available",
          style: TextStyle(
            color: isDark ? Colors.white : Color(0xFF1A1A1A),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 10),
        Text(
          "Tap below to get your location",
          style: TextStyle(
            color: Color(0xFF666666),
            fontSize: 14,
          ),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () => controller.retryInit(),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF2196F3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: Text(
            "Get Location",
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildCoordinateBox({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required bool isDark,
  }) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? Color(0xFF2C2C2C) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withOpacity(0.2),
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(icon, color: color, size: 20),
              ),
            ),
            SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                color: Color(0xFF666666),
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
            SizedBox(height: 8),
            SelectableText(
              value,
              style: TextStyle(
                color: isDark ? Colors.white : Color(0xFF1A1A1A),
                fontSize: 15,
                fontWeight: FontWeight.w700,
                fontFamily: 'RobotoMono',
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}