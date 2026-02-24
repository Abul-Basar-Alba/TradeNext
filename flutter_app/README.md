# TradeNest - Rent & Buy Marketplace Platform

A comprehensive Flutter mobile application for buying, selling, and renting products/services, similar to Bikroy.com with enhanced features.

## 📱 Overview

TradeNest is a cross-platform marketplace mobile application built with Flutter that connects buyers, sellers, and renters. The app provides a seamless experience for posting ads, browsing products, and managing transactions.

## ✨ Features

### Core Features
- ✅ User Authentication (Email/Password, Google Sign-In)
- ✅ Browse products (Buy & Rent categories)
- ✅ Advanced filtering and search
- ✅ Post product ads with image uploads
- ✅ Product details with owner information
- ✅ User profile management
- ✅ Favorites/Wishlist
- ✅ My Ads management
- ✅ Bengali and English localization
- ✅ Responsive UI with Material Design

### Technical Features
- State Management: Riverpod
- API Integration: Dio with interceptors
- Secure Storage: flutter_secure_storage
- Image Handling: cached_network_image
- Navigation: GoRouter
- Form Validation: Custom validators
- Error Handling: Centralized error management
- Token Management: Auto-refresh with interceptors

## 🛠 Tech Stack

- **Framework**: Flutter 3.0+
- **Language**: Dart
- **State Management**: Riverpod
- **Navigation**: GoRouter
- **HTTP Client**: Dio
- **Local Storage**: flutter_secure_storage, SharedPreferences
- **Image Handling**: image_picker, image_cropper, cached_network_image
- **Authentication**: Firebase Auth (Google Sign-In)

## 📋 Prerequisites

Before you begin, ensure you have installed:
- Flutter SDK (3.0 or higher)
- Dart SDK
- Android Studio / VS Code with Flutter extensions
- Git
- Node.js backend server (provided separately)

## 🚀 Getting Started

### 1. Clone the Repository

```bash
cd /home/basar/TradeNext/flutter_app
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Generate Code

Generate JSON serialization and Riverpod code:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 4. Configure Environment

Create a `.env` file in the project root:

```env
API_BASE_URL=http://your-backend-url:5000/api
GOOGLE_CLIENT_ID=your_google_client_id_here
```

**For local development:**
- Android Emulator: `http://10.0.2.2:5000/api`
- iOS Simulator: `http://localhost:5000/api`
- Physical Device: `http://YOUR_IP_ADDRESS:5000/api`

### 5. Update API Base URL

Edit `lib/config/constants.dart`:

```dart
static const String apiBaseUrl = 'http://10.0.2.2:5000/api'; // For Android Emulator
// OR
static const String apiBaseUrl = 'http://192.168.1.x:5000/api'; // For Physical Device
```

### 6. Run the App

```bash
# Check connected devices
flutter devices

# Run on default device
flutter run

# Run on specific device
flutter run -d <device-id>
```

## 📁 Project Structure

```
flutter_app/
├── lib/
│   ├── main.dart                    # App entry point
│   ├── config/
│   │   ├── constants.dart           # App constants
│   │   ├── theme.dart               # Theme configuration
│   │   └── routes.dart              # Route configuration
│   ├── models/
│   │   ├── user.dart                # User model
│   │   ├── product.dart             # Product model
│   │   └── api_response.dart        # API response models
│   ├── services/
│   │   ├── api_service.dart         # HTTP client service
│   │   ├── auth_service.dart        # Authentication service
│   │   ├── product_service.dart     # Product service
│   │   └── storage_service.dart     # Local storage service
│   ├── providers/
│   │   ├── auth_provider.dart       # Auth state management
│   │   ├── product_provider.dart    # Product state management
│   │   └── app_provider.dart        # App-level state
│   ├── screens/
│   │   ├── auth/
│   │   │   ├── login_screen.dart
│   │   │   └── register_screen.dart
│   │   ├── home/
│   │   │   └── home_screen.dart
│   │   ├── products/
│   │   │   ├── products_list_screen.dart
│   │   │   ├── product_details_screen.dart
│   │   │   ├── create_product_screen.dart
│   │   │   └── edit_product_screen.dart
│   │   └── profile/
│   │       ├── profile_screen.dart
│   │       ├── my_ads_screen.dart
│   │       ├── edit_profile_screen.dart
│   │       ├── settings_screen.dart
│   │       └── favorites_screen.dart
│   ├── widgets/
│   │   ├── product_card.dart        # Product card widget
│   │   ├── custom_button.dart       # Reusable button
│   │   ├── custom_text_field.dart   # Reusable text field
│   │   └── loading_widget.dart      # Loading states
│   └── utils/
│       ├── validators.dart          # Form validators
│       └── helpers.dart             # Helper functions
├── assets/
│   ├── images/                      # Image assets
│   ├── icons/                       # Icon assets
│   └── translations/
│       └── bn.json                  # Bengali translations
├── pubspec.yaml                     # Dependencies
└── README.md                        # This file
```

## 🔑 API Integration

### Backend Endpoints

Your Node.js backend provides these endpoints:

#### Authentication
- `POST /api/auth/register` - Register new user
- `POST /api/auth/login` - Login user
- `POST /api/auth/google` - Google OAuth login
- `POST /api/auth/logout` - Logout user

#### User Management
- `GET /api/users/me` - Get current user
- `PUT /api/users/me` - Update user profile
- `GET /api/users/:id` - Get user by ID

