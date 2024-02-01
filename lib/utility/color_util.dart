import 'package:flutter/material.dart';

class ColorUtil {

  static Color errorColor = Colors.red;
  static Color errorColor300 = Colors.red.shade300;
  static Color yellowColor300 = Colors.yellow.shade300;

 static bool isDarkMode( BuildContext context) {
     return Theme.of(context).brightness == Brightness.dark;
  }
}