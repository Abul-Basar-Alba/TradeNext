import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Language state notifier
class LanguageNotifier extends StateNotifier<String> {
  LanguageNotifier() : super('bn') {
    // Default to Bangla
    loadLanguage();
  }

  Future<void> loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLanguage = prefs.getString('language_code') ?? 'bn';
    state = savedLanguage;
  }

  Future<void> setLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', languageCode);
    state = languageCode;
  }

  void toggleLanguage() {
    final newLanguage = state == 'bn' ? 'en' : 'bn';
    setLanguage(newLanguage);
  }
}

// Language provider
final languageProvider = StateNotifierProvider<LanguageNotifier, String>((ref) {
  return LanguageNotifier();
});

// Helper extension for easy access
extension LocalizationContext on String {
  String tr(String languageCode) {
    return this; // This will be replaced by AppStrings.translate
  }
}
