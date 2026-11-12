import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppLanguage {
  english('en', 'English', false),
  kurdish('ku', '\u06A9\u0648\u0631\u062F\u06CC (\u0633\u06C6\u0631\u0627\u0646\u06CC)', true),
  arabic('ar', '\u0627\u0644\u0639\u0631\u0628\u064A\u0629', true);

  const AppLanguage(this.code, this.label, this.isRtl);
  final String code;
  final String label;
  final bool isRtl;
}

class LocaleProvider extends ChangeNotifier {
  static const String _key = 'app_language';
  static const String _chosenKey = 'language_chosen';

  SharedPreferences? _prefs;
  AppLanguage _language = AppLanguage.english;
  bool _hasChosenLanguage = false;
  bool _isInitializing = true;

  AppLanguage get language => _language;
  bool get hasChosenLanguage => _hasChosenLanguage;
  bool get isInitializing => _isInitializing;
  bool get isRtl => _language.isRtl;
  TextDirection get textDirection =>
      _language.isRtl ? TextDirection.rtl : TextDirection.ltr;

  Future<void> init() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      final saved = _prefs?.getString(_key);
      _hasChosenLanguage = _prefs?.getBool(_chosenKey) ?? false;
      for (final lang in AppLanguage.values) {
        if (lang.code == saved) _language = lang;
      }
    } catch (error) {
      debugPrint('LocaleProvider init error: $error');
    } finally {
      _isInitializing = false;
      notifyListeners();
    }
  }

  Future<void> setLanguage(AppLanguage lang) async {
    _language = lang;
    _hasChosenLanguage = true;
    notifyListeners();
    await _prefs?.setString(_key, lang.code);
    await _prefs?.setBool(_chosenKey, true);
  }
}
