# 🔥 Firebase Setup Guide - ধাপে ধাপে

## ⚠️ গুরুত্বপূর্ণ: Firebase এখনো কানেক্ট হয়নি!

আপনার প্রজেক্টে শুধু Firebase এর **structure** তৈরি আছে। Google Sign-In কাজ করার জন্য আপনাকে Firebase setup করতে হবে।

---

## 📋 যা যা লাগবে

1. ✅ Google Account
2. ✅ Internet connection
3. ✅ Flutter project (already have)
4. ⏳ 15-20 minutes time

---

## 🚀 Step 1: Firebase Project তৈরি করুন

### 1.1 Firebase Console এ যান
```
https://console.firebase.google.com/
```

### 1.2 নতুন Project তৈরি করুন
1. **"Add project"** এ ক্লিক করুন
2. Project name দিন: `TradeNest` (বা যেকোনো নাম)
3. **Continue** ক্লিক করুন
4. Google Analytics চালু রাখুন (recommended)
5. **Create project** ক্লিক করুন
6. অপেক্ষা করুন (2-3 মিনিট)
7. **Continue** ক্লিক করুন

---

## 🤖 Step 2: Android App Add করুন

### 2.1 Android icon এ ক্লিক করুন
Firebase console এ "Add app" সেকশনে **Android icon** (🤖) এ ক্লিক করুন

### 2.2 Package Name দিন
```
Package name: com.example.tradenest
```

💡 **কিভাবে Package Name পাবেন?**
```bash
# Terminal এ run করুন:
cd /home/basar/TradeNext/flutter_app
grep "applicationId" android/app/build.gradle
```

### 2.3 App nickname দিন (optional)
```
App nickname: TradeNest Android
```

### 2.4 Debug signing certificate SHA-1 যোগ করুন (Optional but recommended)

#### Linux/Mac এ SHA-1 পাওয়ার কমান্ড:
```bash
cd ~/.android
keytool -list -v -keystore debug.keystore -alias androiddebugkey -storepass android -keypass android
```

SHA-1 কপি করে Firebase এ পেস্ট করুন।

### 2.5 Register App ক্লিক করুন

---

## 📥 Step 3: google-services.json ফাইল ডাউনলোড করুন

### 3.1 ডাউনলোড করুন
Firebase থেকে **google-services.json** ফাইল ডাউনলোড হবে

### 3.2 সঠিক জায়গায় রাখুন
```bash
# ডাউনলোড করা ফাইল কপি করুন:
cp ~/Downloads/google-services.json /home/basar/TradeNext/flutter_app/android/app/

# ভেরিফাই করুন:
ls -la /home/basar/TradeNext/flutter_app/android/app/google-services.json
```

**Location:** `flutter_app/android/app/google-services.json`

---

## ⚙️ Step 4: Android Configuration

### 4.1 Project-level build.gradle এডিট করুন

File: `android/build.gradle`

```gradle
buildscript {
    dependencies {
        // এই লাইন যোগ করুন:
        classpath 'com.google.gms:google-services:4.3.15'
    }
}
```

### 4.2 App-level build.gradle এডিট করুন

File: `android/app/build.gradle`

**নিচে যোগ করুন (একদম শেষে):**
```gradle
// ফাইলের একদম শেষে যোগ করুন:
apply plugin: 'com.google.gms.google-services'
```

**defaultConfig এ যোগ করুন:**
```gradle
android {
    defaultConfig {
        // ...existing code...
        minSdkVersion 21  // 21 হতে হবে (Flutter default 19)
        multiDexEnabled true
    }
}

dependencies {
    // এই লাইন যোগ করুন:
    implementation platform('com.google.firebase:firebase-bom:32.7.0')
    implementation 'com.google.firebase:firebase-analytics'
    implementation 'com.google.firebase:firebase-auth'
}
```

---

## 🍎 Step 5: iOS Setup (Optional - পরে করতে পারেন)

### 5.1 iOS App Add করুন
Firebase console এ iOS icon (🍎) এ ক্লিক করুন

### 5.2 Bundle ID দিন
```
Bundle ID: com.example.tradenest
```

### 5.3 GoogleService-Info.plist ডাউনলোড করুন

### 5.4 সঠিক জায়গায় রাখুন
```
Location: flutter_app/ios/Runner/GoogleService-Info.plist
```

---

## 🔐 Step 6: Google Sign-In Configure করুন

### 6.1 Firebase Console এ Authentication চালু করুন

1. Firebase Console এ যান
2. বাম sidebar এ **"Authentication"** ক্লিক করুন
3. **"Get Started"** ক্লিক করুন
4. **"Sign-in method"** tab এ যান
5. **"Google"** সিলেক্ট করুন
6. **Enable** করুন
7. Support email সিলেক্ট করুন
8. **Save** ক্লিক করুন

### 6.2 Web Client ID কপি করুন

1. Authentication > Sign-in method > Google
2. **"Web SDK configuration"** expand করুন
3. **Web client ID** কপি করুন (দেখতে এরকম: `xxxxx.apps.googleusercontent.com`)

---

## 📝 Step 7: Flutter Configuration

