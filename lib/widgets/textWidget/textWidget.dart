import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextWidget{

  static Color getTextColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black;
  }

  static Widget h1(String text, Color color, BuildContext context) {
    return Text(text, style: GoogleFonts.poppins(
      color: color,
      fontSize: MediaQuery.of(context).size.width * 0.055,
      fontWeight: FontWeight.w600,
    ),);
  }

  static Widget h2(String text,Color color,BuildContext context){
    return Text(text,style: GoogleFonts.poppins(
      color: color,
      fontSize: MediaQuery.of(context).size.width * 0.055,
      fontWeight: FontWeight.w600,
    ),);
  }
  static Widget h3(String text,Color color,BuildContext context){
    return Text(text,style: GoogleFonts.poppins(
      color: color,
      fontSize: MediaQuery.of(context).size.width *0.045,
      fontWeight: FontWeight.w600,
    ),);
  }static Widget h4(String text,Color color,BuildContext context){
    return Text(text,style: GoogleFonts.poppins(
      color: color,
      fontSize: MediaQuery.of(context).size.width *0.035,
      fontWeight: FontWeight.w600,
    ),);
  }
}