# Flutter Commands Cheatsheet 🚀

## 🔧 Initial Setup

```bash
# Navigate to project
cd /home/basar/TradeNext/flutter_app

# Install dependencies
flutter pub get

# Generate code (JSON serialization, Riverpod)
flutter pub run build_runner build --delete-conflicting-outputs

# Check Flutter installation
flutter doctor

# Check available devices
flutter devices
```

## 🏃 Running the App

```bash
# Run on default device
flutter run

# Run on specific device
flutter run -d <device-id>

# Run in release mode
flutter run --release

# Run with hot reload enabled (default)
flutter run --hot

# Run in profile mode (for performance testing)
flutter run --profile
```

## 🔨 Build Commands

```bash
# Build Android APK (debug)
flutter build apk

# Build Android APK (release)
flutter build apk --release

# Build Android App Bundle (for Play Store)
flutter build appbundle --release

# Build iOS app
flutter build ios --release

# Build for web
flutter build web
```

## 🧹 Clean & Reset

```bash
# Clean build files
flutter clean

# Clean and reinstall
flutter clean && flutter pub get

# Clean build_runner cache
flutter pub run build_runner clean

# Full reset
flutter clean
rm -rf .dart_tool
rm -rf build
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

## 🔄 Code Generation

```bash
# Generate code (one-time)
flutter pub run build_runner build

# Generate code (delete conflicts)
flutter pub run build_runner build --delete-conflicting-outputs

# Watch for changes (continuous generation)
flutter pub run build_runner watch

# Clean and regenerate
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

## 📦 Package Management

```bash
# Get dependencies
flutter pub get

# Update dependencies
flutter pub upgrade

# Update specific package
flutter pub upgrade <package_name>

# Analyze dependencies
flutter pub outdated

# Add new package
flutter pub add <package_name>

# Remove package
flutter pub remove <package_name>
```

## 🧪 Testing Commands

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/unit/auth_test.dart

# Run tests with coverage
flutter test --coverage

# View coverage report
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

## 🔍 Analysis & Linting

```bash
# Analyze code
flutter analyze

# Fix lint issues automatically
dart fix --apply

# Format all Dart files
dart format .

# Format specific file
dart format lib/main.dart
```

## 📱 Device Management

```bash
# List all devices
flutter devices

# List emulators
flutter emulators

# Launch specific emulator
flutter emulators --launch <emulator_id>

# Create new emulator (Android)
flutter emulators --create
```

## 🐛 Debugging

```bash
# Run with verbose logging
flutter run -v

# Attach to running app
flutter attach

# Take screenshot
flutter screenshot

# Open DevTools
flutter pub global activate devtools
flutter pub global run devtools
```

## 📊 Performance

```bash
# Run with performance overlay
flutter run --profile

# Trace app startup
flutter run --trace-startup --profile

# Analyze performance
flutter analyze --watch
```

## 🌐 Web Development

```bash
# Run on Chrome
flutter run -d chrome

# Run on web server
flutter run -d web-server

# Build for web
flutter build web

# Serve web build
cd build/web
python -m http.server 8000
```

## 🔐 Platform Specific

### Android
```bash
# Open Android folder in Android Studio
open -a "Android Studio" android/

# Clean Android build
cd android
./gradlew clean
cd ..

# Build Android APK
flutter build apk --split-per-abi
```

### iOS
```bash
# Open iOS folder in Xcode
open ios/Runner.xcworkspace

# Clean iOS build
cd ios
rm -rf Pods
rm Podfile.lock
pod install
cd ..

# Update pods
cd ios
pod repo update
pod install
cd ..
```

## 🚀 Deployment

### Android
```bash
# Generate keystore
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload

# Build signed APK
flutter build apk --release

# Build App Bundle
flutter build appbundle --release

# Install on device
flutter install
```

### iOS
```bash
# Build iOS
flutter build ios --release

# Create IPA
flutter build ipa

# Upload to TestFlight
# (Use Xcode or Transporter app)
```

## 🎨 Asset Generation

```bash
# Generate app icons
flutter pub run flutter_launcher_icons

# Generate splash screens
flutter pub run flutter_native_splash:create
```

## 📝 Useful Shortcuts (While Running)

```
r - Hot reload
R - Hot restart
h - Help (list all shortcuts)
d - Detach (keep app running)
q - Quit
s - Save screenshot
w - Debug widget hierarchy
t - Toggle platform (iOS/Android)
L - Dump layer tree
S - Dump accessibility tree
i - Toggle widget inspector
p - Toggle debug paint
P - Toggle performance overlay
o - Toggle platform brightness
```

## 🔥 Quick Development Workflow

```bash
# 1. Start with clean state
flutter clean && flutter pub get

# 2. Generate code
flutter pub run build_runner build --delete-conflicting-outputs

# 3. Run app
flutter run

# 4. Make changes (hot reload automatically)

# 5. If needed, hot restart
# Press 'R' in terminal

# 6. If still issues, restart
# Press 'q' to quit
# Run 'flutter run' again
```

## 🐛 Troubleshooting Commands

```bash
# Fix build issues
flutter clean
flutter pub get
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs

# Reset Android build
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get

# Fix iOS pods
cd ios
rm -rf Pods
rm Podfile.lock
pod install
cd ..

# Clear app data (Android)
adb uninstall com.example.tradenest

# View logs
flutter logs

# Clear cache
flutter pub cache repair
```

## 📱 Specific to This Project

```bash
# Update API URL
# Edit lib/config/constants.dart

# Regenerate models after changes
flutter pub run build_runner build --delete-conflicting-outputs

# Run with specific device and API
flutter run -d <device-id>

# Test login flow
# Register: test@example.com / password123
# Login with same credentials
```

## 🎯 Production Build Checklist

```bash
# 1. Update version in pubspec.yaml
# version: 1.0.1+2

# 2. Clean everything
flutter clean

# 3. Get dependencies
flutter pub get

# 4. Analyze code
flutter analyze

# 5. Run tests
flutter test

# 6. Build release
flutter build apk --release

# 7. Test release build
flutter install --release

# 8. Generate release notes
# Update CHANGELOG.md

# 9. Distribute
# Upload to Play Store / TestFlight
```

## 💡 Pro Tips

```bash
# Run in background
flutter run &

# Check app size
flutter build apk --analyze-size

# Compare size between releases
flutter build apk --analyze-size --target-platform android-arm64

# Profile memory usage
flutter run --profile --trace-skia

# Check dependencies tree
flutter pub deps

# Find unused packages
flutter pub deps --style=compact

# Update all packages to latest
flutter pub upgrade --major-versions
```

## 🆘 Emergency Commands

```bash
# Nothing works? Nuclear option:
flutter clean
rm -rf .dart_tool
rm -rf build
rm -rf ios/Pods
rm -rf ios/Podfile.lock
rm -rf android/.gradle
flutter pub cache repair
flutter pub get
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
flutter doctor
flutter run
```

---

## 📚 More Resources

- Flutter Docs: https://flutter.dev/docs
- Dart Docs: https://dart.dev/guides
- Pub.dev: https://pub.dev

**Keep this file handy! 🚀**
