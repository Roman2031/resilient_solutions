

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/app_colors.dart';

/// TextTheme Extension
extension TextThemingExtension on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme;
}

/// Theme Extension
extension AppThemeExtension on BuildContext {
  /// Check if current theme is dark mode
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  /// Container background color based on theme
  Color get containerColor =>
      isDarkMode ? AppColors.backgroundDark : AppColors.backgroundLight;

  /// Card background color based on theme
  Color get cardColor =>
      isDarkMode ? AppColors.surfaceDark : AppColors.surfaceLight;

  /// Chips background color based on theme
  Color get chipsColor => isDarkMode
      ? AppColors.surfaceDark.withValues(alpha: 0.7)
      : AppColors.surfaceLight.withValues(alpha: 0.5);

  /// Reverse background (dark -> white, light -> dark)
  Color get reverseBackground =>
      isDarkMode ? AppColors.backgroundLight : AppColors.backgroundDark;

  /// Reverse bottom nav icon (dark -> white, light -> dark)
  Color get bottomNavIconColor =>
      isDarkMode ? AppColors.backgroundLight : AppColors.unselectBottomNavIcon;

  /// Current theme's color scheme
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// primary color shortcut
  Color get primaryColor => AppColors.primaryColor;

  /// secondary color shortcut
  Color get secondaryColor => AppColors.secondaryColor;
}

/// Status Bar Extension
extension StatusBarExtension on BuildContext {
  void setStatusBarTheme() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        // transparent so body color shows
        statusBarColor: Colors.transparent,
        // Android: white icons
        statusBarIconBrightness: Brightness.light,
        // iOS: white icons
        statusBarBrightness: Brightness.light,
      ),
    );
  }
}