### 7.1 pubspec.yaml চেক করুন (Already added)
```yaml
dependencies:
  firebase_core: ^2.24.2
  firebase_auth: ^4.16.0
  google_sign_in: ^6.2.1
```

### 7.2 main.dart এ Firebase Initialize করুন

File: `lib/main.dart`

```dart
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Firebase initialize করুন
  await Firebase.initializeApp();
  
  // ... rest of your code
}
```

### 7.3 .env ফাইলে Web Client ID যোগ করুন

File: `.env` (create করুন যদি না থাকে)

```env
API_BASE_URL=http://10.0.2.2:5000/api
GOOGLE_CLIENT_ID=YOUR_WEB_CLIENT_ID_HERE.apps.googleusercontent.com
```

---

## 🧪 Step 8: Testing

### 8.1 Dependencies Install করুন
```bash
cd /home/basar/TradeNext/flutter_app
flutter pub get
```

### 8.2 Build করুন
```bash
flutter build apk --debug
```

### 8.3 Run করুন
```bash
flutter run
```

---

## 🐛 Troubleshooting

### Problem 1: "google-services.json not found"
**Solution:**
```bash
# File আছে কিনা চেক করুন:
ls -la android/app/google-services.json

# না থাকলে Firebase থেকে আবার ডাউনলোড করুন
```

### Problem 2: "Execution failed for task ':app:processDebugGoogleServices'"
**Solution:**
```bash
# Package name match করছে কিনা চেক করুন:
grep "applicationId" android/app/build.gradle
# এটা google-services.json এর package_name এর সাথে same হতে হবে
```

### Problem 3: "minSdkVersion error"
**Solution:**
```gradle
// android/app/build.gradle
defaultConfig {
    minSdkVersion 21  // Change from 19 to 21
}
```

### Problem 4: Google Sign-In button কাজ করছে না
**Solution:**
1. SHA-1 certificate Firebase এ যোগ করেছেন কিনা চেক করুন
2. Authentication > Google Enable আছে কিনা চেক করুন
3. Web Client ID সঠিক আছে কিনা চেক করুন

---

## 📱 আপনার Device Connect করা

### USB Debugging চালু করুন

1. **Developer Options** চালু করুন:
   - Settings > About Phone
   - "Build Number" এ 7 বার tap করুন
   
2. **USB Debugging** চালু করুন:
   - Settings > Developer Options
   - "USB Debugging" চালু করুন

3. **Cable Connect করুন**:
   - USB-C cable দিয়ে connect করুন
   - Phone এ "Allow USB debugging" popup আসলে "Allow" করুন

4. **Device Check করুন**:
```bash
flutter devices
```

### যদি Device show না করে:

```bash
# ADB restart করুন:
adb kill-server
adb start-server
adb devices

# লিস্ট দেখুন:
flutter devices
```

---

## 🚀 Build Commands

### Debug Build (Testing এর জন্য)
```bash
# APK build করুন:
flutter build apk --debug

# Install করুন:
flutter install

# অথবা সরাসরি run করুন:
flutter run
```

### Release Build (Final version)
```bash
# Release APK:
flutter build apk --release

# File পাবেন এখানে:
# build/app/outputs/flutter-apk/app-release.apk
```

### Split APK (ছোট size)
```bash
flutter build apk --split-per-abi --release
```

---

## ✅ Checklist - সব কিছু ঠিক আছে কিনা

- [ ] Firebase Project তৈরি হয়েছে
- [ ] Android App registered
- [ ] google-services.json ফাইল সঠিক জায়গায় আছে
- [ ] android/build.gradle এ Google Services plugin যোগ হয়েছে
- [ ] android/app/build.gradle এ plugin apply করা হয়েছে
- [ ] minSdkVersion 21 করা হয়েছে
- [ ] Firebase Authentication > Google enabled
- [ ] Web Client ID কপি করা হয়েছে
- [ ] .env ফাইলে Client ID যোগ হয়েছে
- [ ] flutter pub get run করা হয়েছে
- [ ] Device USB debugging চালু আছে

---

## 📞 পরবর্তী পদক্ষেপ

1. ✅ Firebase setup সম্পূর্ণ করুন (উপরের সব steps)
2. ✅ Device connect করুন
3. ✅ `flutter devices` দিয়ে check করুন
4. ✅ `flutter run` দিয়ে app চালান
5. ✅ Google Sign-In test করুন

---

## 💡 Quick Commands Summary

```bash
# 1. Clean everything
cd /home/basar/TradeNext/flutter_app
flutter clean

# 2. Install dependencies
flutter pub get

# 3. Check devices
flutter devices

# 4. Run on device
flutter run

# 5. Build APK
flutter build apk --release

# 6. Install APK
flutter install
```

---

## 🆘 সাহায্য লাগলে

1. Firebase Console: https://console.firebase.google.com/
2. Flutter Firebase Docs: https://firebase.flutter.dev/
3. Check errors: `flutter doctor -v`
4. ADB check: `adb devices`

---

**মনে রাখবেন:** Firebase ছাড়াই app চলবে! শুধু Google Sign-In কাজ করবে না। Email/Password login ঠিকই কাজ করবে।

**তাই প্রথমে device connect করে app run করুন, পরে Firebase setup করতে পারেন! 🚀**
