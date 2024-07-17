import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Font_Styles {
  
  static double _responsiveFontSize(BuildContext context, double size) {
    double scaleFactor = MediaQuery.of(context).size.width / 500.0;
    return size * scaleFactor;
  }

  static TextStyle largeHeadingBold(BuildContext context) {
    return TextStyle(
      fontSize: _responsiveFontSize(context, 40),
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle mediumHeadingBold(BuildContext context) {
    return TextStyle(
      fontSize: _responsiveFontSize(context, 35),
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle labelHeadingLight(BuildContext context) {
    return TextStyle(
      fontSize: _responsiveFontSize(context, 15),
      fontWeight: FontWeight.w400,
    );
  }

  static TextStyle labelHeadingRegular(BuildContext context) {
    return TextStyle(
      fontSize: _responsiveFontSize(context, 15),
      fontWeight: FontWeight.normal, 
    );
  }

  static TextStyle cardLabel(BuildContext context) {
    return TextStyle(
      fontSize: _responsiveFontSize(context, 25),
      fontWeight: FontWeight.w600, 
    );
  }
}
