import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:locationapp/controllers/locationController.dart';

class HistoryCounter extends StatelessWidget {
  final bool isDark;

  const HistoryCounter({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 100,
      right: 16,
      child: GetBuilder<LocationController>(
        builder: (controller) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isDark ? Color(0xFF1E1E1E) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(Icons.history, size: 16, color: Color(0xFFFF9800)),
                SizedBox(width: 6),
                Text(
                  "${controller.history.length} points",
                  style: TextStyle(
                    color: isDark ? Colors.white : Color(0xFF1A1A1A),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}