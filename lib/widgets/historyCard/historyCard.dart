import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:locationapp/controllers/locationController.dart';

class HistoryCard extends StatelessWidget {
  const HistoryCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final locationController = Get.find<LocationController>();
    final fmt = DateFormat('hh:mm a');

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
                        Color(0xFFFF9800),
                        Color(0xFFFFB74D),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.history_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Text(
                    "Location History",
                    style: TextStyle(
                      color: isDark ? Colors.white : Color(0xFF1A1A1A),
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Obx(() => Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Color(0xFF2196F3).withOpacity(isDark ? 0.2 : 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "${locationController.history.length}",
                    style: TextStyle(
                      color: Color(0xFF2196F3),
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                )),
              ],
            ),
            SizedBox(height: 24),
            Obx(() {
              final history = locationController.history;
              final totalItems = history.length;
              final itemsToShow = totalItems > 5 ? 5 : totalItems;

              if (totalItems == 0) {
                return buildEmptyState(isDark);
              }

              return Column(
                children: [
                  ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: itemsToShow,
                    separatorBuilder: (context, index) => SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = history[index];
                      return buildHistoryItem(
                        item: item,
                        index: index,
                        fmt: fmt,
                        isDark: isDark,
                        onTap: () => showLocationDetails(item, isDark),
                      );
                    },
                  ),

                  if (totalItems > 5)
                    Column(
                      children: [
                        SizedBox(height: 16),
                        Divider(
                          color: Colors.grey.withOpacity(0.3),
                          height: 1,
                        ),
                        SizedBox(height: 16),
                        GestureDetector(
                          onTap: () => showAllHistory(locationController, isDark),
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: Color(0xFF2196F3).withOpacity(isDark ? 0.1 : 0.05),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "View All ${totalItems - 5} More Locations",
                                  style: TextStyle(
                                    color: Color(0xFF2196F3),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Icon(
                                  Icons.arrow_forward_rounded,
                                  color: Color(0xFF2196F3),
                                  size: 16,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget buildEmptyState(bool isDark) {
    return Column(
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: isDark ? Color(0xFF2C2C2C) : Color(0xFFF8F9FA),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(
              Icons.history_toggle_off_rounded,
              size: 48,
              color: Color(0xFF999999),
            ),
          ),
        ),
        SizedBox(height: 24),
        Text(
          "No History Yet",
          style: TextStyle(
            color: isDark ? Colors.white70 : Color(0xFF666666),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8),
        Text(
          "Move around to see your location history",
          style: TextStyle(
            color: Color(0xFF999999),
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget buildHistoryItem({
    required dynamic item,
    required int index,
    required DateFormat fmt,
    required bool isDark,
    required Function onTap,
  }) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? Color(0xFF252525) : Color(0xFFF8F9FA),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.grey.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // INDEX
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF2196F3),
                    Color(0xFF21CBF3),
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  "${index + 1}",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.city.isNotEmpty ? item.city : 'Unknown Location',
                          style: TextStyle(
                            color: isDark ? Colors.white : Color(0xFF1A1A1A),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            overflow: TextOverflow.ellipsis,
                          ),
                          maxLines: 1,
                        ),
                      ),
                      Text(
                        fmt.format(item.timestamp),
                        style: TextStyle(
                          color: Color(0xFF666666),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    "${item.latitude.toStringAsFixed(4)}, ${item.longitude.toStringAsFixed(4)}",
                    style: TextStyle(
                      color: Color(0xFF666666),
                      fontSize: 14,
                      fontFamily: 'RobotoMono',
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFF666666),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  void showLocationDetails(dynamic item, bool isDark) {
    Get.defaultDialog(
      title: "Location Details",
      titlePadding: EdgeInsets.only(top: 24, bottom: 16),
      contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildDetailRow("City:", item.city, isDark),
          buildDetailRow("State:", item.state, isDark),
          buildDetailRow("Pincode:", item.postalCode, isDark),
          buildDetailRow("Latitude:", item.latitude.toStringAsFixed(6), isDark),
          buildDetailRow("Longitude:", item.longitude.toStringAsFixed(6), isDark),
          buildDetailRow("Time:", DateFormat('yyyy-MM-dd hh:mm a').format(item.timestamp), isDark),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF666666),
                  ),
                  child: Text("Close"),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Get.back();

                    Get.snackbar(
                      "Location Selected",
                      "Would navigate to map here",
                      snackPosition: SnackPosition.TOP,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF2196F3),
                  ),
                  child: Text("View on Map"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildDetailRow(String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                color: isDark ? Colors.white70 : Color(0xFF666666),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: SelectableText(
              value,
              style: TextStyle(
                color: isDark ? Colors.white : Color(0xFF1A1A1A),
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showAllHistory(LocationController controller, bool isDark) {
    final fmt = DateFormat('yyyy-MM-dd hh:mm a');

    Get.bottomSheet(
      Container(
        height: Get.height * 0.8,
        decoration: BoxDecoration(
          color: isDark ? Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [

            Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey.withOpacity(0.2),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.history_rounded,
                    color: Color(0xFFFF9800),
                    size: 24,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "All Location History",
                      style: TextStyle(
                        color: isDark ? Colors.white : Color(0xFF1A1A1A),
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(
                      Icons.close_rounded,
                      color: Color(0xFF666666),
                    ),
                  ),
                ],
              ),
            ),


            Expanded(
              child: Obx(() => ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: controller.history.length,
                itemBuilder: (context, index) {
                  final item = controller.history[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: buildHistoryItem(
                      item: item,
                      index: index,
                      fmt: fmt,
                      isDark: isDark,
                      onTap: () => showLocationDetails(item, isDark),
                    ),
                  );
                },
              )),
            ),
          ],
        ),
      ),
    );
  }
}