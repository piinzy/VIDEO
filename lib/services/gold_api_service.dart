import 'package:dio/dio.dart';
import '../models/gold_price_model.dart';
import '../utils/constants.dart';

/// Service for fetching gold prices from external APIs
/// 
/// Supports GoldAPI.io and can be extended for other providers.
/// Uses mock data by default - replace API key to use live data.
class GoldApiService {
  final Dio _dio;
  
  // TODO: Replace with your actual API key from https://www.goldapi.io/
  static const String _apiKey = 'YOUR_API_KEY_HERE';
  
  GoldApiService() : _dio = Dio(BaseOptions(
    baseUrl: ApiConfig.baseUrl,
    connectTimeout: Duration(seconds: ApiConfig.connectionTimeout),
    receiveTimeout: Duration(seconds: ApiConfig.receiveTimeout),
    headers: {
      'x-access-token': _apiKey,
      'Content-Type': 'application/json',
    },
  ));

  /// Fetch current gold prices for a specific currency
  /// 
  /// Returns mock data if API key is not configured or on error
  Future<GoldPriceModel> getCurrentPrices(String currency) async {
    try {
      // Check if using mock API key
      if (_apiKey == 'YOUR_API_KEY_HERE' || _apiKey.isEmpty) {
        print('⚠️ Using mock data. Configure API key in gold_api_service.dart');
        return _getMockPrices(currency);
      }

      final response = await _dio.get('/${ApiConfig.endpointPrices}/$currency');
      
      if (response.statusCode == 200) {
        return GoldPriceModel.fromJson(response.data, currency);
      } else {
        throw ApiException('Failed to fetch prices: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('❌ API Error: ${_handleDioError(e)}');
      // Return mock data on error for demo purposes
      return _getMockPrices(currency);
    } catch (e) {
      print('❌ Unexpected error: $e');
      return _getMockPrices(currency);
    }
  }

  /// Fetch historical gold prices
  /// 
  /// [days] - Number of days of historical data to fetch
  Future<List<HistoricalDataPoint>> getHistoricalPrices({
    required String currency,
    required int days,
  }) async {
    try {
      // Check if using mock API key
      if (_apiKey == 'YOUR_API_KEY_HERE' || _apiKey.isEmpty) {
        return _getMockHistoricalData(days);
      }

      final List<HistoricalDataPoint> data = [];
      final endDate = DateTime.now();
      final startDate = endDate.subtract(Duration(days: days));
      
      // Fetch data for each day (GoldAPI.io requires individual date requests)
      for (int i = 0; i < days; i++) {
        final date = startDate.add(Duration(days: i));
        final dateStr = '${date.year}-${_pad(date.month)}-${_pad(date.day)}';
        
        try {
          final response = await _dio.get(
            '/${ApiConfig.endpointHistorical}/$dateStr',
            queryParameters: {'currency': currency},
          );
          
          if (response.statusCode == 200) {
            data.add(HistoricalDataPoint(
              date: date,
              price: (response.data['XAU'] as num).toDouble() / 31.1034768,
            ));
          }
        } catch (e) {
          // Skip failed requests
          continue;
        }
      }
      
      return data.isNotEmpty ? data : _getMockHistoricalData(days);
    } catch (e) {
      print('❌ Historical data error: $e');
      return _getMockHistoricalData(days);
    }
  }

  /// Convert gold price between different units and karats
  double convertPrice({
    required double amount,
    required int karat,
    required String weightUnitId,
    required GoldPriceModel basePrice,
  }) {
    final unit = WeightUnits.getById(weightUnitId);
    
    // Get base price per gram for selected karat
    double pricePerGram = basePrice.getPriceForKarat(karat);
    
    // Convert to selected weight unit
    return pricePerGram * unit.toGrams * amount;
  }

  /// Handle Dio errors and return user-friendly messages
  String _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timeout. Please check your internet connection.';
      case DioExceptionType.badResponse:
        switch (e.response?.statusCode) {
          case 401:
          case 403:
            return 'Invalid API key. Please configure your API key.';
          case 429:
            return 'API rate limit exceeded. Please try again later.';
          case 500:
            return 'Server error. Please try again later.';
          default:
            return 'Failed to fetch data. Status code: ${e.response?.statusCode}';
        }
      case DioExceptionType.cancel:
        return 'Request cancelled.';
      case DioExceptionType.connectionError:
        return 'No internet connection. Please check your network.';
      case DioExceptionType.unknown:
      case DioExceptionType.badCertificate:
      default:
        return 'An unexpected error occurred.';
    }
  }

  /// Generate mock prices for demo/testing
  GoldPriceModel _getMockPrices(String currency) {
    // Base price in USD per ounce
    double basePriceUSD = 2035.50;
    
    // Simple currency conversion rates (in real app, fetch live rates)
    final currencyRates = {
      'USD': 1.0,
      'EUR': 0.92,
      'GBP': 0.79,
      'SAR': 3.75,
      'AED': 3.67,
      'EGP': 47.85,
      'INR': 83.12,
      'PKR': 278.50,
      'BDT': 117.25,
      'CNY': 7.23,
      'JPY': 150.25,
      'KRW': 1345.80,
      'AUD': 1.53,
      'CAD': 1.36,
      'CHF': 0.88,
      'TRY': 32.15,
      'RUB': 92.50,
      'BRL': 5.05,
      'ZAR': 18.95,
      'MXN': 17.15,
      'SGD': 1.35,
      'HKD': 7.82,
      'NOK': 10.75,
      'SEK': 10.65,
      'DKK': 6.88,
      'PLN': 3.98,
      'THB': 36.25,
      'MYR': 4.72,
      'IDR': 15850.0,
      'PHP': 56.35,
      'VND': 24750.0,
      'KWD': 0.31,
      'QAR': 3.64,
      'OMR': 0.38,
      'BHD': 0.38,
      'JOD': 0.71,
      'LBP': 89500.0,
      'ILS': 3.72,
      'NZD': 1.65,
    };
    
    final rate = currencyRates[currency.toUpperCase()] ?? 1.0;
    final basePrice = basePriceUSD * rate;
    
    return GoldPriceModel.mock(currency, basePrice: basePrice);
  }

  /// Generate mock historical data
  List<HistoricalDataPoint> _getMockHistoricalData(int days) {
    final List<HistoricalDataPoint> data = [];
    final basePrice = 65.40; // Mock price per gram in USD
    final now = DateTime.now();
    
    for (int i = days; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      // Add realistic variation
      final variation = (basePrice * 0.03) * ((days - i) % 5 - 2) / 2;
      data.add(HistoricalDataPoint(
        date: date,
        price: basePrice + variation,
      ));
    }
    
    return data;
  }

  /// Pad number with leading zero
  String _pad(int value) {
    return value.toString().padLeft(2, '0');
  }
}

/// Custom exception for API errors
class ApiException implements Exception {
  final String message;
  ApiException(this.message);
  
  @override
  String toString() => 'ApiException: $message';
}
