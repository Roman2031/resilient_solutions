

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kindomcall/core/constants/constants.dart';



final themeModeProvider = NotifierProvider<ThemeNotifier, ThemeMode>(
  ThemeNotifier.new,
);

class ThemeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    // default state
    final box = Hive.box(AppConstants.appSettingsBox);
    final themeIndex = box.get(
      AppConstants.themeMode,
      defaultValue: ThemeMode.system.index,
    );
    return ThemeMode.values[themeIndex];
  }

  Future<void> setTheme(ThemeMode mode) async {
    state = mode;
    final box = Hive.box(AppConstants.appSettingsBox);
    await box.put(AppConstants.themeMode, mode.index);
  }
}