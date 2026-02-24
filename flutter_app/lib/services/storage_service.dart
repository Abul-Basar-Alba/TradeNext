import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/constants.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  final _secureStorage = const FlutterSecureStorage();
  SharedPreferences? _prefs;

  // Initialize SharedPreferences
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Secure Storage Methods (for tokens)
  Future<void> saveAccessToken(String token) async {
    await _secureStorage.write(key: AppConstants.accessTokenKey, value: token);
  }

  Future<String?> getAccessToken() async {
    return await _secureStorage.read(key: AppConstants.accessTokenKey);
  }

  Future<void> saveRefreshToken(String token) async {
    await _secureStorage.write(
        key: AppConstants.refreshTokenKey, value: token);
  }

  Future<String?> getRefreshToken() async {
    return await _secureStorage.read(key: AppConstants.refreshTokenKey);
  }

  Future<void> deleteTokens() async {
    await _secureStorage.delete(key: AppConstants.accessTokenKey);
    await _secureStorage.delete(key: AppConstants.refreshTokenKey);
  }

  // SharedPreferences Methods
  Future<void> saveUserData(String userData) async {
    await _prefs?.setString(AppConstants.userDataKey, userData);
  }

  String? getUserData() {
    return _prefs?.getString(AppConstants.userDataKey);
  }

  Future<void> deleteUserData() async {
    await _prefs?.remove(AppConstants.userDataKey);
  }

  Future<void> saveLanguage(String language) async {
    await _prefs?.setString(AppConstants.languageKey, language);
  }

  String getLanguage() {
    return _prefs?.getString(AppConstants.languageKey) ?? 'bn';
  }

  Future<void> saveThemeMode(String mode) async {
    await _prefs?.setString(AppConstants.themeKey, mode);
  }

  String getThemeMode() {
    return _prefs?.getString(AppConstants.themeKey) ?? 'light';
  }

  // Clear all data
  Future<void> clearAll() async {
    await deleteTokens();
    await deleteUserData();
  }

  // Save favorite products
  Future<void> saveFavorites(List<String> productIds) async {
    await _prefs?.setStringList('favorites', productIds);
  }

  List<String> getFavorites() {
    return _prefs?.getStringList('favorites') ?? [];
  }

  Future<void> addFavorite(String productId) async {
    final favorites = getFavorites();
    if (!favorites.contains(productId)) {
      favorites.add(productId);
      await saveFavorites(favorites);
    }
  }

  Future<void> removeFavorite(String productId) async {
    final favorites = getFavorites();
    favorites.remove(productId);
    await saveFavorites(favorites);
  }

  bool isFavorite(String productId) {
    return getFavorites().contains(productId);
  }
}
