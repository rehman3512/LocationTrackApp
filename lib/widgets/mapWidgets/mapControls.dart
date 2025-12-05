import 'package:flutter/material.dart';

class MapControls extends StatelessWidget {
  final bool isDark;
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;
  final VoidCallback onMyLocation;

  const MapControls({
    super.key,
    required this.isDark,
    required this.onZoomIn,
    required this.onZoomOut,
    required this.onMyLocation,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 16,
      bottom: 200,
      child: Column(
        children: [
          controlButton(Icons.add, isDark, onZoomIn),
          SizedBox(height: 12),
          controlButton(Icons.remove, isDark, onZoomOut),
          SizedBox(height: 12),
          controlButton(Icons.my_location, isDark, onMyLocation),
        ],
      ),
    );
  }

  Widget controlButton(IconData icon, bool isDark, VoidCallback onTap) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: isDark ? Color(0xFF1E1E1E) : Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, size: 20),
        color: isDark ? Colors.white : Colors.black,
        onPressed: onTap,
      ),
    );
  }
}