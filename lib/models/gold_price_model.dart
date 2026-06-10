import 'package:equatable/equatable.dart';

/// Model representing gold prices for different metals and currencies
class GoldPriceModel extends Equatable {
  final double price24k;
  final double price22k;
  final double price21k;
  final double price18k;
  final double price14k;
  final double price12k;
  final double price10k;
  final String currency;
  final DateTime timestamp;
  final double? previousPrice; // For calculating change

  const GoldPriceModel({
    required this.price24k,
    required this.price22k,
    required this.price21k,
    required this.price18k,
    required this.price14k,
    required this.price12k,
    required this.price10k,
    required this.currency,
    required this.timestamp,
    this.previousPrice,
  });

  /// Get price for a specific karat
  double getPriceForKarat(int karat) {
    switch (karat) {
      case 24:
        return price24k;
      case 22:
        return price22k;
      case 21:
        return price21k;
      case 18:
        return price18k;
      case 14:
        return price14k;
      case 12:
        return price12k;
      case 10:
        return price10k;
      default:
        return price24k * (karat / 24);
    }
  }

  /// Calculate price change percentage
  double? get priceChangePercent {
    if (previousPrice == null || previousPrice! == 0) return null;
    return ((price24k - previousPrice!) / previousPrice!) * 100;
  }

  /// Check if price increased
  bool get isPriceUp => priceChangePercent != null && priceChangePercent! > 0;

  factory GoldPriceModel.fromJson(Map<String, dynamic> json, String currency) {
    // GoldAPI.io response format
    return GoldPriceModel(
      price24k: _parsePrice(json['XAU']),
      price22k: _parsePrice(json['XAU']) * (22 / 24),
      price21k: _parsePrice(json['XAU']) * (21 / 24),
      price18k: _parsePrice(json['XAU']) * (18 / 24),
      price14k: _parsePrice(json['XAU']) * (14 / 24),
      price12k: _parsePrice(json['XAU']) * (12 / 24),
      price10k: _parsePrice(json['XAU']) * (10 / 24),
      currency: currency,
      timestamp: DateTime.now(),
    );
  }

  static double _parsePrice(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  /// Create a mock price for testing/demo purposes
  factory GoldPriceModel.mock(String currency, {double basePrice = 2000}) {
    final pricePerOunce = basePrice;
    final pricePerGram = pricePerOunce / 31.1034768;
    
    return GoldPriceModel(
      price24k: pricePerGram,
      price22k: pricePerGram * (22 / 24),
      price21k: pricePerGram * (21 / 24),
      price18k: pricePerGram * (18 / 24),
      price14k: pricePerGram * (14 / 24),
      price12k: pricePerGram * (12 / 24),
      price10k: pricePerGram * (10 / 24),
      currency: currency,
      timestamp: DateTime.now(),
      previousPrice: pricePerGram * 0.995, // Slight increase for demo
    );
  }

  @override
  List<Object?> get props => [
        price24k,
        price22k,
        price21k,
        price18k,
        price14k,
        price12k,
        price10k,
        currency,
        timestamp,
        previousPrice,
      ];

  GoldPriceModel copyWith({
    double? price24k,
    double? price22k,
    double? price21k,
    double? price18k,
    double? price14k,
    double? price12k,
    double? price10k,
    String? currency,
    DateTime? timestamp,
    double? previousPrice,
  }) {
    return GoldPriceModel(
      price24k: price24k ?? this.price24k,
      price22k: price22k ?? this.price22k,
      price21k: price21k ?? this.price21k,
      price18k: price18k ?? this.price18k,
      price14k: price14k ?? this.price14k,
      price12k: price12k ?? this.price12k,
      price10k: price10k ?? this.price10k,
      currency: currency ?? this.currency,
      timestamp: timestamp ?? this.timestamp,
      previousPrice: previousPrice ?? this.previousPrice,
    );
  }
}

/// Model for historical price data point
class HistoricalDataPoint extends Equatable {
  final DateTime date;
  final double price;

  const HistoricalDataPoint({
    required this.date,
    required this.price,
  });

  factory HistoricalDataPoint.fromJson(Map<String, dynamic> json) {
    return HistoricalDataPoint(
      date: DateTime.parse(json['date'] as String),
      price: _parsePrice(json['price']),
    );
  }

  static double _parsePrice(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  /// Create mock historical data
  factory HistoricalDataPoint.mock(DateTime date, double basePrice) {
    // Add some random variation
    final variation = (basePrice * 0.02) * (DateTime.now().millisecondsSinceEpoch % 100 / 100 - 0.5);
    return HistoricalDataPoint(
      date: date,
      price: basePrice + variation,
    );
  }

  @override
  List<Object?> get props => [date, price];
}

/// Model for API response wrapper
class ApiResponse<T> extends Equatable {
  final T? data;
  final String? error;
  final bool isSuccess;

  const ApiResponse({
    this.data,
    this.error,
    required this.isSuccess,
  });

  factory ApiResponse.success(T data) {
    return ApiResponse(data: data, isSuccess: true);
  }

  factory ApiResponse.error(String error) {
    return ApiResponse(error: error, isSuccess: false);
  }

  @override
  List<Object?> get props => [data, error, isSuccess];
}
