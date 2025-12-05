import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:locationapp/Widgets/ActionButtons/actionButtons.dart';
import 'package:locationapp/Widgets/HistoryCard/historyCard.dart';
import 'package:locationapp/Widgets/LocationCard/locationCard.dart';
import 'package:locationapp/controllers/locationController.dart';
import 'package:locationapp/controllers/themeController.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Color(0xFF121212) : Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [

            Container(
              padding: EdgeInsets.fromLTRB(20, 16, 20, 16),
              decoration: BoxDecoration(
                color: isDark ? Color(0xFF1F1F1F) : Colors.white,
                border: Border(
                  bottom: BorderSide(
                    color: isDark ? Color(0xFF2C2C2C) : Color(0xFFF0F0F0),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF2196F3),
                          Color(0xFF21CBF3),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.navigation_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Location Tracker",
                      style: TextStyle(
                        color: isDark ? Colors.white : Color(0xFF1A1A1A),
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Obx(() => IconButton(
                    onPressed: () => Get.find<ThemeController>().toggleTheme(),
                    icon: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: isDark ? Color(0xFF2C2C2C) : Color(0xFFF0F0F0),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Icon(
                          Get.find<ThemeController>().isDarkMode.value
                              ? Icons.light_mode_rounded
                              : Icons.dark_mode_rounded,
                          color: isDark ? Colors.white : Color(0xFF666666),
                          size: 22,
                        ),
                      ),
                    ),
                  )),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    LocationCard(),
                    SizedBox(height: 20),
                    ActionButtons(),
                    SizedBox(height: 20),
                    HistoryCard(),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}