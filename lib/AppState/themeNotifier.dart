import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeNotifier extends ChangeNotifier {
  bool _isDarkMode = false; // Default to light mode

  bool get isDarkMode => _isDarkMode;

  ThemeData get currentTheme => _isDarkMode ? darkTheme : lightTheme;

  Future<void> loadThemeFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ?? false; // Default to light mode
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _isDarkMode);
    notifyListeners();
  }

  ThemeData get lightTheme => ThemeData(
        brightness: Brightness.light,
        primaryColor: const Color(0xFFED1C24),
        primaryColorLight: const Color(0xFFED1C24),
        textTheme: GoogleFonts.poppinsTextTheme(
          ThemeData.light().textTheme,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFED1C24),
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFED1C24),
          brightness: Brightness.light,
        ).copyWith(
          surface: const Color(0xFFF5F6F6), // Surface color for light theme
          primary:
              const Color(0xFFED1C24), // Ensure primary color is set explicitly
          onSurface: Colors.black87, // Use dark text for contrast on surface
        ),
      );

  ThemeData get darkTheme => ThemeData(
        brightness: Brightness.dark,
        primaryColor:
            const Color(0xFF1A1A1A), // Set primary color for dark theme
        primaryColorDark: const Color(0xFFEEEEEE),
        textTheme: GoogleFonts.poppinsTextTheme(
          ThemeData.dark().textTheme,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1A1A1A),
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1A1A1A),
          brightness:
              Brightness.dark, // Ensure brightness is set for dark theme
        ).copyWith(
          surface:
              const Color(0xFF333333), // Customize surface color for dark mode
          primary: const Color(0xFFED1C24),
          onSurface: Colors.white, // Ensure text/icons are white for contrast
          secondary: const Color(
              0xFFED1C24), // Example of adding secondary color for accents
        ),
      );
}
