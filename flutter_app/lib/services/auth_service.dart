import 'dart:convert';
import '../models/user.dart';
import '../models/api_response.dart';
import 'api_service.dart';
import 'storage_service.dart';

class AuthService {
  final _api = ApiService();
  final _storage = StorageService();

  // Register new user
  Future<User> register({
    required String name,
    required String email,
    required String password,
    String? phone,
  }) async {
    try {
      final response = await _api.post(
        '/auth/register',
        data: {
          'name': name,
          'email': email,
          'password': password,
          if (phone != null) 'phone': phone,
        },
        fromJson: (json) => ApiResponse<Map<String, dynamic>>.fromJson(
          json,
          (data) => data as Map<String, dynamic>,
        ),
      );

      if (response.success && response.data != null) {
        // Save token
        if (response.token != null) {
          await _storage.saveAccessToken(response.token!);
        }

        // Save user data
        final user = User.fromJson(response.data!);
        await _storage.saveUserData(jsonEncode(user.toJson()));

        return user;
      } else {
        throw ApiException(response.message);
      }
    } catch (e) {
      rethrow;
    }
  }

  // Login user
  Future<User> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _api.post(
        '/auth/login',
        data: {
          'email': email,
          'password': password,
        },
        fromJson: (json) => ApiResponse<Map<String, dynamic>>.fromJson(
          json,
          (data) => data as Map<String, dynamic>,
        ),
      );

      if (response.success && response.data != null) {
        // Save token
        if (response.token != null) {
          await _storage.saveAccessToken(response.token!);
        }

        // Save user data
        final user = User.fromJson(response.data!);
        await _storage.saveUserData(jsonEncode(user.toJson()));

        return user;
      } else {
        throw ApiException(response.message);
      }
    } catch (e) {
      rethrow;
    }
  }

  // Google Sign-In
  Future<User> googleSignIn(String idToken) async {
    try {
      final response = await _api.post(
        '/auth/google',
        data: {'idToken': idToken},
        fromJson: (json) => ApiResponse<Map<String, dynamic>>.fromJson(
          json,
          (data) => data as Map<String, dynamic>,
        ),
      );

      if (response.success && response.data != null) {
        // Save token
        if (response.token != null) {
          await _storage.saveAccessToken(response.token!);
        }

        // Save user data
        final user = User.fromJson(response.data!);
        await _storage.saveUserData(jsonEncode(user.toJson()));

        return user;
      } else {
        throw ApiException(response.message);
      }
    } catch (e) {
      rethrow;
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      await _api.post('/auth/logout');
    } catch (e) {
      // Continue with local logout even if API call fails
    } finally {
      await _storage.clearAll();
    }
  }

  // Get current user
  Future<User?> getCurrentUser() async {
    try {
      final token = await _storage.getAccessToken();
      if (token == null) return null;

      final response = await _api.get(
        '/users/me',
        fromJson: (json) => ApiResponse<Map<String, dynamic>>.fromJson(
          json,
          (data) => data as Map<String, dynamic>,
        ),
      );

      if (response.success && response.data != null) {
        final user = User.fromJson(response.data!);
        await _storage.saveUserData(jsonEncode(user.toJson()));
        return user;
      }

      return null;
    } catch (e) {
      // Try to get cached user data
      final userData = _storage.getUserData();
      if (userData != null) {
        return User.fromJson(jsonDecode(userData));
      }
      return null;
    }
  }

  // Update user profile
  Future<User> updateProfile({
    String? name,
    String? phone,
    String? city,
    String? area,
  }) async {
    try {
      final response = await _api.put(
        '/users/me',
        data: {
          if (name != null) 'name': name,
          if (phone != null) 'phone': phone,
          if (city != null || area != null)
            'location': {
              if (city != null) 'city': city,
              if (area != null) 'area': area,
            },
        },
        fromJson: (json) => ApiResponse<Map<String, dynamic>>.fromJson(
          json,
          (data) => data as Map<String, dynamic>,
        ),
      );

      if (response.success && response.data != null) {
        final user = User.fromJson(response.data!);
        await _storage.saveUserData(jsonEncode(user.toJson()));
        return user;
      } else {
        throw ApiException(response.message);
      }
    } catch (e) {
      rethrow;
    }
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await _storage.getAccessToken();
    return token != null;
  }
}
