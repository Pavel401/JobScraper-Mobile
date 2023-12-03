import 'package:flutter/material.dart';

class ThemeModel {
  final ThemeData lightTheme;
  final ThemeData darkTheme;
  // final String themeSVG;
  final String themeName;
  ThemeModel({
    required this.lightTheme,
    required this.darkTheme,
    // required this.themeSVG,
    required this.themeName,
  });
}
