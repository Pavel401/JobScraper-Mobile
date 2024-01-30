import 'package:flutter/material.dart';

class ColorUtil {

  static Color errorColor = Colors.red;

 static bool isDarkMode( BuildContext context) {
     return Theme.of(context).brightness == Brightness.dark;
  }
}