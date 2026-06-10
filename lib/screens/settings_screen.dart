import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/settings_provider.dart';
import '../utils/constants.dart';
import '../widgets/custom_widgets.dart';

/// Settings screen for app configuration
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Preferences section
          _buildSectionTitle('Preferences', isDarkMode),
          Card(
            child: Column(
              children: [
                // Currency setting
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: const Icon(Icons.attach_money, color: Colors.white),
                  ),
                  title: const Text('Currency'),
                  subtitle: Text(Currencies.getByCode(settings.currency).name),
                  trailing: CurrencyDropdown(
                    selectedCurrency: settings.currency,
                    onChanged: (value) {
                      ref.read(settingsProvider.notifier).setCurrency(value);
                    },
                    height: 40,
                    backgroundColor: isDarkMode ? Colors.grey[800] : Colors.grey[100],
                    textColor: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
                const Divider(height: 1),
                
                // Weight unit setting
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.green,
                    child: const Icon(Icons.scale, color: Colors.white),
                  ),
                  title: const Text('Weight Unit'),
                  subtitle: Text(WeightUnits.getById(settings.weightUnit).name),
                  trailing: WeightUnitDropdown(
                    selectedUnit: settings.weightUnit,
                    onChanged: (value) {
                      ref.read(settingsProvider.notifier).setWeightUnit(value);
                    },
                    backgroundColor: isDarkMode ? Colors.grey[800] : Colors.grey[100],
                    textColor: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
                const Divider(height: 1),
                
                // Default karat setting
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.amber,
                    child: const Icon(Icons.star, color: Colors.white),
                  ),
                  title: const Text('Default Karat'),
                  subtitle: Text('${settings.karat}K Gold'),
                  trailing: DropdownButton<int>(
                    value: settings.karat,
                    underline: const SizedBox.shrink(),
                    items: Karats.all.map((karat) {
                      return DropdownMenuItem(
                        value: karat,
                        child: Text('$karatK'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        ref.read(settingsProvider.notifier).setKarat(value);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Appearance section
          _buildSectionTitle('Appearance', isDarkMode),
          Card(
            child: Column(
              children: [
                // Theme mode setting
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.purple,
                    child: const Icon(Icons.palette, color: Colors.white),
                  ),
                  title: const Text('Theme Mode'),
                  subtitle: Text(_getThemeModeText(settings.themeMode)),
                  trailing: SegmentedButton<int>(
                    segments: const [
                      ButtonSegment(value: 0, label: Text('Auto')),
                      ButtonSegment(value: 1, label: Icon(Icons.light_mode)),
                      ButtonSegment(value: 2, label: Icon(Icons.dark_mode)),
                    ],
                    selected: {settings.themeMode},
                    onSelectionChanged: (Set<int> selected) {
                      ref.read(settingsProvider.notifier).setThemeMode(selected.first);
                    },
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // About section
          _buildSectionTitle('About', isDarkMode),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.teal,
                    child: const Icon(Icons.info, color: Colors.white),
                  ),
                  title: const Text('App Version'),
                  subtitle: const Text('1.0.0'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.orange,
                    child: const Icon(Icons.code, color: Colors.white),
                  ),
                  title: const Text('API Status'),
                  subtitle: const Text('Mock Data (Configure API Key)'),
                  trailing: Icon(
                    Icons.warning,
                    color: Colors.orange[300],
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.red,
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  title: const Text('Clear All Data'),
                  subtitle: const Text('Reset all preferences to default'),
                  onTap: () {
                    _showClearDataDialog(context);
                  },
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Help section
          Card(
            color: isDarkMode ? Colors.blue[900] : Colors.blue[50],
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.help_outline, color: Colors.blue[isDarkMode ? 300 : 700]),
                      const SizedBox(width: 8),
                      Text(
                        'Need Help?',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'To use live gold prices, you need to configure your API key. '
                    'Open lib/services/gold_api_service.dart and replace the mock API key '
                    'with your actual key from GoldAPI.io',
                    style: TextStyle(
                      fontSize: 14,
                      color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () {
                      // Could open documentation or help page
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Visit https://www.goldapi.io/ to get your API key'),
                          duration: Duration(seconds: 4),
                        ),
                      );
                    },
                    child: const Text('Get API Key'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: isDarkMode ? Colors.white : Colors.black87,
        ),
      ),
    );
  }

  String _getThemeModeText(int mode) {
    switch (mode) {
      case 0:
        return 'System Default';
      case 1:
        return 'Light Mode';
      case 2:
        return 'Dark Mode';
      default:
        return 'System Default';
    }
  }

  void _showClearDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Data'),
        content: const Text(
          'Are you sure you want to reset all preferences to their default values? '
          'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await ref.read(settingsProvider.notifier).setCurrency('USD');
              await ref.read(settingsProvider.notifier).setWeightUnit('gram');
              await ref.read(settingsProvider.notifier).setKarat(24);
              await ref.read(settingsProvider.notifier).setThemeMode(0);
              
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('All preferences reset to default')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }
}
