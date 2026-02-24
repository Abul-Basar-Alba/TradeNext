# 📱 Device Connection & Build Guide (বাংলায়)

## 🔌 আপনার Mobile Connect করুন

### ধাপ ১: Phone এ Developer Options চালু করুন

1. **Settings** খুলুন
2. **About Phone** / **About Device** এ যান
3. **Build Number** খুঁজুন
4. **Build Number** এ **৭ বার tap** করুন
5. একটা message আসবে: "You are now a developer!"

### ধাপ ২: USB Debugging চালু করুন

1. **Settings** এ ফিরে যান
2. **Developer Options** / **উন্নত বৈশিষ্ট্য** খুঁজুন
3. **USB Debugging** চালু করুন
4. Confirmation এ **OK** দিন

### ধাপ ৩: Phone Computer এ Connect করুন

1. **USB-C cable** দিয়ে phone connect করুন
2. Phone এ একটা popup আসবে: **"Allow USB debugging?"**
3. **Always allow from this computer** চেক করুন
4. **Allow** / **OK** ক্লিক করুন

### ধাপ ৪: Connection Check করুন

Terminal এ run করুন:

```bash
# ADB devices চেক করুন:
adb devices

# Output এরকম আসবে:
# List of devices attached
# ABC123XYZ    device
```

**যদি "unauthorized" দেখায়:**
- Phone এ আবার popup আসবে
- "Allow" করুন

**যদি কোনো device না দেখায়:**
```bash
# ADB restart করুন:
adb kill-server
adb start-server
adb devices
```

### ধাপ ৫: Flutter Device Check করুন

```bash
cd /home/basar/TradeNext/flutter_app
flutter devices
```

**Output এরকম আসবে:**
```
2 connected devices:

SM G991B (mobile) • ABC123XYZ • android-arm64 • Android 13 (API 33)
Linux (desktop)   • linux     • linux-x64     • Linux
```

---

## 🚀 App Build ও Run করুন

### Option 1: Debug Mode এ Run করুন (দ্রুত testing)

```bash
cd /home/basar/TradeNext/flutter_app

# Dependencies install করুন:
flutter pub get

# Device এ run করুন:
flutter run

# অথবা specific device এ:
flutter run -d ABC123XYZ
```

### Option 2: Debug APK Build করুন

```bash
# APK build করুন:
flutter build apk --debug

# APK file পাবেন এখানে:
# build/app/outputs/flutter-apk/app-debug.apk

# Phone এ install করুন:
flutter install
```

### Option 3: Release APK Build করুন (Final)

```bash
# Release build করুন:
flutter build apk --release

# APK file location:
# build/app/outputs/flutter-apk/app-release.apk

# Size কমাতে split করুন:
flutter build apk --split-per-abi --release

# Files পাবেন:
# app-armeabi-v7a-release.apk
# app-arm64-v8a-release.apk
# app-x86_64-release.apk
```

---

## 📦 APK Phone এ Transfer করুন

### Method 1: ADB দিয়ে Install

```bash
cd /home/basar/TradeNext/flutter_app
flutter install
```

### Method 2: File Transfer

```bash
# APK কপি করুন Desktop এ:
cp build/app/outputs/flutter-apk/app-release.apk ~/Desktop/TradeNest.apk

# এখন phone এ:
# 1. USB cable দিয়ে connect করুন
# 2. File transfer mode enable করুন
# 3. Desktop/TradeNest.apk কপি করে phone এ পেস্ট করুন
# 4. Phone এ file manager দিয়ে খুলে install করুন
```

### Method 3: WhatsApp/Email

```bash
# WhatsApp বা Email এ নিজেকে পাঠান
# Phone এ ডাউনলোড করে install করুন
```

---

## 🐛 Common Problems & Solutions

### Problem 1: Device দেখাচ্ছে না

**Solution 1: USB Debugging চালু আছে কিনা check করুন**
```bash
# Settings > Developer Options > USB Debugging
```

**Solution 2: Cable check করুন**
- Data transfer support করে এমন cable use করুন
- Charging-only cable কাজ করবে না

**Solution 3: USB mode change করুন**
- Phone notification এ USB options দেখুন
- "File Transfer" / "MTP" mode select করুন

**Solution 4: ADB restart করুন**
```bash
adb kill-server
adb start-server
adb devices
```

**Solution 5: Phone restart করুন**
- Phone restart করুন
- আবার connect করুন

### Problem 2: "flutter: command not found"

**Solution:**
```bash
# Flutter path check করুন:
which flutter

# না থাকলে install করুন বা path add করুন
export PATH="$PATH:/path/to/flutter/bin"
```

