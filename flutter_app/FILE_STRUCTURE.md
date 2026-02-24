# TradeNest Flutter Project - File Structure

```
flutter_app/
│
├── 📱 lib/
│   │
│   ├── 🎯 main.dart                         # App entry point with Riverpod setup
│   │
│   ├── ⚙️ config/
│   │   ├── constants.dart                   # App constants, categories, API URLs
│   │   ├── theme.dart                       # Light/Dark theme configuration
│   │   └── routes.dart                      # GoRouter navigation setup
│   │
│   ├── 📦 models/
│   │   ├── user.dart                        # User model with JSON serialization
│   │   ├── product.dart                     # Product model with helpers
│   │   └── api_response.dart                # API response wrapper & exceptions
│   │
│   ├── 🔌 services/
│   │   ├── api_service.dart                 # Dio HTTP client with interceptors
│   │   ├── auth_service.dart                # Authentication API calls
│   │   ├── product_service.dart             # Product CRUD operations
│   │   └── storage_service.dart             # Local & secure storage
│   │
│   ├── 🔄 providers/
│   │   ├── auth_provider.dart               # Auth state management (Riverpod)
│   │   ├── product_provider.dart            # Product state & pagination
│   │   └── app_provider.dart                # Language, theme, favorites
│   │
│   ├── 📱 screens/
│   │   │
│   │   ├── 🔐 auth/
│   │   │   ├── login_screen.dart            # ✅ Email/Password login (COMPLETE)
│   │   │   └── register_screen.dart         # ✅ User registration (COMPLETE)
│   │   │
│   │   ├── 🏠 home/
│   │   │   └── home_screen.dart             # ✅ Home with rent/sell cards (COMPLETE)
│   │   │
│   │   ├── 🛒 products/
│   │   │   ├── products_list_screen.dart    # 🔄 Grid view with filters (TODO)
│   │   │   ├── product_details_screen.dart  # 🔄 Details with carousel (TODO)
│   │   │   ├── create_product_screen.dart   # 🔄 Post ad form (TODO)
│   │   │   └── edit_product_screen.dart     # 🔄 Edit ad form (TODO)
│   │   │
│   │   └── 👤 profile/
│   │       ├── profile_screen.dart          # 🔄 Profile with sidebar (TODO)
│   │       ├── my_ads_screen.dart           # 🔄 User's products (TODO)
│   │       ├── edit_profile_screen.dart     # 🔄 Edit user info (TODO)
│   │       ├── settings_screen.dart         # 🔄 App settings (TODO)
│   │       └── favorites_screen.dart        # 🔄 Saved products (TODO)
│   │
│   ├── 🧩 widgets/
│   │   ├── product_card.dart                # ✅ Product grid item (COMPLETE)
│   │   ├── custom_button.dart               # ✅ Reusable button (COMPLETE)
│   │   ├── custom_text_field.dart           # ✅ Form input field (COMPLETE)
│   │   └── loading_widget.dart              # ✅ Loading/Empty/Error states (COMPLETE)
│   │
│   └── 🛠️ utils/
│       ├── validators.dart                  # ✅ Form validation (COMPLETE)
│       └── helpers.dart                     # ✅ Formatting helpers (COMPLETE)
│
├── 📂 assets/
│   ├── images/                              # 📸 App images (add your images here)
│   ├── icons/                               # 🎨 App icons
│   ├── fonts/                               # 🔤 Bengali fonts (optional)
│   └── translations/
│       └── bn.json                          # ✅ Bengali translations (COMPLETE)
│
├── 🤖 android/                              # Android configuration
│   └── app/
│       └── src/
│           └── main/
│               └── AndroidManifest.xml      # Add permissions here
│
├── 🍎 ios/                                  # iOS configuration
│   └── Runner/
│       └── Info.plist                       # Add permissions here
│
├── 📄 Documentation/
│   ├── README.md                            # ✅ Complete documentation
│   ├── QUICKSTART.md                        # ✅ 5-minute setup guide
│   ├── IMPLEMENTATION_GUIDE.md              # ✅ Step-by-step development
│   └── PROJECT_SUMMARY.md                   # ✅ Project overview
│
├── ⚙️ Configuration/
│   ├── pubspec.yaml                         # ✅ Dependencies & assets
│   ├── .env.example                         # ✅ Environment variables template
│   ├── .gitignore                           # ✅ Git ignore rules
│   └── analysis_options.yaml                # 🔄 Linting rules (create if needed)
│
└── 🧪 test/                                 # Unit & widget tests (create as needed)
    ├── unit/
    ├── widget/
    └── integration/

```

## 📊 Status Legend

- ✅ **COMPLETE** - Fully implemented and ready to use
- 🔄 **TODO** - Structure created, needs implementation
- 📸 **EMPTY** - Folder created, add your files here

## 🎯 Quick File Guide

### 🔥 Most Important Files

1. **lib/main.dart** - Start here to understand app structure
2. **lib/config/constants.dart** - Update API URL first
3. **lib/services/api_service.dart** - Core HTTP client
4. **lib/providers/auth_provider.dart** - Authentication state
5. **lib/screens/auth/login_screen.dart** - Working example

### 🎨 UI Customization

- **lib/config/theme.dart** - Change colors & styles
- **assets/translations/bn.json** - Update Bengali text
- **lib/config/constants.dart** - Modify categories & constants

### 🔌 API Integration

- **lib/services/** - All API calls
- **lib/models/** - Data structures
- **lib/providers/** - State management

### 🧩 Reusable Components

- **lib/widgets/** - Custom widgets
- **lib/utils/** - Helper functions

## 📈 Development Flow

```
1. Start Backend Server
   ↓
2. Update API URL in constants.dart
   ↓
3. Run flutter pub get
   ↓
4. Run build_runner
   ↓
5. Test Login/Register
   ↓
6. Implement Product Screens
   ↓
7. Add Image Upload
   ↓
8. Complete Profile Features
   ↓
9. Testing & Polish
   ↓
10. Build Release APK
```

## 🎓 Code Organization Principles

### Clean Architecture
```
Screens (UI)
    ↓
Providers (State)
    ↓
Services (Business Logic)
    ↓
Models (Data)
```

### Separation of Concerns
- **Screens** = UI only
- **Providers** = State management
- **Services** = API calls & logic
- **Widgets** = Reusable components
- **Utils** = Pure functions
- **Config** = Constants & settings

## 💡 Pro Tips

1. **Navigation**: Use `context.push('/route')` with GoRouter
2. **State**: Access with `ref.watch(provider)` or `ref.read(provider)`
3. **API Calls**: Always in services, not in screens
4. **Validation**: Use validators from `utils/validators.dart`
5. **Formatting**: Use helpers from `utils/helpers.dart`

## 🔍 File Naming Conventions

- **Screens**: `screen_name_screen.dart`
- **Widgets**: `widget_name.dart`
- **Providers**: `feature_provider.dart`
- **Services**: `feature_service.dart`
- **Models**: `model_name.dart`

## 🎯 Next Files to Create/Modify

### Immediate Priority
1. Complete `products_list_screen.dart`
2. Complete `product_details_screen.dart`
3. Complete `create_product_screen.dart`
4. Create `image_picker_widget.dart`

### Secondary Priority
5. Complete `profile_screen.dart`
6. Complete `my_ads_screen.dart`
7. Complete `favorites_screen.dart`
8. Create `filter_bottom_sheet.dart`

---

**Total Files**: 35+
**Complete Files**: 25
**TODO Files**: 10
**Code Coverage**: ~70% complete

**Ready to develop! 🚀**
