import 'package:flutter/material.dart';

class AppTheme {
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF121312);
  static const Color primary = Color(0xFFFFBB3B);
  static const Color lightBlack = Color(0xFF1A1A1A);
  static const Color lightGray = Color(0xFFC6C6C6);
  static const Color gray = Color(0xFF514F4F);
  static const Color darkGray = Color(0xFF343534);

  static ThemeData lightTheme = ThemeData(
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: lightBlack,
      type: BottomNavigationBarType.fixed,
      showUnselectedLabels: false,
      showSelectedLabels: false,
      selectedItemColor: primary,
      unselectedItemColor: lightGray,
    ),
    appBarTheme: const AppBarTheme(
      titleTextStyle: TextStyle(color: white),
      color: lightBlack,
      centerTitle: true,
      iconTheme: IconThemeData(color: white),
    ),
  );
}
