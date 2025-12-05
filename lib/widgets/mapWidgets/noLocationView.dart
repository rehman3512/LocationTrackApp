import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NoLocationView extends StatelessWidget {
  final bool isDark;

  const NoLocationView({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isDark ? Color(0xFF121212) : Color(0xFFF8F9FA),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Color(0xFF2196F3).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.map_outlined, size: 60, color: Color(0xFF2196F3)),
            ),
            SizedBox(height: 24),
            Text(
              "No Location Data",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : Color(0xFF1A1A1A),
              ),
            ),
            SizedBox(height: 12),
            Text(
              "Enable location services to view map",
              style: TextStyle(color: Color(0xFF666666), fontSize: 14),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Get.back(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF2196F3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              ),
              child: Text(
                "Go Back",
                style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}