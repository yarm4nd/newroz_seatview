import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Light / dark / system mode, remembered between app launches.
class ThemeProvider extends ChangeNotifier {
  static const String _key = 'theme_mode';

  SharedPreferences? _prefs;
  ThemeMode _mode = ThemeMode.system;

  ThemeMode get mode => _mode;

  Future<void> init() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      final saved = _prefs?.getString(_key);
      for (final mode in ThemeMode.values) {
        if (mode.name == saved) _mode = mode;
      }
    } catch (error) {
      debugPrint('ThemeProvider init error: $error');
    }
    notifyListeners();
  }

  Future<void> setMode(ThemeMode mode) async {
    _mode = mode;
    notifyListeners();
    await _prefs?.setString(_key, mode.name);
  }
}
