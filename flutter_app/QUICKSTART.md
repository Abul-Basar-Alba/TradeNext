# TradeNest - Quick Start Guide

## 🚀 Quick Setup (5 Minutes)

### Step 1: Install Dependencies
```bash
cd /home/basar/TradeNext/flutter_app
flutter pub get
```

### Step 2: Generate Code
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Step 3: Update Backend URL

Edit `lib/config/constants.dart` (line 2-3):

**For Android Emulator:**
```dart
static const String apiBaseUrl = 'http://10.0.2.2:5000/api';
static const String baseUrl = 'http://10.0.2.2:5000';
```

**For Physical Device:**
```dart
static const String apiBaseUrl = 'http://YOUR_COMPUTER_IP:5000/api';
static const String baseUrl = 'http://YOUR_COMPUTER_IP:5000';
```

To find your IP:
```bash
# Linux/Mac
ifconfig | grep "inet "

# Windows
ipconfig
```

### Step 4: Start Backend Server
```bash
cd /path/to/your/backend
npm install
npm start
```

Verify backend is running at: http://localhost:5000

### Step 5: Run Flutter App
```bash
flutter run
```

## 📱 Testing the App

### 1. Registration Flow
- Open app
- Click "নিবন্ধন করুন" (Register)
- Fill in:
  - নাম (Name): Test User
  - ইমেইল (Email): test@example.com
  - পাসওয়ার্ড (Password): password123
  - Confirm password
- Click "নিবন্ধন করুন"

### 2. Login Flow
- Enter email: test@example.com
- Enter password: password123
- Click "লগইন করুন"

### 3. Browse Products
- After login, you'll see home screen
- Click "ভাড়া নিন" (Rent) or "কিনুন বা বিক্রয় করুন" (Buy/Sell)
- Browse products

### 4. Post an Ad
- Click the "বিজ্ঞাপন দিন" (Post Ad) FAB button
- Fill in product details
- Upload images (optional for now)
- Submit

## 🔧 Development Commands

### Clean Build
```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter run
```

### Check Devices
```bash
flutter devices
```

### Run on Specific Device
```bash
flutter run -d <device-id>
```

### Hot Reload
- Press `r` in terminal while app is running
- Or save files in VS Code (auto hot reload)

## 🐛 Common Issues & Fixes

### Issue 1: "Connection Refused"
**Solution:** Update API URL in `constants.dart`

### Issue 2: Build Runner Errors
**Solution:**
```bash
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

### Issue 3: Missing Dependencies
**Solution:**
```bash
flutter clean
flutter pub get
```

### Issue 4: "Unable to load asset"
**Solution:** Create missing directories:
```bash
mkdir -p assets/images assets/icons assets/translations
```

## 📂 Folder Structure Overview

```
lib/
├── config/          ← App settings
├── models/          ← Data models
├── services/        ← API & Storage
├── providers/       ← State management
├── screens/         ← UI screens
├── widgets/         ← Reusable components
└── utils/           ← Helpers & validators
```

## 🎯 What's Working

✅ User Registration & Login
✅ Home Screen UI
✅ Authentication State Management
✅ API Service with Token Management
✅ Secure Storage
✅ Form Validation
✅ Error Handling
✅ Bengali UI

## 🚧 What Needs Implementation

🔨 Product Listing Screen (with API)
🔨 Product Details Screen
🔨 Create Product Form
🔨 Profile Screen
🔨 Image Upload
🔨 Pagination
🔨 Filtering & Search

## 📚 Key Files to Customize

1. **API URL**: `lib/config/constants.dart`
2. **Theme Colors**: `lib/config/theme.dart`
3. **Bengali Text**: `assets/translations/bn.json`
4. **Routes**: `lib/config/routes.dart`

## 🎨 Customization Examples

### Change Primary Color
Edit `lib/config/theme.dart`:
```dart
static const Color primaryColor = Color(0xFFYOURCOLOR);
```

### Add New Category
Edit `lib/config/constants.dart`:
```dart
static const List<String> categories = [
  'vehicles',
  'property',
  'electronics',
  'fashion',
  'furniture',
  'event-equipment',
  'your-new-category', // Add here
];
```

### Add Bengali Text
Edit `assets/translations/bn.json`:
```json
{
  "your_key": "আপনার টেক্সট"
}
```

## 🎓 Next Steps

1. **Complete Product Screens** - See [README.md](README.md#-next-steps--todos)
2. **Test on Real Device** - Build APK and install
3. **Add Images** - Place logo in `assets/images/`
4. **Customize Theme** - Match your brand colors

## 💡 Tips

- Use hot reload (press `r`) for quick testing
- Check Flutter DevTools for debugging
- Use Riverpod DevTools for state inspection
- Test on multiple screen sizes

## 📞 Need Help?

Check the main [README.md](README.md) for:
- Detailed documentation
- API integration guide
- State management patterns
- Best practices

---

**Ready to build! 🚀**
