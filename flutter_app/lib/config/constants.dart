class AppConstants {
  // API Configuration
  static const String apiBaseUrl = 'http://192.168.0.108:5000/api';
  static const String baseUrl = 'http://192.168.0.108:5000';
  
  // API Endpoints
  static const String authEndpoint = '/auth';
  static const String usersEndpoint = '/users';
  static const String productsEndpoint = '/products';
  
  // Storage Keys
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userDataKey = 'user_data';
  static const String languageKey = 'language';
  static const String themeKey = 'theme_mode';
  
  // Pagination
  static const int defaultPageSize = 20;
  static const int maxImageUpload = 5;
  
  // Image Configuration
  static const int maxImageSizeKB = 2048;
  static const int imageQuality = 85;
  
  // Categories
  static const List<String> categories = [
    'vehicles',
    'property',
    'electronics',
    'fashion',
    'furniture',
    'event-equipment',
  ];
  
  // Categories Bengali
  static const Map<String, String> categoriesBengali = {
    'vehicles': 'গাড়ি',
    'property': 'প্রপার্টি',
    'electronics': 'ইলেকট্রনিক্স',
    'fashion': 'ফ্যাশন',
    'furniture': 'ফার্নিচার',
    'event-equipment': 'ইভেন্ট সরঞ্জাম',
  };
  
  // Product Types
  static const String typeRent = 'rent';
  static const String typeSell = 'sell';
  
  // Product Status
  static const String statusAvailable = 'available';
  static const String statusRented = 'rented';
  static const String statusSold = 'sold';
  static const String statusUnavailable = 'unavailable';
  
  // Status Bengali
  static const Map<String, String> statusBengali = {
    'available': 'চালু',
    'rented': 'ভাড়া দেওয়া',
    'sold': 'বিক্রিত',
    'unavailable': 'অনুপলব্ধ',
  };
  
  // Conditions
  static const List<String> conditions = [
    'new',
    'like_new',
    'good',
    'fair',
  ];
  
  // Conditions Bengali
  static const Map<String, String> conditionsBengali = {
    'new': 'নতুন',
    'like_new': 'প্রায় নতুন',
    'good': 'ভালো',
    'fair': 'মোটামুটি',
  };
  
  // Bangladesh Divisions
  static const List<String> divisions = [
    'Dhaka',
    'Chattogram',
    'Rajshahi',
    'Khulna',
    'Barishal',
    'Sylhet',
    'Rangpur',
    'Mymensingh',
  ];
  
  // Rental Periods
  static const String rentalDaily = 'daily';
  static const String rentalMonthly = 'monthly';
  
  // Sort Options
  static const String sortNewest = 'newest';
  static const String sortOldest = 'oldest';
  static const String sortPriceAsc = 'price_asc';
  static const String sortPriceDesc = 'price_desc';
  static const String sortViews = 'views';
}
