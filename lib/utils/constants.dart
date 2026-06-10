/// API configuration constants for the GoldPriceTracker app.
/// 
/// Replace the API key with your actual key from GoldAPI.io or similar service.

class ApiConfig {
  // Base URL for GoldAPI.io
  static const String baseUrl = 'https://www.goldapi.io/api';
  
  // TODO: Replace with your actual API key from https://www.goldapi.io/
  static const String apiKey = 'YOUR_API_KEY_HERE';
  
  // API endpoints
  static const String endpointPrices = '/prices';
  static const String endpointHistorical = '/historical';
  static const String endpointConvert = '/convert';
  
  // Timeout configuration
  static const int connectionTimeout = 30; // seconds
  static const int receiveTimeout = 30; // seconds
  
  // Cache duration
  static const Duration cacheDuration = Duration(minutes: 5);
}

/// Supported currencies data model
class CurrencyData {
  final String code;
  final String symbol;
  final String name;
  
  const CurrencyData({
    required this.code,
    required this.symbol,
    required this.name,
  });
}

/// List of supported currencies
class Currencies {
  static const List<CurrencyData> all = [
    CurrencyData(code: 'USD', symbol: '\$', name: 'US Dollar'),
    CurrencyData(code: 'EUR', symbol: '€', name: 'Euro'),
    CurrencyData(code: 'GBP', symbol: '£', name: 'British Pound'),
    CurrencyData(code: 'SAR', symbol: '﷼', name: 'Saudi Riyal'),
    CurrencyData(code: 'AED', symbol: 'د.إ', name: 'UAE Dirham'),
    CurrencyData(code: 'EGP', symbol: 'E£', name: 'Egyptian Pound'),
    CurrencyData(code: 'INR', symbol: '₹', name: 'Indian Rupee'),
    CurrencyData(code: 'PKR', symbol: '₨', name: 'Pakistani Rupee'),
    CurrencyData(code: 'BDT', symbol: '৳', name: 'Bangladeshi Taka'),
    CurrencyData(code: 'CNY', symbol: '¥', name: 'Chinese Yuan'),
    CurrencyData(code: 'JPY', symbol: '¥', name: 'Japanese Yen'),
    CurrencyData(code: 'KRW', symbol: '₩', name: 'South Korean Won'),
    CurrencyData(code: 'AUD', symbol: 'A\$', name: 'Australian Dollar'),
    CurrencyData(code: 'CAD', symbol: 'C\$', name: 'Canadian Dollar'),
    CurrencyData(code: 'CHF', symbol: 'Fr', name: 'Swiss Franc'),
    CurrencyData(code: 'TRY', symbol: '₺', name: 'Turkish Lira'),
    CurrencyData(code: 'RUB', symbol: '₽', name: 'Russian Ruble'),
    CurrencyData(code: 'BRL', symbol: 'R\$', name: 'Brazilian Real'),
    CurrencyData(code: 'ZAR', symbol: 'R', name: 'South African Rand'),
    CurrencyData(code: 'MXN', symbol: '\$', name: 'Mexican Peso'),
    CurrencyData(code: 'SGD', symbol: 'S\$', name: 'Singapore Dollar'),
    CurrencyData(code: 'HKD', symbol: 'HK\$', name: 'Hong Kong Dollar'),
    CurrencyData(code: 'NOK', symbol: 'kr', name: 'Norwegian Krone'),
    CurrencyData(code: 'SEK', symbol: 'kr', name: 'Swedish Krona'),
    CurrencyData(code: 'DKK', symbol: 'kr', name: 'Danish Krone'),
    CurrencyData(code: 'PLN', symbol: 'zł', name: 'Polish Zloty'),
    CurrencyData(code: 'THB', symbol: '฿', name: 'Thai Baht'),
    CurrencyData(code: 'MYR', symbol: 'RM', name: 'Malaysian Ringgit'),
    CurrencyData(code: 'IDR', symbol: 'Rp', name: 'Indonesian Rupiah'),
    CurrencyData(code: 'PHP', symbol: '₱', name: 'Philippine Peso'),
    CurrencyData(code: 'VND', symbol: '₫', name: 'Vietnamese Dong'),
    CurrencyData(code: 'KWD', symbol: 'د.ك', name: 'Kuwaiti Dinar'),
    CurrencyData(code: 'QAR', symbol: 'ر.ق', name: 'Qatari Riyal'),
    CurrencyData(code: 'OMR', symbol: 'ر.ع.', name: 'Omani Rial'),
    CurrencyData(code: 'BHD', symbol: '.د.ب', name: 'Bahraini Dinar'),
    CurrencyData(code: 'JOD', symbol: 'د.ا', name: 'Jordanian Dinar'),
    CurrencyData(code: 'LBP', symbol: 'ل.ل', name: 'Lebanese Pound'),
    CurrencyData(code: 'ILS', symbol: '₪', name: 'Israeli Shekel'),
    CurrencyData(code: 'NZD', symbol: 'NZ\$', name: 'New Zealand Dollar'),
  ];
  
  static CurrencyData getByCode(String code) {
    return all.firstWhere(
      (c) => c.code == code,
      orElse: () => all.first, // Default to USD
    );
  }
}

/// Supported gold karats (purities)
class Karats {
  static const List<int> all = [24, 22, 21, 18, 14, 12, 10];
  
  /// Get purity percentage for a given karat
  static double getPurityPercentage(int karat) {
    return (karat / 24) * 100;
  }
  
  /// Calculate price for a specific karat based on 24K price
  static double calculatePrice(double price24k, int karat) {
    return price24k * (karat / 24);
  }
}

/// Supported weight units
class WeightUnit {
  final String id;
  final String name;
  final String symbol;
  final double toGrams; // Conversion factor to grams
  
  const WeightUnit({
    required this.id,
    required this.name,
    required this.symbol,
    required this.toGrams,
  });
}

class WeightUnits {
  static const WeightUnit gram = WeightUnit(
    id: 'gram',
    name: 'Gram',
    symbol: 'g',
    toGrams: 1.0,
  );
  
  static const WeightUnit kilogram = WeightUnit(
    id: 'kilogram',
    name: 'Kilogram',
    symbol: 'kg',
    toGrams: 1000.0,
  );
  
  static const WeightUnit troyOunce = WeightUnit(
    id: 'ounce',
    name: 'Troy Ounce',
    symbol: 'oz t',
    toGrams: 31.1034768,
  );
  
  static const WeightUnit tola = WeightUnit(
    id: 'tola',
    name: 'Tola',
    symbol: 'tola',
    toGrams: 11.6638,
  );
  
  static const List<WeightUnit> all = [
    gram,
    kilogram,
    troyOunce,
    tola,
  ];
  
  static WeightUnit getById(String id) {
    return all.firstWhere(
      (u) => u.id == id,
      orElse: () => gram,
    );
  }
  
  /// Convert price per gram to price in specified unit
  static double convertPrice(double pricePerGram, WeightUnit unit) {
    return pricePerGram * unit.toGrams;
  }
  
  /// Convert from one unit to another
  static double convert(double value, WeightUnit from, WeightUnit to) {
    final inGrams = value * from.toGrams;
    return inGrams / to.toGrams;
  }
}

/// Chart time periods
enum ChartPeriod {
  days7('7D', 7),
  month1('1M', 30),
  year1('1Y', 365);
  
  final String label;
  final int days;
  
  const ChartPeriod(this.label, this.days);
}
