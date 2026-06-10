# GoldPriceTracker - Comprehensive Gold Price Tracking App

A complete, production-ready, cross-platform mobile application built with Flutter for tracking real-time gold prices. Supports all currencies, gold purities (karats), and weight units.

## 📱 Features

### Core Features
- **Live Gold Prices**: Real-time gold price fetching via RESTful API
- **Multi-Currency Support**: Display prices in any global currency (USD, EUR, SAR, AED, EGP, etc.)
- **Gold Purities**: Calculate prices for all karats (24K, 22K, 21K, 18K, 14K, 12K, 10K)
- **Weight Units**: View prices per Gram, Ounce (Troy), Kilogram, and Tola
- **Calculator/Converter**: Calculate exact prices for custom weights, karats, and currencies
- **Historical Charts**: Visualize gold price trends (7 days, 1 month, 1 year)
- **Dark/Light Theme**: User-selectable themes with persistent preferences

### Technical Features
- Clean Architecture with separation of concerns
- Riverpod for reactive state management
- Dio for robust API networking with error handling
- SharedPreferences for local storage
- Modular and maintainable codebase

## 🏗️ Architecture

The app follows **Clean Architecture** principles with three main layers:

```
lib/
├── models/          # Data classes with JSON serialization
├── services/        # API integration and data fetching
├── providers/       # State management (Riverpod)
├── screens/         # UI screens
├── widgets/         # Reusable UI components
└── utils/           # Constants, helpers, extensions
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (Latest stable version)
- Dart SDK (≥3.5.0)
- An API key from [GoldAPI.io](https://www.goldapi.io/) or [MetalpriceAPI](https://metalpriceapi.com/)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd gold_price_tracker
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure API Key**
   
   Open `lib/services/gold_api_service.dart` and replace the mock API key:
   ```dart
   static const String _apiKey = 'YOUR_API_KEY_HERE'; // Replace with your actual API key
   ```
   
   For production, consider using environment variables or a secure configuration file.

4. **Run the app**
   ```bash
   flutter run
   ```

## 📁 Project Structure

```
gold_price_tracker/
├── lib/
│   ├── main.dart                 # App entry point
│   ├── models/
│   │   ├── gold_price_model.dart     # Gold price data model
│   │   ├── currency_model.dart       # Currency data model
│   │   └── historical_data_model.dart # Historical price data
│   ├── services/
│   │   ├── gold_api_service.dart     # API integration
│   │   └── storage_service.dart      # Local storage
│   ├── providers/
│   │   ├── gold_price_provider.dart  # State management for prices
│   │   ├── settings_provider.dart    # User preferences
│   │   └── calculator_provider.dart  # Calculator logic
│   ├── screens/
│   │   ├── home_screen.dart          # Main dashboard
│   │   ├── calculator_screen.dart    # Price calculator
│   │   ├── charts_screen.dart        # Historical charts
│   │   └── settings_screen.dart      # App settings
│   ├── widgets/
│   │   ├── price_card.dart           # Price display card
│   │   ├── currency_dropdown.dart    # Currency selector
│   │   ├── karat_selector.dart       # Karat selection widget
│   │   ├── weight_selector.dart      # Weight unit selector
│   │   └── price_chart.dart          # Chart widget
│   └── utils/
│       ├── constants.dart            # App constants
│       ├── api_config.dart           # API configuration
│       └── formatters.dart           # Number/currency formatters
├── test/                             # Unit and widget tests
├── pubspec.yaml                      # Dependencies
└── README.md                         # This file
```

## 🔑 API Configuration

### Supported APIs

This app is designed to work with:
- **GoldAPI.io** (Recommended)
- **MetalpriceAPI**
- **GoldRates.IO**

### Getting an API Key

1. Visit [GoldAPI.io](https://www.goldapi.io/)
2. Sign up for a free account
3. Get your API key from the dashboard
4. Replace the mock key in `lib/services/gold_api_service.dart`

### API Endpoints Used

```
GET /prices/{currency}     - Get current gold prices in specified currency
GET /historical/{date}     - Get historical prices for a specific date
GET /convert               - Convert between weights and karats
```

## 🎨 Customization

### Adding New Currencies

Edit `lib/utils/constants.dart`:
```dart
static const List<CurrencyData> supportedCurrencies = [
  CurrencyData(code: 'USD', symbol: '\$', name: 'US Dollar'),
  CurrencyData(code: 'EUR', symbol: '€', name: 'Euro'),
  // Add your currency here
];
```

### Changing Default Settings

Modify default values in `lib/providers/settings_provider.dart`:
```dart
static const String defaultCurrency = 'USD';
static const String defaultWeightUnit = 'gram';
static const int defaultKarat = 24;
```

## 🧪 Testing

Run tests:
```bash
flutter test
```

Run with coverage:
```bash
flutter test --coverage
```

## 📦 Building for Production

### Android

```bash
flutter build apk --release
# or for App Bundle
flutter build appbundle --release
```

### iOS

```bash
flutter build ios --release
```

**Note**: Ensure you have proper signing certificates and provisioning profiles configured in Xcode.

## 🐛 Error Handling

The app includes comprehensive error handling for:
- No internet connection
- API rate limit exceeded
- Invalid API key
- Timeout errors
- Server errors

Users see friendly error messages with retry options.

## 📊 State Management

Using **Riverpod** for:
- Reactive UI updates
- Efficient caching
- Easy testing
- Separation of business logic from UI

## 💾 Local Storage

SharedPreferences stores:
- Preferred currency
- Default weight unit
- Default karat
- Theme preference (dark/light)

## 🌙 Theming

The app supports both dark and light themes:
- Automatic system theme detection
- Manual theme toggle in settings
- Persistent theme preference

## 📈 Future Enhancements

- [ ] Price alerts and notifications
- [ ] Multiple watchlist items
- [ ] Silver and platinum prices
- [ ] Offline mode with cached data
- [ ] Multi-language support
- [ ] Biometric authentication
- [ ] Export data to CSV/PDF

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 👨‍💻 Author

Built with ❤️ using Flutter

## 🆘 Support

For issues and questions:
- Create an issue on GitHub
- Check existing documentation
- Review API provider documentation

---

**Made with Flutter 🚀**
