import 'package:shared_preferences/shared_preferences.dart';

/// Service for managing local storage using SharedPreferences
class StorageService {
  static const String _keyCurrency = 'preferred_currency';
  static const String _keyWeightUnit = 'preferred_weight_unit';
  static const String _keyKarat = 'preferred_karat';
  static const String _keyThemeMode = 'theme_mode';
  
  final SharedPreferences _prefs;
  
  StorageService(this._prefs);
  
  /// Initialize the storage service
  static Future<StorageService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return StorageService(prefs);
  }
  
  // Currency preferences
  
  String get preferredCurrency {
    return _prefs.getString(_keyCurrency) ?? 'USD';
  }
  
  Future<void> setPreferredCurrency(String currency) async {
    await _prefs.setString(_keyCurrency, currency);
  }
  
  // Weight unit preferences
  
  String get preferredWeightUnit {
    return _prefs.getString(_keyWeightUnit) ?? 'gram';
  }
  
  Future<void> setPreferredWeightUnit(String unit) async {
    await _prefs.setString(_keyWeightUnit, unit);
  }
  
  // Karat preferences
  
  int get preferredKarat {
    return _prefs.getInt(_keyKarat) ?? 24;
  }
  
  Future<void> setPreferredKarat(int karat) async {
    await _prefs.setInt(_keyKarat, karat);
  }
  
  // Theme mode preferences
  // 0 = system, 1 = light, 2 = dark
  
  int get themeMode {
    return _prefs.getInt(_keyThemeMode) ?? 0;
  }
  
  Future<void> setThemeMode(int mode) async {
    await _prefs.setInt(_keyThemeMode, mode);
  }
  
  bool get isDarkMode {
    return themeMode == 2;
  }
  
  bool get isLightMode {
    return themeMode == 1;
  }
  
  bool get isSystemMode {
    return themeMode == 0;
  }
  
  // Clear all preferences
  
  Future<void> clearAll() async {
    await _prefs.clear();
  }
  
  // Remove specific preference
  
  Future<void> remove(String key) async {
    await _prefs.remove(key);
  }
  
  // Check if a key exists
  
  bool containsKey(String key) {
    return _prefs.containsKey(key);
  }
  
  // Get all keys
  
  List<String> getKeys() {
    return _prefs.getKeys().toList();
  }
}
