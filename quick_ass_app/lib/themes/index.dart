import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: Colors.transparent,
    iconTheme: const IconThemeData(
      color: Colors.white,
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(
          fontFamily: 'Instrument Serif',
          color: Colors.white,
          fontWeight: FontWeight.w400,
          fontSize: 46),
      titleMedium: TextStyle(
          fontFamily: 'Instrument Serif',
          color: Colors.white,
          fontWeight: FontWeight.w400,
          fontSize: 24),
      titleSmall: TextStyle(
          fontFamily: 'Manrope',
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 14),
      displaySmall: TextStyle(
          fontFamily: 'Manrope',
          color: Colors.black,
          fontWeight: FontWeight.w700,
          fontSize: 16),
      labelMedium: TextStyle(
          fontFamily: 'Space Mono',
          color: Colors.white,
          fontWeight: FontWeight.w400,
          fontSize: 20),
      bodyLarge: TextStyle(
          fontFamily: 'Manrope',
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 36),
      bodyMedium: TextStyle(
          fontFamily: 'Manrope',
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontSize: 16),
      bodySmall: TextStyle(
          fontFamily: 'Manrope',
          color: Colors.white,
          fontWeight: FontWeight.w400,
          fontSize: 14),
    ),
  );

  static double letterSpacing(letterSpacingPercentage, fontSize) {
    return (letterSpacingPercentage / 100) * fontSize;
  }
}
