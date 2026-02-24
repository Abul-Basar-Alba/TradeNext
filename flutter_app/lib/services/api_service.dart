import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:logger/logger.dart';

import '../config/constants.dart';
import '../models/api_response.dart';
import 'storage_service.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  late final Dio _dio;
  final _storage = StorageService();
  final _logger = Logger();

  void init() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.apiBaseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptors
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Add auth token to requests
          final token = await _storage.getAccessToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          _logger.d('Request: ${options.method} ${options.path}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          _logger.d('Response: ${response.statusCode} ${response.requestOptions.path}');
          return handler.next(response);
        },
        onError: (error, handler) async {
          _logger.e('Error: ${error.response?.statusCode} ${error.message}');
          
          // Handle 401 Unauthorized - token expired
          if (error.response?.statusCode == 401) {
            // Try to refresh token
            final refreshed = await _refreshToken();
            if (refreshed) {
              // Retry the request
              return handler.resolve(await _retry(error.requestOptions));
            } else {
              // Refresh failed, logout user
              await _storage.clearAll();
              throw UnauthorizedException();
            }
          }
          
          return handler.next(error);
        },
      ),
    );
  }

  // Retry failed request after token refresh
  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );
    return _dio.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }

  // Refresh access token
  Future<bool> _refreshToken() async {
    try {
      final refreshToken = await _storage.getRefreshToken();
      if (refreshToken == null) return false;

      final response = await _dio.post(
        '/auth/refresh',
        data: {'refreshToken': refreshToken},
      );

      if (response.statusCode == 200 && response.data['success']) {
        final newToken = response.data['token'];
        await _storage.saveAccessToken(newToken);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // Check internet connectivity
  Future<bool> _hasConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  // Generic GET request
  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      if (!await _hasConnection()) {
        throw NetworkException();
      }

      final response = await _dio.get(path, queryParameters: queryParameters);
      
      if (response.statusCode == 200) {
        if (fromJson != null) {
          return fromJson(response.data);
        }
        return response.data as T;
      } else {
        throw ApiException(
          response.data['message'] ?? 'অজানা ত্রুটি ঘটেছে',
          response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // Generic POST request
  Future<T> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      if (!await _hasConnection()) {
        throw NetworkException();
      }

      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (fromJson != null) {
          return fromJson(response.data);
        }
        return response.data as T;
      } else {
        throw ApiException(
          response.data['message'] ?? 'অজানা ত্রুটি ঘটেছে',
          response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // Generic PUT request
  Future<T> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      if (!await _hasConnection()) {
        throw NetworkException();
      }

      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
      );

      if (response.statusCode == 200) {
        if (fromJson != null) {
          return fromJson(response.data);
        }
        return response.data as T;
      } else {
        throw ApiException(
          response.data['message'] ?? 'অজানা ত্রুটি ঘটেছে',
          response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // Generic DELETE request
  Future<T> delete<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      if (!await _hasConnection()) {
        throw NetworkException();
      }

      final response = await _dio.delete(path, queryParameters: queryParameters);

      if (response.statusCode == 200) {
        if (fromJson != null) {
          return fromJson(response.data);
        }
        return response.data as T;
      } else {
        throw ApiException(
          response.data['message'] ?? 'অজানা ত্রুটি ঘটেছে',
          response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // Upload file with multipart
  Future<T> uploadFile<T>(
    String path, {
    required List<String> filePaths,
    required String fieldName,
    Map<String, dynamic>? data,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      if (!await _hasConnection()) {
        throw NetworkException();
      }

      final formData = FormData();

      // Add files
      for (final filePath in filePaths) {
        formData.files.add(
          MapEntry(
            fieldName,
            await MultipartFile.fromFile(filePath),
          ),
        );
      }

      // Add other data
      if (data != null) {
        data.forEach((key, value) {
          formData.fields.add(MapEntry(key, value.toString()));
        });
      }

      final response = await _dio.post(path, data: formData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (fromJson != null) {
          return fromJson(response.data);
        }
        return response.data as T;
      } else {
        throw ApiException(
          response.data['message'] ?? 'অজানা ত্রুটি ঘটেছে',
          response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // Handle Dio errors
  Exception _handleDioError(DioException error) {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return NetworkException('সংযোগের সময় শেষ হয়ে গেছে');
    }

    if (error.type == DioExceptionType.unknown) {
      return NetworkException();
    }

    if (error.response != null) {
      final statusCode = error.response!.statusCode;
      final message = error.response!.data['message'] ?? 'অজানা ত্রুটি ঘটেছে';

      if (statusCode == 401) {
        return UnauthorizedException();
      }

      return ApiException(message, statusCode);
    }

    return ApiException('অজানা ত্রুটি ঘটেছে');
  }
}
