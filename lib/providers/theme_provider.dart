import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  static const String _themeKey = 'theme_mode';
  late SharedPreferences _prefs;
  ThemeMode _themeMode = ThemeMode.system;
  bool _isAnimating = false;
  bool _isInitialized = false;

  ThemeProvider() {
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    await _loadThemePreference();
    _isInitialized = true;
    notifyListeners();
  }

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  bool get isAnimating => _isAnimating;

  Future<void> _loadThemePreference() async {
    final savedTheme = _prefs.getString(_themeKey);
    if (savedTheme != null) {
      _themeMode = ThemeMode.values.firstWhere(
        (mode) => mode.toString() == savedTheme,
        orElse: () => ThemeMode.system,
      );
      notifyListeners();
    }
  }

  Future<void> toggleTheme() async {
    _isAnimating = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 300));
    _themeMode = isDarkMode ? ThemeMode.light : ThemeMode.dark;
    
    // Tema tercihini kaydet
    await _prefs.setString(_themeKey, _themeMode.toString());
    
    await Future.delayed(const Duration(milliseconds: 300));
    _isAnimating = false;
    notifyListeners();
  }

  // Belirli bir tema modunu ayarlamak için
  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;

    _isAnimating = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 300));
    _themeMode = mode;
    
    // Tema tercihini kaydet
    await _prefs.setString(_themeKey, mode.toString());
    
    await Future.delayed(const Duration(milliseconds: 300));
    _isAnimating = false;
    notifyListeners();
  }
} 