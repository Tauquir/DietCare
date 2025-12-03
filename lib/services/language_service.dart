import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageService extends ChangeNotifier {
  static const String _languageKey = 'selected_language';
  static LanguageService? _instance;
  
  Locale _currentLocale = const Locale('en', 'US');
  bool _isRTL = false;

  Locale get currentLocale => _currentLocale;
  bool get isRTL => _isRTL;
  String get currentLanguage => _currentLocale.languageCode == 'ar' ? 'Arabic' : 'English';

  LanguageService._internal() {
    loadLanguage();
  }

  factory LanguageService() {
    _instance ??= LanguageService._internal();
    return _instance!;
  }

  Future<void> loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString(_languageKey) ?? 'en';
    setLanguage(languageCode == 'ar' ? 'Arabic' : 'English');
  }

  Future<void> setLanguage(String language) async {
    final prefs = await SharedPreferences.getInstance();
    
    if (language == 'Arabic') {
      _currentLocale = const Locale('ar', 'SA');
      _isRTL = true;
      await prefs.setString(_languageKey, 'ar');
    } else {
      _currentLocale = const Locale('en', 'US');
      _isRTL = false;
      await prefs.setString(_languageKey, 'en');
    }
    
    notifyListeners();
  }
}

