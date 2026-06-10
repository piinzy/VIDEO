import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/storage_service.dart';

/// Provider for app settings management
class SettingsNotifier extends StateNotifier<SettingsState> {
  final StorageService? _storage;
  
  SettingsNotifier(this._storage) : super(SettingsState(
    currency: _storage?.preferredCurrency ?? 'USD',
    weightUnit: _storage?.preferredWeightUnit ?? 'gram',
    karat: _storage?.preferredKarat ?? 24,
    themeMode: _storage?.themeMode ?? 0, // 0=system, 1=light, 2=dark
  ));
  
  /// Update preferred currency
  Future<void> setCurrency(String currency) async {
    state = state.copyWith(currency: currency);
    await _storage?.setPreferredCurrency(currency);
  }
  
  /// Update preferred weight unit
  Future<void> setWeightUnit(String unit) async {
    state = state.copyWith(weightUnit: unit);
    await _storage?.setPreferredWeightUnit(unit);
  }
  
  /// Update preferred karat
  Future<void> setKarat(int karat) async {
    state = state.copyWith(karat: karat);
    await _storage?.setPreferredKarat(karat);
  }
  
  /// Update theme mode (0=system, 1=light, 2=dark)
  Future<void> setThemeMode(int mode) async {
    state = state.copyWith(themeMode: mode);
    await _storage?.setThemeMode(mode);
  }
  
  /// Toggle between light and dark mode
  Future<void> toggleDarkMode() async {
    final newMode = state.themeMode == 2 ? 1 : 2;
    await setThemeMode(newMode);
  }
}

/// Provider for settings state
final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  // Try to get storage service from provider
  final storageRef = ref.watch(storageServiceProvider);
  StorageService? storage;
  
  if (storageRef.hasValue) {
    storage = storageRef.value;
  }
  
  return SettingsNotifier(storage);
});

/// Settings state model
class SettingsState {
  final String currency;
  final String weightUnit;
  final int karat;
  final int themeMode;
  
  const SettingsState({
    required this.currency,
    required this.weightUnit,
    required this.karat,
    required this.themeMode,
  });
  
  bool get isDarkMode => themeMode == 2;
  bool get isLightMode => themeMode == 1;
  bool get isSystemMode => themeMode == 0;
  
  SettingsState copyWith({
    String? currency,
    String? weightUnit,
    int? karat,
    int? themeMode,
  }) {
    return SettingsState(
      currency: currency ?? this.currency,
      weightUnit: weightUnit ?? this.weightUnit,
      karat: karat ?? this.karat,
      themeMode: themeMode ?? this.themeMode,
    );
  }
}

/// Provider for calculator state
class CalculatorNotifier extends StateNotifier<CalculatorState> {
  CalculatorNotifier() : super(const CalculatorState(
    weight: 1,
    karat: 24,
    weightUnitId: 'gram',
  ));
  
  /// Update weight value
  void setWeight(double weight) {
    state = state.copyWith(weight: weight);
  }
  
  /// Update karat
  void setKarat(int karat) {
    state = state.copyWith(karat: karat);
  }
  
  /// Update weight unit
  void setWeightUnit(String unitId) {
    state = state.copyWith(weightUnitId: unitId);
  }
  
  /// Reset to defaults
  void reset() {
    state = const CalculatorState(
      weight: 1,
      karat: 24,
      weightUnitId: 'gram',
    );
  }
}

/// Provider for calculator state
final calculatorProvider = StateNotifierProvider<CalculatorNotifier, CalculatorState>((ref) {
  return CalculatorNotifier();
});

/// Calculator state model
class CalculatorState {
  final double weight;
  final int karat;
  final String weightUnitId;
  
  const CalculatorState({
    required this.weight,
    required this.karat,
    required this.weightUnitId,
  });
  
  CalculatorState copyWith({
    double? weight,
    int? karat,
    String? weightUnitId,
  }) {
    return CalculatorState(
      weight: weight ?? this.weight,
      karat: karat ?? this.karat,
      weightUnitId: weightUnitId ?? this.weightUnitId,
    );
  }
}
