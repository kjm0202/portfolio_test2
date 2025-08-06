import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
    background: Colors.white,
    onBackground: Color(0xFF121212),
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
    background: Color(0xFF121212),
    onBackground: Colors.white,
    surface: Color(0xFF242424),
    onSurface: Colors.white,
    error: Colors.red.shade300,
    onError: Colors.black,
  );

  // Light theme
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: lightColorScheme,
    scaffoldBackgroundColor: lightColorScheme.background,
    textTheme: GoogleFonts.poppinsTextTheme(
      ThemeData.light().textTheme,
    ).copyWith(
      titleLarge: GoogleFonts.poppins(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: lightColorScheme.onBackground,
      ),
      titleMedium: GoogleFonts.poppins(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: lightColorScheme.onBackground,
      ),
      bodyLarge: GoogleFonts.poppins(
        fontSize: 16,
        height: 1.5,
        color: lightColorScheme.onBackground,
      ),
      bodyMedium: GoogleFonts.poppins(
        fontSize: 14,
        height: 1.5,
        color: lightColorScheme.onBackground,
      ),
      labelLarge: GoogleFonts.poppins(
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
      foregroundColor: lightColorScheme.onBackground,
      elevation: 0,
    ),
    iconTheme: IconThemeData(color: lightColorScheme.primary, size: 24),
    chipTheme: ChipThemeData(
      backgroundColor: lightColorScheme.surface,
      labelStyle: TextStyle(color: lightColorScheme.onSurface),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
    ),
  );

  // Dark theme
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: darkColorScheme,
    scaffoldBackgroundColor: darkColorScheme.background,
    textTheme: GoogleFonts.poppinsTextTheme(
      ThemeData.dark().textTheme,
    ).copyWith(
      titleLarge: GoogleFonts.poppins(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: darkColorScheme.onBackground,
      ),
      titleMedium: GoogleFonts.poppins(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: darkColorScheme.onBackground,
      ),
      bodyLarge: GoogleFonts.poppins(
        fontSize: 16,
        height: 1.5,
        color: darkColorScheme.onBackground,
      ),
      bodyMedium: GoogleFonts.poppins(
        fontSize: 14,
        height: 1.5,
        color: darkColorScheme.onBackground,
      ),
      labelLarge: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: darkColorScheme.onPrimary,
      ),
    ),
    cardTheme: CardThemeData(
      color: darkColorScheme.surface,
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
      backgroundColor: darkColorScheme.primary.withOpacity(0.2),
      labelStyle: TextStyle(color: darkColorScheme.onSurface),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
    ),
  );
}
