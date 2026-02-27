/// App Localization Strings
class AppStrings {
  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      // Navigation
      'home': 'Home',
      'search': 'Search',
      'post_ad': 'Post Ad',
      'chat': 'Chat',
      'account': 'Account',
      
      // Auth
      'login': 'Login',
      'register': 'Register',
      'google_sign_in': 'Sign in with Google',
      'google_signin': 'Sign in with Google',
      'email': 'Email',
      'password': 'Password',
      'name': 'Name',
      'phone': 'Phone Number',
      'login_subtitle': 'Login to your account',
      'forgot_password': 'Forgot Password?',
      'or': 'OR',
      'no_account': 'No account? ',
      'login_success': 'Login successful',
      'welcome': 'Welcome',
      
      // Home Screen
      'search_placeholder': 'What are you looking for?',
      'welcome_guest': 'Create Your Account',
      'guest_message': 'Login to buy, sell and rent',
      'welcome_user': 'Welcome',
      'rent_now': 'Rent Now',
      'buy_sell': 'Buy or Sell',
      'categories': 'Categories',
      'view_all': 'View All',
      'featured_ads': 'Featured Ads',
      'recent_ads': 'Recent Ads',
      'no_ads': 'No ads available yet',
      
      // Actions
      'settings': 'Settings',
      'logout': 'Logout',
      'my_ads': 'My Ads',
      'favorites': 'Favorites',
      'edit_profile': 'Edit Profile',
      
      // Settings
      'language': 'Language',
    },
    'bn': {
      // Navigation
      'home': 'হোম',
      'search': 'সার্চ',
      'post_ad': 'বিজ্ঞাপন দিন',
      'chat': 'চ্যাট',
      'account': 'অ্যাকাউন্ট',
      
      // Auth
      'login': 'লগইন করুন',
      'register': 'নিবন্ধন করুন',
      'google_sign_in': 'Google দিয়ে সাইন ইন',
      'google_signin': 'Google দিয়ে লগইন',
      'email': 'ইমেইল',
      'password': 'পাসওয়ার্ড',
      'name': 'নাম',
      'phone': 'ফোন নম্বর',
      'login_subtitle': 'আপনার অ্যাকাউন্টে লগইন করুন',
      'forgot_password': 'পাসওয়ার্ড ভুলে গেছেন?',
      'or': 'অথবা',
      'no_account': 'অ্যাকাউন্ট নেই? ',
      'login_success': 'লগইন সফল হয়েছে',
      'welcome': 'স্বাগতম',
      
      // Home Screen
      'search_placeholder': 'আপনি কি খুঁজছেন?',
      'welcome_guest': 'আপনার অ্যাকাউন্ট তৈরি করুন',
      'guest_message': 'বিক্রয়, ক্রয় এবং ভাড়া নেওয়ার জন্য লগইন করুন',
      'welcome_user': 'স্বাগতম',
      'rent_now': 'ভাড়া নিন',
      'buy_sell': 'কিনুন বা বিক্রয় করুন',
      'categories': 'ক্যাটাগরি',
      'view_all': 'সব দেখুন',
      'featured_ads': 'ফিচারড বিজ্ঞাপন',
      'recent_ads': 'জনপ্রিয় বিজ্ঞাপন',
      'no_ads': 'এখনো কোন বিজ্ঞাপন নেই',
      
      // Actions
      'settings': 'সেটিংস',
      'logout': 'লগআউট',
      'my_ads': 'আমার বিজ্ঞাপন',
      'favorites': 'পছন্দের তালিকা',
      'edit_profile': 'প্রোফাইল এডিট করুন',
      
      // Settings
      'language': 'ভাষা',
    },
  };

  static String translate(String key, String languageCode) {
    return _localizedValues[languageCode]?[key] ?? key;
  }
}
