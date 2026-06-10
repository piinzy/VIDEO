import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/gold_price_provider.dart';
import '../providers/settings_provider.dart';
import '../utils/constants.dart';
import '../utils/formatters.dart';
import '../widgets/custom_widgets.dart';

/// Calculator screen for computing gold prices
class CalculatorScreen extends ConsumerStatefulWidget {
  const CalculatorScreen({super.key});

  @override
  ConsumerState<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends ConsumerState<CalculatorScreen> {
  final TextEditingController _weightController = TextEditingController(text: '1');
  int selectedKarat = 24;
  String selectedWeightUnit = 'gram';

  @override
  void dispose() {
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final goldPriceAsync = ref.watch(goldPriceProvider);
    final calculatorState = ref.watch(calculatorProvider);
    final settings = ref.watch(settingsProvider);

    // Sync with calculator provider
    if (_weightController.text != calculatorState.weight.toString()) {
      // Only update if different to avoid cursor jumps
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gold Calculator'),
        centerTitle: true,
      ),
      body: goldPriceAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => ErrorWidget(
          message: error.toString(),
          onRetry: () {
            ref.read(goldPriceProvider.notifier).refresh();
          },
        ),
        data: (goldPrice) => SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Input section
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Enter Weight',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Weight input
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: TextField(
                              controller: _weightController,
                              keyboardType: const TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                              decoration: InputDecoration(
                                labelText: 'Weight',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                prefixIcon: const Icon(Icons.scale),
                              ),
                              onChanged: (value) {
                                final weight = double.tryParse(value) ?? 0;
                                ref.read(calculatorProvider.notifier).setWeight(weight);
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 3,
                            child: WeightUnitDropdown(
                              selectedUnit: selectedWeightUnit,
                              onChanged: (value) {
                                setState(() => selectedWeightUnit = value);
                                ref.read(calculatorProvider.notifier).setWeightUnit(value);
                              },
                              backgroundColor: isDarkMode
                                  ? Colors.grey[800]
                                  : Colors.grey[100],
                              textColor: isDarkMode ? Colors.white : Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Karat selection
                      Text(
                        'Select Purity',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 12),
                      KaratSelector(
                        selectedKarat: selectedKarat,
                        onChanged: (karat) {
                          setState(() => selectedKarat = karat);
                          ref.read(calculatorProvider.notifier).setKarat(karat);
                        },
                        isDarkMode: isDarkMode,
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Results section
              Text(
                'Calculation Result',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              
              // Main result card
              _buildResultCard(
                goldPrice: goldPrice,
                currency: settings.currency,
                isDarkMode: isDarkMode,
              ),
              
              const SizedBox(height: 16),
              
              // Detailed breakdown
              _buildBreakdownCard(
                goldPrice: goldPrice,
                currency: settings.currency,
                isDarkMode: isDarkMode,
              ),
              
              const SizedBox(height: 24),
              
              // Quick calculations
              Text(
                'Quick Calculations',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              _buildQuickCalculations(goldPrice, selectedKarat, settings.currency),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultCard({
    required dynamic goldPrice,
    required String currency,
    required bool isDarkMode,
  }) {
    final weight = double.tryParse(_weightController.text) ?? 0;
    final unit = WeightUnits.getById(selectedWeightUnit);
    final pricePerGram = goldPrice.getPriceForKarat(selectedKarat);
    final totalPrice = pricePerGram * unit.toGrams * weight;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.amber.shade700,
            Colors.amber.shade900,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.amber.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            Icons.calculate,
            size: 48,
            color: Colors.white.withOpacity(0.9),
          ),
          const SizedBox(height: 16),
          Text(
            'Total Price',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            Formatters.formatCurrency(totalPrice, currency),
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$weight ${unit.symbol} of $selectedKaratK Gold',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBreakdownCard({
    required dynamic goldPrice,
    required String currency,
    required bool isDarkMode,
  }) {
    final weight = double.tryParse(_weightController.text) ?? 0;
    final unit = WeightUnits.getById(selectedWeightUnit);
    final pricePerGram = goldPrice.getPriceForKarat(selectedKarat);
    final priceInUnit = pricePerGram * unit.toGrams;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Price Breakdown',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
            const Divider(),
            _buildBreakdownRow(
              label: 'Price per gram ($selectedKaratK)',
              value: Formatters.formatCurrency(pricePerGram, currency),
              isDarkMode: isDarkMode,
            ),
            _buildBreakdownRow(
              label: 'Price per ${unit.symbol}',
              value: Formatters.formatCurrency(priceInUnit, currency),
              isDarkMode: isDarkMode,
            ),
            _buildBreakdownRow(
              label: 'Weight',
              value: '${weight} ${unit.symbol}',
              isDarkMode: isDarkMode,
            ),
            _buildBreakdownRow(
              label: 'Purity',
              value: '${Karats.getPurityPercentage(selectedKarat).toStringAsFixed(1)}% pure gold',
              isDarkMode: isDarkMode,
            ),
            const Divider(),
            _buildBreakdownRow(
              label: 'Total',
              value: Formatters.formatCurrency(priceInUnit * weight, currency),
              isBold: true,
              isDarkMode: isDarkMode,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBreakdownRow({
    required String label,
    required String value,
    bool isBold = false,
    required bool isDarkMode,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickCalculations(
    dynamic goldPrice,
    int karat,
    String currency,
  ) {
    final quickWeights = [
      {'label': '1 Gram', 'value': 1.0, 'unit': 'gram'},
      {'label': '10 Grams', 'value': 10.0, 'unit': 'gram'},
      {'label': '1 Tola', 'value': 1.0, 'unit': 'tola'},
      {'label': '1 Ounce', 'value': 1.0, 'unit': 'ounce'},
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: quickWeights.map((item) {
        final unit = WeightUnits.getById(item['unit'] as String);
        final value = item['value'] as double;
        final pricePerGram = goldPrice.getPriceForKarat(karat);
        final totalPrice = pricePerGram * unit.toGrams * value;

        return OutlinedButton(
          onPressed: () {
            setState(() {
              selectedWeightUnit = item['unit'] as String;
              _weightController.text = value.toString();
            });
            ref.read(calculatorProvider.notifier).setWeightUnit(item['unit'] as String);
            ref.read(calculatorProvider.notifier).setWeight(value);
          },
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Column(
            children: [
              Text(item['label'] as String),
              Text(
                Formatters.formatCurrency(totalPrice, currency),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
