import 'package:flutter/material.dart';
import 'package:locationapp/Widgets/AppColors/appColors.dart';
import 'package:locationapp/Widgets/TextWidget/textWidget.dart';

class LoadingIndicator extends StatelessWidget {
  final String? label;
  const LoadingIndicator({super.key,this.label});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          if(label != null) SizedBox(height: 8,),
          if(label != null) TextWidget.h4(label!, AppColors.blackColor, context)
        ],
      ),
    );
  }
}
