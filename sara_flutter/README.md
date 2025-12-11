# SARA Flutter - AI Government Services Assistant 🤖

<div align="center">
  <img src="https://img.shields.io/badge/Flutter-3.10.1+-02569B?style=for-the-badge&logo=flutter" />
  <img src="https://img.shields.io/badge/Dart-3.0+-0175C2?style=for-the-badge&logo=dart" />
  <img src="https://img.shields.io/badge/Riverpod-2.5+-00A67E?style=for-the-badge" />
  <img src="https://img.shields.io/badge/RTL_Support-✓-success?style=for-the-badge" />
</div>

<br />

**SARA Flutter** (السارا) is a high-performance, native mobile application designed to help Saudi citizens access government services through an intelligent conversational interface. Built with Flutter for superior performance and native feel, featuring advanced state management with Riverpod and full RTL support.

---

## ✨ Features

- 🤖 **AI Chat Assistant** - Powered by Groq API for intelligent responses
- 🎙️ **Voice Input** - Record and send voice messages with Whisper transcription
- 🔊 **Text-to-Speech** - Arabic TTS for AI responses
- 🏠 **Home Dashboard** - Quick overview of services, notifications, and OTP codes
- 📋 **Services Management** - Track and manage government services with search and filtering
- 🔐 **Safe Gate** - Secure OTP message management
- 👤 **User Profile** - Personal information and statistics
- 🌍 **RTL Support** - Full Arabic language support with right-to-left layout
- 🎨 **Modern UI** - Beautiful Material Design 3 with gradients and animations
- 📊 **Service Tracking** - Monitor active and expired services
- 🔔 **Notifications** - Stay updated with important alerts
- ⚡ **High Performance** - Native compilation for 60+ FPS
- 🔒 **Type Safety** - Freezed models for immutable, type-safe data

---

## 🚀 Quick Start

### Prerequisites
- Flutter SDK 3.10.1 or higher
- Dart SDK 3.0 or higher
- Android Studio / Xcode (for mobile development)
- VS Code or Android Studio (recommended IDEs)

### Installation

```bash
# Navigate to project directory
cd sara_flutter

# Get dependencies
flutter pub get

# Generate code for models and providers
flutter pub run build_runner build --delete-conflicting-outputs

# Run the app
flutter run
```

### Running on Specific Platforms

```bash
# iOS
flutter run -d ios

# Android
flutter run -d android

# Web
flutter run -d chrome

# List available devices
flutter devices
```

---

## 📱 Screens & Features

### Home Screen 🏠
- Modern dashboard with AI wave animation
- Quick stats cards for:
  - Active services overview
  - Critical notifications
  - Safe Gate OTP codes
- Quick access to chat with SARA
- Gradient cards with beautiful shadows
- Direct navigation to detailed screens

### Chat Screen 💬
- Real-time AI conversation with Groq
- Voice recording with Whisper transcription
- Text-to-speech for responses
- Beautiful chat bubbles with markdown support
- Loading indicators and empty states
- Auto-play toggle for TTS
- CTA (Call-to-Action) button extraction

### Services Screen 📋
- Comprehensive services list
- Real-time search functionality
- Filter by status:
  - All services
  - Active services
  - Expired services
- Service cards with:
  - Service name (Arabic & English)
  - Status badges
  - Expiry dates
  - Icons
- Empty state for no results

### Safe Gate Screen 🔐
- OTP message management
- ID verification flow
- Secure message display
- Filter and search capabilities

### Profile Screen 👤
- User information display
- Service statistics
- Notification overview
- Settings access
- User avatar with initials

### Voice Call Screen 📞
- Real-time voice conversation
- Connection state management
- Call duration tracking
- Audio controls

---

## 🎨 Design System

### Color Palette
```dart
Primary:    #0D7C66 (Teal)
Secondary:  #FFB800 (Yellow)
Accent:     #8B5CF6 (Purple)
Success:    #10B981 (Green)
Error:      #EF4444 (Red)
Warning:    #F59E0B (Orange)
Background: #F5F7FA (Light Gray)
```

### Typography
- **Font**: Tajawal (Google Fonts - Arabic-optimized)
- **Weights**: Regular (400), Bold (700)
- **RTL Support**: Full right-to-left layout
- **Text Styles**: Material Design 3 typography scale

### Components
- Gradient buttons with ripple effects
- Cards with elevation and rounded corners
- Smooth transitions and animations
- Touch feedback on all interactive elements
- Custom widgets for AI wave, chat bubbles, voice recorder

