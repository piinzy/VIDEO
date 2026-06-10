import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/gold_price_model.dart';
import '../services/gold_api_service.dart';
import '../services/storage_service.dart';

/// Provider for the Gold API service
final goldApiServiceProvider = Provider<GoldApiService>((ref) {
  return GoldApiService();
});

/// Provider for the Storage service
final storageServiceProvider = FutureProvider<StorageService>((ref) {
  return StorageService.init();
});

/// State notifier for managing gold prices
class GoldPriceNotifier extends StateNotifier<AsyncValue<GoldPriceModel>> {
  final GoldApiService _apiService;
  String _currentCurrency;
  
  GoldPriceNotifier(this._apiService, String initialCurrency)
      : _currentCurrency = initialCurrency,
        super(const AsyncValue.loading()) {
    fetchPrices();
  }
  
  /// Get current currency
  String get currentCurrency => _currentCurrency;
  
  /// Fetch gold prices for current currency
  Future<void> fetchPrices() async {
    state = const AsyncValue.loading();
    
    try {
      final prices = await _apiService.getCurrentPrices(_currentCurrency);
      state = AsyncValue.data(prices);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
  
  /// Change currency and fetch new prices
  Future<void> changeCurrency(String currency) async {
    if (_currentCurrency == currency) return;
    
    _currentCurrency = currency;
    await fetchPrices();
  }
  
  /// Refresh prices
  Future<void> refresh() async {
    await fetchPrices();
  }
}

/// Provider for gold price state
final goldPriceProvider = StateNotifierProvider<GoldPriceNotifier, AsyncValue<GoldPriceModel>>((ref) {
  final apiService = ref.watch(goldApiServiceProvider);
  final storage = ref.watch(storageServiceProvider);
  
  // Use stored currency or default to USD
  String currency = 'USD';
  
  // Check if storage is ready
  if (storage.hasValue) {
    currency = storage.value!.preferredCurrency;
  }
  
  return GoldPriceNotifier(apiService, currency);
});

/// Provider for historical prices
class HistoricalPriceNotifier extends StateNotifier<AsyncValue<List<HistoricalDataPoint>>> {
  final GoldApiService _apiService;
  
  HistoricalPriceNotifier(this._apiService) : super(const AsyncValue.loading());
  
  /// Fetch historical data for specified period
  Future<void> fetchHistoricalData({
    required String currency,
    required int days,
  }) async {
    state = const AsyncValue.loading();
    
    try {
      final data = await _apiService.getHistoricalPrices(
        currency: currency,
        days: days,
      );
      state = AsyncValue.data(data);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}

/// Provider for historical price state
final historicalPriceProvider = StateNotifierProvider<HistoricalPriceNotifier, AsyncValue<List<HistoricalDataPoint>>>((ref) {
  final apiService = ref.watch(goldApiServiceProvider);
  return HistoricalPriceNotifier(apiService);
});

/// Provider for auto-refresh interval
final refreshIntervalProvider = StateProvider<Duration>((ref) {
  return const Duration(minutes: 1);
});