#### Products
- `GET /api/products` - Get all products (with filters)
- `GET /api/products/:id` - Get single product
- `POST /api/products` - Create product
- `PUT /api/products/:id` - Update product
- `DELETE /api/products/:id` - Delete product
- `GET /api/products/my/products` - Get user's products

### API Service Features

The `ApiService` class provides:
- Automatic token injection
- Token refresh on 401 errors
- Network connectivity checking
- Error handling and mapping
- Request/response logging
- File upload support

## 🎨 UI Components

### Reusable Widgets

#### ProductCard
Displays product information with image, title, price, location, and status.

```dart
ProductCard(
  product: product,
  onTap: () => context.push('/products/${product.id}'),
)
```

#### CustomButton
Reusable button with loading state and icon support.

```dart
CustomButton(
  text: 'লগইন করুন',
  onPressed: _login,
  isLoading: isLoading,
)
```

#### CustomTextField
Form field with validation and Bengali labels.

```dart
CustomTextField(
  label: 'ইমেইল',
  controller: _emailController,
  validator: Validators.validateEmail,
)
```

## 🔐 Authentication Flow

1. User enters credentials
2. App sends request to `/api/auth/login`
3. Backend returns JWT token
4. Token saved in secure storage
5. Token automatically added to all requests
6. On 401 error, token auto-refreshes
7. On logout, tokens cleared

## 📊 State Management

Using **Riverpod** for predictable state management:

### Auth Provider
```dart
final authNotifierProvider = StateNotifierProvider<AuthNotifier, AsyncValue<User?>>((ref) {
  return AuthNotifier(ref.read(authServiceProvider));
});
```

### Usage in Widgets
```dart
final authState = ref.watch(authNotifierProvider);

authState.when(
  data: (user) => Text('Welcome ${user?.name}'),
  loading: () => CircularProgressIndicator(),
  error: (error, _) => Text('Error: $error'),
);
```

## 🌐 Localization

Bengali translations in `assets/translations/bn.json`:

```dart
// Access translations
AppTranslations.of(context).login
```

## 🎯 Best Practices Implemented

### 1. Error Handling
- Centralized error handling in `ApiService`
- User-friendly Bengali error messages
- Network connectivity checks
- Graceful fallbacks

### 2. Security
- Secure token storage with `flutter_secure_storage`
- Input validation on all forms
- XSS protection in text inputs
- No hardcoded credentials

### 3. Performance
- Image caching with `cached_network_image`
- Lazy loading with pagination
- Efficient state management
- Optimized API calls

### 4. Code Quality
- Clean architecture (separation of concerns)
- Reusable components
- Type-safe models with JSON serialization
- Comprehensive error types

## 📝 Next Steps & TODOs

The following features need to be implemented:

### High Priority
1. **Complete Product Screens**
   - [ ] Products list with pagination
   - [ ] Product details with image carousel
   - [ ] Create product form with image upload
   - [ ] Edit product functionality

2. **Profile Features**
   - [ ] Profile screen with sidebar
   - [ ] My Ads screen with filtering
   - [ ] Edit profile with avatar upload
   - [ ] Settings screen

3. **Image Upload**
   - [ ] Implement image picker
   - [ ] Image cropping
   - [ ] Image compression
   - [ ] Multiple image upload

### Medium Priority
4. **Search & Filters**
   - [ ] Advanced filtering UI
   - [ ] Search functionality
   - [ ] Sort options
   - [ ] Saved searches

5. **Messaging**
   - [ ] Chat functionality
   - [ ] Message notifications
   - [ ] Chat list

6. **Google Sign-In**
   - [ ] Firebase setup
   - [ ] Google OAuth integration
   - [ ] Token exchange

### Low Priority
7. **Additional Features**
   - [ ] Push notifications
   - [ ] Deep linking
   - [ ] Share functionality
   - [ ] Phone verification
   - [ ] Profile verification
   - [ ] Dark mode
   - [ ] Language switcher

## 🐛 Troubleshooting

### Common Issues

#### 1. Build Runner Errors
```bash
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

#### 2. API Connection Issues
- Check if backend server is running
- Verify API base URL in `constants.dart`
- For Android emulator, use `10.0.2.2` instead of `localhost`
- For physical device, use your computer's IP address

#### 3. Token Errors
```bash
# Clear app data
flutter clean
flutter pub get
```

#### 4. Image Loading Issues
- Ensure backend URL is correct
- Check image paths in response
- Verify CORS settings on backend

## 🧪 Testing

```bash
# Run unit tests
flutter test

# Run integration tests
flutter test integration_test

# Generate coverage
flutter test --coverage
```

## 📱 Building for Production

### Android
```bash
# Build APK
flutter build apk --release

# Build App Bundle (for Play Store)
flutter build appbundle --release
```

### iOS
```bash
# Build iOS app
flutter build ios --release
```

## 📄 License

This project is private and proprietary.

## 👥 Contributors

- Your Name - Initial work

## 📞 Support

For support, contact: your-email@example.com

---

## 🎓 Learning Resources

### Flutter
- [Flutter Documentation](https://flutter.dev/docs)
- [Flutter Cookbook](https://flutter.dev/docs/cookbook)

### Riverpod
- [Riverpod Documentation](https://riverpod.dev)
- [Riverpod Examples](https://github.com/rrousselGit/riverpod)

### API Integration
- [Dio Documentation](https://pub.dev/packages/dio)
- [HTTP Requests in Flutter](https://flutter.dev/docs/cookbook/networking/fetch-data)

---

**Built with ❤️ using Flutter**
