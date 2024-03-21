import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData currentTheme = ThemeData.dark();

  static Color getColor(BuildContext context) {
    Brightness brightness = Theme.of(context).brightness;
    if (brightness == Brightness.dark) {
      return Colors.white;
    } else {
      return Colors.black;
    }
  }
}
