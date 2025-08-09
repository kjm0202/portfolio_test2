import 'package:flutter/material.dart';

class AppTheme {
  // Light theme colors
  static final lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF1565C0), // Medium blue
    onPrimary: Colors.white,
    secondary: Color(0xFF42A5F5), // Light blue
    onSecondary: Colors.white,
    tertiary: Color(0xFF0D47A1), // Dark blue
    onTertiary: Colors.white,
    surface: Color(0xFFF5F5F7),
    onSurface: Color(0xFF121212),
    error: Colors.red.shade800,
    onError: Colors.white,
  );

  // Dark theme colors
  static final darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFF42A5F5), // Light blue
    onPrimary: Colors.white,
    secondary: Color(0xFF1565C0), // Medium blue
    onSecondary: Colors.white,
    tertiary: Color(0xFF82B1FF), // Lighter blue accent
    onTertiary: Color(0xFF121212),
    surface: Color(0xFF242424),
    onSurface: Colors.white,
    error: Colors.red.shade300,
    onError: Colors.black,
  );

  // Light theme
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: lightColorScheme,
    scaffoldBackgroundColor: lightColorScheme.surface,
    fontFamily: 'PretendardVariable',
    textTheme: TextTheme(
      titleLarge: TextStyle(
        fontFamily: 'PretendardVariable',
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: lightColorScheme.onSurface,
      ),
      titleMedium: TextStyle(
        fontFamily: 'PretendardVariable',
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: lightColorScheme.onSurface,
      ),
      bodyLarge: TextStyle(
        fontFamily: 'PretendardVariable',
        fontSize: 16,
        height: 1.5,
        color: lightColorScheme.onSurface,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'PretendardVariable',
        fontSize: 14,
        height: 1.5,
        color: lightColorScheme.onSurface,
      ),
      labelLarge: TextStyle(
        fontFamily: 'PretendardVariable',
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: lightColorScheme.onPrimary,
      ),
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: lightColorScheme.onPrimary,
        backgroundColor: lightColorScheme.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: lightColorScheme.primary,
        side: BorderSide(color: lightColorScheme.primary, width: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: lightColorScheme.onSurface,
      elevation: 0,
    ),
    iconTheme: IconThemeData(color: lightColorScheme.primary, size: 24),
    chipTheme: ChipThemeData(
      backgroundColor: lightColorScheme.surface,
      labelStyle: TextStyle(
        color: lightColorScheme.onSurface,
        fontFamily: 'PretendardVariable',
        fontSize: 14,
        height: 1.2,
      ),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      side: BorderSide(
        color: lightColorScheme.secondary.withValues(alpha: 0.4),
        width: 1,
      ),
    ),
  );

  // Dark theme
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: darkColorScheme,
    scaffoldBackgroundColor: darkColorScheme.surface,
    fontFamily: 'PretendardVariable',
    textTheme: TextTheme(
      titleLarge: TextStyle(
        fontFamily: 'PretendardVariable',
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: darkColorScheme.onSurface,
      ),
      titleMedium: TextStyle(
        fontFamily: 'PretendardVariable',
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: darkColorScheme.onSurface,
      ),
      bodyLarge: TextStyle(
        fontFamily: 'PretendardVariable',
        fontSize: 16,
        height: 1.5,
        color: darkColorScheme.onSurface,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'PretendardVariable',
        fontSize: 14,
        height: 1.5,
        color: darkColorScheme.onSurface,
      ),
      labelLarge: TextStyle(
        fontFamily: 'PretendardVariable',
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: darkColorScheme.onPrimary,
      ),
    ),
    cardTheme: CardThemeData(
      color: Color(0xFF2F2F2F), // 메인 배경보다 밝은 회색
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: darkColorScheme.onPrimary,
        backgroundColor: darkColorScheme.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: darkColorScheme.primary,
        side: BorderSide(color: darkColorScheme.primary, width: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: darkColorScheme.surface,
      foregroundColor: darkColorScheme.onSurface,
      elevation: 0,
    ),
    iconTheme: IconThemeData(color: darkColorScheme.primary, size: 24),
    chipTheme: ChipThemeData(
      backgroundColor: darkColorScheme.primary.withValues(alpha: 0.2),
      labelStyle: TextStyle(
        color: darkColorScheme.onSurface,
        fontFamily: 'PretendardVariable',
        fontSize: 14,
        height: 1.2,
      ),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      side: BorderSide(
        color: darkColorScheme.primary.withValues(alpha: 0.5),
        width: 1,
      ),
    ),
  );
}
