import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/constants.dart';
import '../utils/formatters.dart';

/// Dropdown widget for selecting currency
class CurrencyDropdown extends StatelessWidget {
  final String selectedCurrency;
  final ValueChanged<String> onChanged;
  final Color? backgroundColor;
  final Color? textColor;
  final double? height;

  const CurrencyDropdown({
    super.key,
    required this.selectedCurrency,
    required this.onChanged,
    this.backgroundColor,
    this.textColor,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 50,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedCurrency,
          isExpanded: true,
          icon: Icon(
            Icons.arrow_drop_down,
            color: textColor ?? Colors.white,
          ),
          style: TextStyle(
            color: textColor ?? Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          dropdownColor: backgroundColor ?? Colors.grey[900],
          items: Currencies.all.map((currency) {
            return DropdownMenuItem<String>(
              value: currency.code,
              child: Row(
                children: [
                  Text(
                    currency.symbol,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 8),
                  Text(currency.code),
                ],
              ),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              onChanged(value);
            }
          },
        ),
      ),
    );
  }
}

/// Dropdown widget for selecting weight unit
class WeightUnitDropdown extends StatelessWidget {
  final String selectedUnit;
  final ValueChanged<String> onChanged;
  final Color? backgroundColor;
  final Color? textColor;

  const WeightUnitDropdown({
    super.key,
    required this.selectedUnit,
    required this.onChanged,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedUnit,
          isExpanded: true,
          icon: Icon(
            Icons.arrow_drop_down,
            color: textColor ?? Colors.white,
          ),
          style: TextStyle(
            color: textColor ?? Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          dropdownColor: backgroundColor ?? Colors.grey[900],
          items: WeightUnits.all.map((unit) {
            return DropdownMenuItem<String>(
              value: unit.id,
              child: Text(
                '${unit.name} (${unit.symbol})',
                style: TextStyle(color: textColor),
              ),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              onChanged(value);
            }
          },
        ),
      ),
    );
  }
}

/// Segmented button for selecting karat
class KaratSelector extends StatelessWidget {
  final int selectedKarat;
  final ValueChanged<int> onChanged;
  final bool isDarkMode;

  const KaratSelector({
    super.key,
    required this.selectedKarat,
    required this.onChanged,
    this.isDarkMode = true,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: Karats.all.map((karat) {
        final isSelected = selectedKarat == karat;
        return ChoiceChip(
          label: Text('$karatK'),
          selected: isSelected,
          onSelected: (selected) {
            if (selected) {
              onChanged(karat);
            }
          },
          selectedColor: isDarkMode ? Colors.amber : Colors.yellow[700],
          labelStyle: TextStyle(
            color: isSelected
                ? (isDarkMode ? Colors.black : Colors.white)
                : (isDarkMode ? Colors.white : Colors.black),
            fontWeight: FontWeight.bold,
          ),
          backgroundColor: isDarkMode
              ? Colors.grey[800]
              : Colors.grey[200],
        );
      }).toList(),
    );
  }
}

/// Card widget for displaying gold price
class PriceCard extends StatelessWidget {
  final String title;
  final double price;
  final String currency;
  final int karat;
  final double? changePercent;
  final IconData? icon;
  final VoidCallback? onTap;

  const PriceCard({
    super.key,
    required this.title,
    required this.price,
    required this.currency,
    required this.karat,
    this.changePercent,
    this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: isDarkMode
                  ? [
                      Colors.grey[900]!,
                      Colors.grey[850]!,
                    ]
                  : [
                      Colors.grey[50]!,
                      Colors.white,
                    ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      if (icon != null) ...[
                        Icon(
                          icon,
                          color: Colors.amber,
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 14,
                          color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  if (changePercent != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: changePercent! >= 0
                            ? Colors.green.withOpacity(0.2)
                            : Colors.red.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            changePercent! >= 0
                                ? Icons.trending_up
                                : Icons.trending_down,
                            color: changePercent! >= 0
                                ? Colors.green
                                : Colors.red,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            Formatters.formatPriceChange(
                              price * (1 + changePercent! / 100),
                              price,
                            ),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: changePercent! >= 0
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                Formatters.formatCurrency(price, currency),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'per gram • $karatK',
                style: TextStyle(
                  fontSize: 12,
                  color: isDarkMode ? Colors.grey[500] : Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Loading shimmer effect widget
class ShimmerLoading extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const ShimmerLoading({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: borderRadius ?? BorderRadius.circular(8),
      ),
    );
  }
}

/// Error display widget
class ErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const ErrorWidget({
    super.key,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red[300],
            ),
            const SizedBox(height: 16),
            Text(
              'Oops!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
