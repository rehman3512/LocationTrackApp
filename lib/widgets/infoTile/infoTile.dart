import 'package:flutter/material.dart';
import 'package:locationapp/Widgets/AppColors/appColors.dart';
import 'package:locationapp/Widgets/TextWidget/textWidget.dart';

class InfoTile extends StatelessWidget {
  final String title;
  final String value;
  const InfoTile({super.key,required this.title,required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.symmetric(
      vertical: 0.6
    ),child: Row(
      children: [
        Expanded(flex: 2,child: TextWidget.h4("$title", AppColors.blackColor, context)),
        Expanded(flex: 3,child: TextWidget.h3("$value", AppColors.blackColor, context)),
      ],
    ),
    );
  }
}
