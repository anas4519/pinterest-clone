import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinterest_clone/core/utils/slide_right_page_transition.dart';

class AppTheme {
  static const Color _pinterestRed = Color(0xFFE60023);
  static const Color _lightBackground = Color(0xFFFFFFFF);
  static const Color _darkBackground = Colors.black;
  static const Color _lightSurface = Color(0xFFF0F0F0);
  static const Color _darkSurface = Color(0xFF252525);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: _pinterestRed,
      scaffoldBackgroundColor: _lightBackground,

      colorScheme: const ColorScheme.light(
        primary: _pinterestRed,
        secondary: Colors.black,
        surface: _lightBackground,
        onSurface: Colors.black,
        surfaceContainerHighest: _lightSurface,
      ),

      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: _lightBackground,
        surfaceTintColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.black),
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: _pinterestRed,
          foregroundColor: Colors.white,
          shape: const StadiumBorder(),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
          elevation: 0,
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _lightSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 12,
        ),
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 16),
      ),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: _lightBackground,
        indicatorColor: Colors.transparent,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: Colors.black, size: 30);
          }
          return const IconThemeData(color: Colors.grey, size: 30);
        }),
      ),
      pageTransitionsTheme: PageTransitionsTheme(
        builders: {
          TargetPlatform.android: SlideRightPageTransitionsBuilder(),
          TargetPlatform.iOS: SlideRightPageTransitionsBuilder(),
        },
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: _pinterestRed,
      scaffoldBackgroundColor: _darkBackground,

      colorScheme: const ColorScheme.dark(
        primary: _pinterestRed,
        secondary: Colors.white,
        surface: _darkBackground,
        onSurface: Colors.white,
        surfaceContainerHighest: _darkSurface,
      ),

      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: _darkBackground,
        surfaceTintColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: _pinterestRed,
          foregroundColor: Colors.white,
          shape: const StadiumBorder(),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
          elevation: 0,
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _darkSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 12,
        ),
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 16),
      ),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: _darkBackground,
        indicatorColor: Colors.transparent,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: Colors.white, size: 30);
          }
          return const IconThemeData(color: Colors.grey, size: 30);
        }),
      ),
      pageTransitionsTheme: PageTransitionsTheme(
        builders: {
          TargetPlatform.android: SlideRightPageTransitionsBuilder(),
          TargetPlatform.iOS: SlideRightPageTransitionsBuilder(),
        },
      ),
    );
  }
}
