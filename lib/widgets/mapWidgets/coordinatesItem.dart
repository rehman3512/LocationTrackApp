import 'package:flutter/material.dart';

class CoordinateItem extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final bool isDark;

  const CoordinateItem({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? Color(0xFF2C2C2C) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 14, color: color),
                SizedBox(width: 6),
                Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 6),
            SelectableText(
              value,
              style: TextStyle(
                color: isDark ? Colors.white : Color(0xFF1A1A1A),
                fontSize: 13,
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