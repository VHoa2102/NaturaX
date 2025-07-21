import 'package:flutter/material.dart';

class Palette {
  static const MaterialColor primaryPaletteColor = MaterialColor(
    _primaryGreenValue, // Giá trị int của màu chính (sắc độ 500)
    <int, Color>{
      50: Color(0xFFE8F5E9),
      100: Color(0xFFC8E6C9),
      200: Color(0xFFA5D6A7),
      300: Color(0xFF81C784),
      400: Color(0xFF66BB6A),
      500: Color(_primaryGreenValue), // Sắc độ 500
      600: Color(0xFF43A047),
      700: Color(0xFF388E3C),
      800: Color(0xFF2E7D32),
      900: Color(0xFF1B5E20),
    },
  );

  static const int _primaryGreenValue = 0xFF4CAF50;
  static const Color accentGreen = Color(0xFF69F0AE);
  static const Color lightGreenBackground = Color(0xFFF1F8E9);
}
