import 'package:intl/intl.dart';

/// Number and currency formatting utilities
class Formatters {
  /// Format a number as currency with symbol and proper decimal places
  static String formatCurrency(double amount, String currencyCode) {
    final currency = _getCurrencySymbol(currencyCode);
    final formatter = NumberFormat.currency(
      symbol: currency,
      decimalDigits: 2,
      customPattern: _getPatternForCurrency(currencyCode),
    );
    return formatter.format(amount);
  }

  /// Format price per gram with appropriate precision
  static String formatPricePerGram(double price, String currencyCode) {
    final currency = _getCurrencySymbol(currencyCode);
    return '$currency${price.toStringAsFixed(2)} / g';
  }

  /// Format weight with unit
  static String formatWeight(double weight, String unitSymbol) {
    if (weight == weight.toInt()) {
      return '${weight.toInt()} $unitSymbol';
    }
    return '${weight.toStringAsFixed(2)} $unitSymbol';
  }

  /// Format percentage
  static String formatPercentage(double percentage) {
    return '${percentage.toStringAsFixed(1)}%';
  }

  /// Format date for display
  static String formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  /// Format short date
  static String formatShortDate(DateTime date) {
    return DateFormat('MMM dd').format(date);
  }

  /// Get currency symbol from code
  static String _getCurrencySymbol(String code) {
    switch (code.toUpperCase()) {
      case 'USD':
        return '\$';
      case 'EUR':
        return '€';
      case 'GBP':
        return '£';
      case 'SAR':
        return '﷼';
      case 'AED':
        return 'د.إ';
      case 'EGP':
        return 'E£';
      case 'INR':
        return '₹';
      case 'PKR':
        return '₨';
      case 'BDT':
        return '৳';
      case 'CNY':
      case 'JPY':
        return '¥';
      case 'KRW':
        return '₩';
      case 'AUD':
        return 'A\$';
      case 'CAD':
        return 'C\$';
      case 'CHF':
        return 'Fr';
      case 'TRY':
        return '₺';
      case 'RUB':
        return '₽';
      case 'BRL':
        return 'R\$';
      case 'ZAR':
        return 'R';
      case 'SGD':
        return 'S\$';
      case 'HKD':
        return 'HK\$';
      case 'NZD':
        return 'NZ\$';
      case 'NOK':
      case 'SEK':
      case 'DKK':
        return 'kr';
      case 'PLN':
        return 'zł';
      case 'THB':
        return '฿';
      case 'MYR':
        return 'RM';
      case 'IDR':
        return 'Rp';
      case 'PHP':
        return '₱';
      case 'VND':
        return '₫';
      case 'KWD':
        return 'د.ك';
      case 'QAR':
        return 'ر.ق';
      case 'OMR':
        return 'ر.ع.';
      case 'BHD':
        return '.د.ب';
      case 'JOD':
        return 'د.ا';
      case 'LBP':
        return 'ل.ل';
      case 'ILS':
        return '₪';
      default:
        return '$code ';
    }
  }

  /// Get number pattern for specific currencies
  static String? _getPatternForCurrency(String code) {
    // Some currencies have different decimal conventions
    switch (code.toUpperCase()) {
      case 'JPY':
      case 'KRW':
        return '#,##0'; // No decimals for these currencies
      default:
        return null; // Use default pattern
    }
  }

  /// Calculate and format price change percentage
  static String formatPriceChange(double currentValue, double previousValue) {
    if (previousValue == 0) return '0.0%';
    
    final change = ((currentValue - previousValue) / previousValue) * 100;
    final sign = change >= 0 ? '+' : '';
    return '$sign${change.toStringAsFixed(2)}%';
  }

  /// Format large numbers with K, M, B suffixes
  static String formatCompactNumber(double number) {
    if (number >= 1e9) {
      return '${(number / 1e9).toStringAsFixed(1)}B';
    } else if (number >= 1e6) {
      return '${(number / 1e6).toStringAsFixed(1)}M';
    } else if (number >= 1e3) {
      return '${(number / 1e3).toStringAsFixed(1)}K';
    }
    return number.toStringAsFixed(2);
  }
}