### Problem 3: Build failed

**Solution:**
```bash
# Clean করুন:
flutter clean
flutter pub get

# আবার build করুন:
flutter build apk --debug
```

### Problem 4: "Gradle build failed"

**Solution:**
```bash
# Clean Gradle cache:
cd android
./gradlew clean
cd ..

# আবার try করুন:
flutter build apk
```

### Problem 5: APK install হচ্ছে না phone এ

**Solution 1: Unknown Sources চালু করুন**
```
Settings > Security > Install unknown apps > Enable
```

**Solution 2: Play Protect বন্ধ করুন temporarily**
```
Play Store > Settings > Play Protect > Turn off
```

---

## ⚡ Quick Commands

### শুধু Development/Testing এর জন্য:
```bash
cd /home/basar/TradeNext/flutter_app
flutter pub get
flutter run
```

### Release APK build করার জন্য:
```bash
cd /home/basar/TradeNext/flutter_app
flutter clean
flutter pub get
flutter build apk --release
```

### APK install করার জন্য:
```bash
flutter install
# অথবা
adb install build/app/outputs/flutter-apk/app-release.apk
```

---

## 📊 Build Size Optimization

### Normal Build:
```bash
flutter build apk --release
# Size: ~50-60 MB
```

### Split Build (Recommended):
```bash
flutter build apk --split-per-abi --release
# Size per file: ~20-25 MB
# আপনার phone এর architecture অনুযায়ী একটা install করুন
```

### Check Phone Architecture:
```bash
adb shell getprop ro.product.cpu.abi
# Output: arm64-v8a (সাধারণত এটাই)
```

---

## 🎯 Backend Connection Setup

### আপনার Computer এর IP খুঁজুন:

```bash
# Linux:
ifconfig | grep "inet "
# অথবা
ip addr show | grep "inet "

# Output এ আপনার local IP পাবেন:
# inet 192.168.1.100 ...
```

### Flutter App এ API URL update করুন:

File: `lib/config/constants.dart`

```dart
// Physical device এর জন্য:
static const String apiBaseUrl = 'http://192.168.1.100:5000/api';
static const String baseUrl = 'http://192.168.1.100:5000';
```

### Backend Server চালু করুন:

```bash
# Backend folder এ:
cd /path/to/your/backend
npm start

# Server চলছে কিনা check করুন:
# http://192.168.1.100:5000
```

### Same WiFi এ থাকতে হবে:
- Phone এবং Computer একই WiFi network এ থাকতে হবে
- না হলে API call কাজ করবে না

---

## ✅ Final Checklist

**Device Setup:**
- [ ] Developer Options চালু
- [ ] USB Debugging চালু
- [ ] USB cable ভালো মানের (data transfer support)
- [ ] Phone computer এ connected
- [ ] `adb devices` এ device দেখাচ্ছে
- [ ] `flutter devices` এ device দেখাচ্ছে

**Build Setup:**
- [ ] Flutter installed (`flutter --version`)
- [ ] Dependencies installed (`flutter pub get`)
- [ ] Backend server চালু আছে
- [ ] API URL update করা হয়েছে
- [ ] Phone ও computer same WiFi এ

**Build:**
- [ ] `flutter build apk --release` success
- [ ] APK file পাওয়া গেছে
- [ ] Phone এ install করা হয়েছে
- [ ] App খুলছে

---

## 🎉 Success!

যদি সব ঠিক থাকে:

1. ✅ Device connected
2. ✅ App build হয়েছে
3. ✅ Phone এ install হয়েছে
4. ✅ App খুলছে

**এখন app test করুন:**
- Register করুন
- Login করুন
- Products browse করুন

---

## 💡 Pro Tips

1. **Hot Reload**: `flutter run` করার পর code change করলে automatically update হবে
2. **Debug Mode**: Development এর সময় `flutter run` use করুন (দ্রুত)
3. **Release Mode**: Final APK share করার সময় `--release` use করুন
4. **Wireless Debugging**: USB cable ছাড়াই debug করা যায় (Advanced)

---

## 📞 এখনই করুন:

```bash
# 1. Phone connect করুন (USB debugging চালু করে)
# 2. এই commands run করুন:

cd /home/basar/TradeNext/flutter_app
adb devices                    # Device check
flutter devices                # Flutter device check
flutter pub get                # Dependencies install
flutter run                    # App run করুন!

# Device এ app খুলবে! 🎉
```

---

**সাফল্যের জন্য শুভকামনা! 🚀**