---

## 🏗️ Architecture

### Project Structure
```
sara_flutter/
├── lib/
│   ├── features/           # Feature modules
│   │   ├── home/          # Home screen
│   │   ├── chat/          # Chat interface
│   │   ├── services/      # Services management
│   │   ├── safe_gate/     # OTP management
│   │   ├── profile/       # User profile
│   │   ├── voice_call/    # Voice calling
│   │   ├── splash/        # Splash screen
│   │   └── onboarding/    # Onboarding flow
│   ├── core/              # Core functionality
│   │   ├── models/        # Data models (Freezed)
│   │   ├── services/      # API services
│   │   ├── providers/     # Riverpod providers
│   │   └── constants/     # Mock data & constants
│   ├── widgets/           # Reusable widgets
│   ├── config/            # App configuration
│   │   ├── theme/        # Theme & colors
│   │   └── routes/       # Navigation (GoRouter)
│   ├── app.dart          # App widget
│   └── main.dart         # Entry point
├── test/                  # Unit & widget tests
├── pubspec.yaml          # Dependencies
└── README.md             # This file
```

### Tech Stack

#### State Management
```yaml
flutter_riverpod: ^2.5.1        # State management
riverpod_annotation: ^2.3.5     # Code generation annotations
riverpod_generator: ^2.4.3      # Provider code generation
```

**Why Riverpod?**
- Type-safe and compile-time checked
- Better performance with selective rebuilds
- More maintainable for large apps
- Built-in dev tools support
- Testability out of the box

#### Navigation
```yaml
go_router: ^14.2.7              # Declarative routing
```

**Features:**
- Type-safe route definitions
- Deep linking support
- StatefulShellRoute for bottom navigation
- State preservation across routes
- Nested navigation support

#### Models & Serialization
```yaml
freezed: ^2.5.7                 # Immutable models
json_serializable: ^6.8.0       # JSON serialization
```

**Benefits:**
- Immutable data classes
- Union types and sealed classes
- Copy-with functionality
- Equality comparisons
- Pattern matching support

#### UI Components
```yaml
google_fonts: ^6.2.1            # Tajawal font
flutter_svg: ^2.0.10+1          # SVG support
lottie: ^3.1.2                  # Animations
shimmer: ^3.0.0                 # Loading effects
flutter_markdown: ^0.7.3+1      # Markdown rendering
```

#### Networking
```yaml
dio: ^5.7.0                     # HTTP client
http: ^1.2.2                    # HTTP requests
pretty_dio_logger: ^1.4.0       # Request logging
web_socket_channel: ^3.0.0      # WebSocket for voice
```

#### Audio
```yaml
flutter_sound: ^9.16.3          # Audio recording
audioplayers: ^6.1.0            # Audio playback
permission_handler: ^11.3.1     # Permissions
```

#### Storage & Utils
```yaml
shared_preferences: ^2.3.2      # Local storage
path_provider: ^2.1.4           # File paths
url_launcher: ^6.3.0            # URL handling
intl: ^0.20.2                   # Internationalization
```

---

## 🔧 Configuration

### API Keys

Create a `.env` file in the root directory (not committed to git):
```env
GROQ_API_KEY=your_groq_api_key_here
GROQ_CHAT_MODEL=mixtral-8x7b
WHISPER_MODEL=whisper-large-v3
```

Or configure in your service files directly during development.

### Build Configuration

#### Android
Edit `android/app/build.gradle`:
```gradle
android {
    compileSdkVersion 34
    minSdkVersion 21
    targetSdkVersion 34
}
```

#### iOS
Edit `ios/Podfile`:
```ruby
platform :ios, '12.0'
```

---

## 📚 Development Guide

### Code Generation

The app uses code generation for models and providers:

```bash
# One-time generation
flutter pub run build_runner build --delete-conflicting-outputs

# Watch mode (auto-regenerate on changes)
flutter pub run build_runner watch --delete-conflicting-outputs

# Clean and rebuild
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

### Creating New Models

1. Create a new file in `lib/core/models/`:

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'my_model.freezed.dart';
part 'my_model.g.dart';

@freezed
class MyModel with _$MyModel {
  const factory MyModel({
    required String id,
    required String name,
  }) = _MyModel;

  factory MyModel.fromJson(Map<String, dynamic> json) =>
      _$MyModelFromJson(json);
}
```

2. Run code generation:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Creating New Providers

