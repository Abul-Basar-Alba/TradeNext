import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/storage_service.dart';

// Storage Service Provider
final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService();
});

// Language Provider
final languageProvider = StateNotifierProvider<LanguageNotifier, String>((ref) {
  return LanguageNotifier(ref.read(storageServiceProvider));
});

class LanguageNotifier extends StateNotifier<String> {
  final StorageService _storage;

  LanguageNotifier(this._storage) : super('bn') {
    _init();
  }

  Future<void> _init() async {
    state = _storage.getLanguage();
  }

  Future<void> setLanguage(String language) async {
    await _storage.saveLanguage(language);
    state = language;
  }

  void toggleLanguage() {
    final newLanguage = state == 'bn' ? 'en' : 'bn';
    setLanguage(newLanguage);
  }
}

// Theme Mode Provider
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, String>((ref) {
  return ThemeModeNotifier(ref.read(storageServiceProvider));
});

class ThemeModeNotifier extends StateNotifier<String> {
  final StorageService _storage;

  ThemeModeNotifier(this._storage) : super('light') {
    _init();
  }

  Future<void> _init() async {
    state = _storage.getThemeMode();
  }

  Future<void> setThemeMode(String mode) async {
    await _storage.saveThemeMode(mode);
    state = mode;
  }

  void toggleTheme() {
    final newMode = state == 'light' ? 'dark' : 'light';
    setThemeMode(newMode);
  }
}

// Favorites Provider
final favoritesProvider = StateNotifierProvider<FavoritesNotifier, List<String>>((ref) {
  return FavoritesNotifier(ref.read(storageServiceProvider));
});

class FavoritesNotifier extends StateNotifier<List<String>> {
  final StorageService _storage;

  FavoritesNotifier(this._storage) : super([]) {
    _init();
  }

  Future<void> _init() async {
    state = _storage.getFavorites();
  }

  Future<void> addFavorite(String productId) async {
    await _storage.addFavorite(productId);
    state = _storage.getFavorites();
  }

  Future<void> removeFavorite(String productId) async {
    await _storage.removeFavorite(productId);
    state = _storage.getFavorites();
  }

  Future<void> toggleFavorite(String productId) async {
    if (isFavorite(productId)) {
      await removeFavorite(productId);
    } else {
      await addFavorite(productId);
    }
  }

  bool isFavorite(String productId) {
    return state.contains(productId);
  }
}
