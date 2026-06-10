import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/gold_price_provider.dart';
import '../providers/settings_provider.dart';
import '../utils/constants.dart';
import '../utils/formatters.dart';
import '../widgets/custom_widgets.dart';
import '../widgets/chart_widget.dart';

/// Home screen displaying current gold prices
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int selectedKarat = 24;
  String selectedWeightUnit = 'gram';

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final goldPriceAsync = ref.watch(goldPriceProvider);
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gold Price Tracker'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(goldPriceProvider.notifier).refresh();
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(goldPriceProvider.notifier).refresh();
        },
        child: goldPriceAsync.when(
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
                // Currency selector header
                _buildHeader(settings.currency),
                
                const SizedBox(height: 24),
                
                // Main price display
                _buildMainPriceCard(goldPrice, selectedKarat, settings.currency),
                
                const SizedBox(height: 24),
                
                // Karat selector
                Text(
                  'Select Purity',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                KaratSelector(
                  selectedKarat: selectedKarat,
                  onChanged: (karat) {
                    setState(() => selectedKarat = karat);
                    ref.read(settingsProvider.notifier).setKarat(karat);
                  },
                  isDarkMode: isDarkMode,
                ),
                
                const SizedBox(height: 24),
                
                // All karats grid
                Text(
                  'All Prices per Gram',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                _buildPricesGrid(goldPrice, settings.currency),
                
                const SizedBox(height: 24),
                
                // Weight unit conversion
                Text(
                  'Price by Weight',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                _buildWeightUnitsSection(goldPrice, selectedKarat, settings.currency),
                
                const SizedBox(height: 24),
                
                // Chart preview
                Text(
                  'Price Trend',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 250,
                  child: PriceChartWidget(currency: settings.currency),
                ),
                
                const SizedBox(height: 16),
                
                // Calculator button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, '/calculator');
                    },
                    icon: const Icon(Icons.calculate),
                    label: const Text('Open Calculator'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(String currency) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Live Gold Prices',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Updated just now',
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[400]
                    : Colors.grey[600],
              ),
            ),
          ],
        ),
        CurrencyDropdown(
          selectedCurrency: currency,
          onChanged: (value) {
            ref.read(settingsProvider.notifier).setCurrency(value);
            ref.read(goldPriceProvider.notifier).changeCurrency(value);
          },
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.grey[800]
              : Colors.grey[100],
          textColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : Colors.black87,
        ),
      ],
    );
  }

  Widget _buildMainPriceCard(
    dynamic goldPrice,
    int karat,
    String currency,
  ) {
    final price = goldPrice.getPriceForKarat(karat);
    
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
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.amber.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.account_balance, color: Colors.white, size: 28),
              const SizedBox(width: 8),
              Text(
                '$karatK Gold Price',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            Formatters.formatCurrency(price, currency),
            style: const TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'per gram',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          if (goldPrice.priceChangePercent != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: goldPrice.isPriceUp
                    ? Colors.green.withOpacity(0.3)
                    : Colors.red.withOpacity(0.3),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    goldPrice.isPriceUp
                        ? Icons.trending_up
                        : Icons.trending_down,
                    color: Colors.white,
                    size: 18,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    Formatters.formatPriceChange(
                      price * (1 + goldPrice.priceChangePercent! / 100),
                      price,
                    ),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'vs yesterday',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPricesGrid(dynamic goldPrice, String currency) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.5,
      ),
      itemCount: Karats.all.length,
      itemBuilder: (context, index) {
        final karat = Karats.all[index];
        final price = goldPrice.getPriceForKarat(karat);
        
        return PriceCard(
          title: '$karatK Gold',
          price: price,
          currency: currency,
          karat: karat,
          icon: Icons.show_chart,
          onTap: () {
            setState(() => selectedKarat = karat);
          },
        );
      },
    );
  }

  Widget _buildWeightUnitsSection(
    dynamic goldPrice,
    int karat,
    String currency,
  ) {
    return Column(
      children: WeightUnits.all.map((unit) {
        final pricePerGram = goldPrice.getPriceForKarat(karat);
        final priceInUnit = pricePerGram * unit.toGrams;
        
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.amber,
              child: Text(
                unit.symbol.split(' ').first,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            title: Text(unit.name),
            subtitle: Text('1 ${unit.symbol}'),
            trailing: Text(
              Formatters.formatCurrency(priceInUnit, currency),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
