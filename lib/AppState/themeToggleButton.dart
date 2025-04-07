import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'themeNotifier.dart';

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        return IconButton(
          icon: Icon(
            themeNotifier.isDarkMode ? Icons.dark_mode : Icons.light_mode,
          ),
          onPressed: () => themeNotifier.toggleTheme(),
        );
      },
    );
  }
}
