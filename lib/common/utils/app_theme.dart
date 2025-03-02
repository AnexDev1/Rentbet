import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  // Base colors
  static const Color primaryColor = Color(0xFF000000);
  static const Color secondaryColor = Color(0xFF424242);
  static const Color accentColor = Color(0xFF212121);
  static const Color successColor = Color(0xFF4CAF50);
  static const Color errorColor = Color(0xFFB00020);

  // Light theme colors
  static const Color lightBackground = Colors.white;
  static const Color lightSurface = Colors.white;
  static const Color lightTextPrimary = Color(0xDE000000);
  static const Color lightTextSecondary = Color(0x99000000);

  // Dark theme colors
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkTextPrimary = Color(0xDEFFFFFF);
  static const Color darkTextSecondary = Color(0x99FFFFFF);

  // Get light theme
  static ThemeData get lightTheme {
    return _buildTheme(
      brightness: Brightness.light,
      background: lightBackground,
      surface: lightSurface,
      textPrimary: lightTextPrimary,
      textSecondary: lightTextSecondary,
    );
  }

  // Get dark theme
  static ThemeData get darkTheme {
    return _buildTheme(
      brightness: Brightness.dark,
      background: darkBackground,
      surface: darkSurface,
      textPrimary: darkTextPrimary,
      textSecondary: darkTextSecondary,
    );
  }

  // Common theme builder
  static ThemeData _buildTheme({
    required Brightness brightness,
    required Color background,
    required Color surface,
    required Color textPrimary,
    required Color textSecondary,
  }) {
    final isDark = brightness == Brightness.dark;
    final ColorScheme colorScheme = ColorScheme(
      brightness: brightness,
      primary: primaryColor,
      onPrimary: isDark ? darkTextPrimary : Colors.white,
      secondary: secondaryColor,
      onSecondary: isDark ? darkTextPrimary : Colors.white,
      error: errorColor,
      onError: Colors.white,
      background: background,
      onBackground: textPrimary,
      surface: surface,
      onSurface: textPrimary,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: background,

      // AppBar theme
      appBarTheme: AppBarTheme(
        backgroundColor: isDark ? darkSurface : primaryColor,
        foregroundColor: isDark ? darkTextPrimary : Colors.white,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        ),
      ),

      // Button themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: isDark ? darkTextPrimary : Colors.white,
          minimumSize: const Size(0, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: isDark ? darkTextPrimary : secondaryColor,
          minimumSize: const Size(0, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          side: BorderSide(color: isDark ? darkTextSecondary : secondaryColor),
        ),
      ),

      // Card theme
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: surface,
        margin: const EdgeInsets.all(8),
      ),

      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? Colors.grey[800] : Colors.grey[100],
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: primaryColor, width: 1),
        ),
        hintStyle: TextStyle(color: isDark ? darkTextSecondary.withOpacity(0.5) : lightTextSecondary.withOpacity(0.5)),
      ),

      // Text theme
      textTheme: _buildTextTheme(isDark ? darkTextPrimary : lightTextPrimary,
          isDark ? darkTextSecondary : lightTextSecondary),

      // Bottom navigation bar theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: primaryColor,
        unselectedItemColor: isDark ? darkTextSecondary : lightTextSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),

      // Dialog theme
      dialogTheme: DialogTheme(
        backgroundColor: surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  static TextTheme _buildTextTheme(Color primary, Color secondary) {
    return TextTheme(
      displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: primary),
      displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: primary),
      displaySmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: primary),
      headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primary),
      titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primary),
      titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: primary),
      bodyLarge: TextStyle(fontSize: 16, color: primary),
      bodyMedium: TextStyle(fontSize: 14, color: primary),
      labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: primary),
      bodySmall: TextStyle(fontSize: 12, color: secondary),
      labelSmall: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: secondary),
    );
  }
}