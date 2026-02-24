import '../models/product.dart';
import '../models/api_response.dart';
import 'api_service.dart';

class ProductService {
  final _api = ApiService();

  // Get all products with filters
  Future<PaginatedResponse<Product>> getProducts({
    String? type,
    String? category,
    double? minPrice,
    double? maxPrice,
    String? location,
    String? search,
    int page = 1,
    int limit = 20,
    String? sort,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page.toString(),
        'limit': limit.toString(),
        if (type != null) 'type': type,
        if (category != null) 'category': category,
        if (minPrice != null) 'minPrice': minPrice.toString(),
        if (maxPrice != null) 'maxPrice': maxPrice.toString(),
        if (location != null) 'location': location,
        if (search != null) 'search': search,
        if (sort != null) 'sort': sort,
      };

      final response = await _api.get(
        '/products',
        queryParameters: queryParams,
        fromJson: (json) {
          if (json['success'] == true && json['data'] != null) {
            final data = json['data'];
            return PaginatedResponse<Product>.fromJson(
              data,
              (json) => Product.fromJson(json as Map<String, dynamic>),
            );
          }
          throw ApiException(json['message'] ?? 'Failed to load products');
        },
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Get product by ID
  Future<Product> getProductById(String id) async {
    try {
      final response = await _api.get(
        '/products/$id',
        fromJson: (json) => ApiResponse<Map<String, dynamic>>.fromJson(
          json,
          (data) => data as Map<String, dynamic>,
        ),
      );

      if (response.success && response.data != null) {
        return Product.fromJson(response.data!);
      } else {
        throw ApiException(response.message);
      }
    } catch (e) {
      rethrow;
    }
  }

  // Create new product
  Future<Product> createProduct({
    required String title,
    required String description,
    required String category,
    required String type,
    required double price,
    double? rentalPrice,
    String? rentalPeriod,
    required String condition,
    required String city,
    String? area,
    List<String>? imagePaths,
  }) async {
    try {
      final data = {
        'title': title,
        'description': description,
        'category': category,
        'type': type,
        'price': price,
        if (rentalPrice != null) 'rentalPrice': rentalPrice,
        if (rentalPeriod != null) 'rentalPeriod': rentalPeriod,
        'condition': condition,
        'location': {
          'city': city,
          if (area != null) 'area': area,
        },
      };

      // If images are provided, use multipart upload
      if (imagePaths != null && imagePaths.isNotEmpty) {
        final response = await _api.uploadFile(
          '/products',
          filePaths: imagePaths,
          fieldName: 'images',
          data: data,
          fromJson: (json) => ApiResponse<Map<String, dynamic>>.fromJson(
            json,
            (data) => data as Map<String, dynamic>,
          ),
        );

        if (response.success && response.data != null) {
          return Product.fromJson(response.data!);
        } else {
          throw ApiException(response.message);
        }
      } else {
        // No images, use regular POST
        final response = await _api.post(
          '/products',
          data: data,
          fromJson: (json) => ApiResponse<Map<String, dynamic>>.fromJson(
            json,
            (data) => data as Map<String, dynamic>,
          ),
        );

        if (response.success && response.data != null) {
          return Product.fromJson(response.data!);
        } else {
          throw ApiException(response.message);
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  // Update product
  Future<Product> updateProduct({
    required String id,
    String? title,
    String? description,
    String? category,
    String? type,
    double? price,
    double? rentalPrice,
    String? rentalPeriod,
    String? condition,
    String? city,
    String? area,
    String? status,
    List<String>? imagePaths,
  }) async {
    try {
      final data = <String, dynamic>{
        if (title != null) 'title': title,
        if (description != null) 'description': description,
        if (category != null) 'category': category,
        if (type != null) 'type': type,
        if (price != null) 'price': price,
        if (rentalPrice != null) 'rentalPrice': rentalPrice,
        if (rentalPeriod != null) 'rentalPeriod': rentalPeriod,
        if (condition != null) 'condition': condition,
        if (status != null) 'status': status,
        if (city != null || area != null)
          'location': {
            if (city != null) 'city': city,
            if (area != null) 'area': area,
          },
      };

      // If images are provided, use multipart upload
      if (imagePaths != null && imagePaths.isNotEmpty) {
        final response = await _api.uploadFile(
          '/products/$id',
          filePaths: imagePaths,
          fieldName: 'images',
          data: data,
          fromJson: (json) => ApiResponse<Map<String, dynamic>>.fromJson(
            json,
            (data) => data as Map<String, dynamic>,
          ),
        );

        if (response.success && response.data != null) {
          return Product.fromJson(response.data!);
        } else {
          throw ApiException(response.message);
        }
      } else {
        // No images, use regular PUT
        final response = await _api.put(
          '/products/$id',
          data: data,
          fromJson: (json) => ApiResponse<Map<String, dynamic>>.fromJson(
            json,
            (data) => data as Map<String, dynamic>,
          ),
        );

        if (response.success && response.data != null) {
          return Product.fromJson(response.data!);
        } else {
          throw ApiException(response.message);
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  // Delete product
  Future<void> deleteProduct(String id) async {
    try {
      final response = await _api.delete(
        '/products/$id',
        fromJson: (json) => ApiResponse<Map<String, dynamic>>.fromJson(
          json,
          (data) => data as Map<String, dynamic>,
        ),
      );

      if (!response.success) {
        throw ApiException(response.message);
      }
    } catch (e) {
      rethrow;
    }
  }

  // Get user's products
  Future<List<Product>> getMyProducts() async {
    try {
      final response = await _api.get(
        '/products/my/products',
        fromJson: (json) {
          if (json['success'] == true && json['data'] != null) {
            final products = (json['data'] as List)
                .map((item) => Product.fromJson(item as Map<String, dynamic>))
                .toList();
            return products;
          }
          throw ApiException(json['message'] ?? 'Failed to load products');
        },
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }
}