1. Create a provider file in `lib/core/providers/`:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'my_provider.g.dart';

@riverpod
class MyNotifier extends _$MyNotifier {
  @override
  MyState build() {
    return MyState.initial();
  }

  void updateData(String data) {
    state = state.copyWith(data: data);
  }
}
```

2. Run code generation and use in widgets:
```dart
@override
Widget build(BuildContext context, WidgetRef ref) {
  final myState = ref.watch(myNotifierProvider);
  // Use state...
}
```

---

## 🧪 Testing

### Run Tests
```bash
# All tests
flutter test

# Specific test file
flutter test test/widget_test.dart

# With coverage
flutter test --coverage
```

### Code Analysis
```bash
# Analyze code
flutter analyze

# Fix formatting
dart format lib/ test/

# Check for issues
flutter analyze --fatal-infos
```

---

## 🚢 Build & Deployment

### Development Builds

```bash
# Debug build (default)
flutter run

# Profile build (for performance testing)
flutter run --profile

# Release build
flutter run --release
```

### Production Builds

#### Android (APK)
```bash
# Build APK
flutter build apk --release

# Build App Bundle (for Play Store)
flutter build appbundle --release
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

#### iOS (IPA)
```bash
# Build iOS app
flutter build ios --release

# Open Xcode for archiving
open ios/Runner.xcworkspace
```

Then use Xcode to create an archive and upload to App Store.

#### Web
```bash
# Build for web
flutter build web --release
```

Output: `build/web/`

---

## ⚠️ Important Notes

- **RTL Support**: The app is RTL-first (Arabic). Text direction is automatically handled by Flutter's Directionality widget
- **API Keys**: Never commit API keys to version control. Use environment variables or secure storage
- **Code Generation**: Run `build_runner` after modifying any `@freezed` or `@riverpod` annotated files
- **Hot Reload**: Use `r` in terminal for hot reload, `R` for hot restart during development
- **State Persistence**: Bottom navigation state is preserved using `StatefulShellRoute`
- **Type Safety**: All models use Freezed for immutability and type safety

---

## 🐛 Troubleshooting

### Build Runner Errors
```bash
# Clean build cache
flutter clean
flutter pub get
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

### Font Loading Issues
Ensure Google Fonts are properly loaded. Internet connection required for first run.

### Permission Issues (Audio/Microphone)
- **Android**: Add permissions in `AndroidManifest.xml`
- **iOS**: Add usage descriptions in `Info.plist`

### State Management Issues
If providers don't update:
1. Ensure you're using `ref.watch` for reactive updates
2. Check that state is properly copied with `copyWith`
3. Verify code generation is up to date

---

## 📈 Performance Tips

1. **Use const constructors** wherever possible
2. **Lazy load providers** with `autoDispose` modifier
3. **Optimize list rendering** with `ListView.builder`
4. **Use cached network images** for better performance
5. **Profile with DevTools** to identify bottlenecks
6. **Enable R8/ProGuard** for Android release builds

---

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Run tests and ensure code passes analysis
5. Commit your changes (`git commit -m 'Add amazing feature'`)
6. Push to the branch (`git push origin feature/amazing-feature`)
7. Open a Pull Request

### Code Style
- Follow [Effective Dart](https://dart.dev/guides/language/effective-dart) guidelines
- Use `dart format` before committing
- Ensure `flutter analyze` passes with no errors
- Write tests for new features

---

## 📄 License

MIT License - feel free to use this project for your own purposes.

---

## 👥 Team

Built with ❤️ for Saudi Arabia's digital transformation initiative.

---

## 🙏 Acknowledgments

- **Groq**: For providing the AI API
- **Flutter Team**: For the amazing framework
- **Riverpod**: For excellent state management
- **Saudi Arabia**: For the vision of digital transformation

---

## 📞 Support

For issues and questions:
- Create an issue on GitHub
- Check the Flutter documentation: https://flutter.dev/docs
- Review the Riverpod documentation: https://riverpod.dev

---

## 📖 Additional Documentation

- **[Flutter Official Docs](https://flutter.dev/docs)** - Complete Flutter documentation
- **[Riverpod Documentation](https://riverpod.dev)** - State management guide
- **[GoRouter Documentation](https://pub.dev/packages/go_router)** - Navigation setup
- **[Freezed Documentation](https://pub.dev/packages/freezed)** - Code generation guide

---

**Made with ❤️ in Saudi Arabia 🇸🇦**

*Last Updated: December 11, 2025*
