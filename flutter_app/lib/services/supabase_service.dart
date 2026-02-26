import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tradenest/config/supabase_config.dart';
import 'package:tradenest/models/product.dart';

class SupabaseService {
  final SupabaseClient _client = SupabaseConfig.client;

  // ==========================================
  // PRODUCT CRUD OPERATIONS
  // ==========================================

  /// Create a new product
  Future<Product> createProduct(Product product) async {
    try {
      final response = await _client
          .from('products')
          .insert({
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'category': product.category,
            'type': product.type,
            'condition': product.condition,
            'status': product.status ?? 'active',
            'owner_id': product.ownerId,
            'owner_name': product.ownerName,
            'owner_phone': product.ownerPhone,
            'owner_email': product.ownerName, // Using ownerName temporarily
            'location': product.location.getFullLocation(),
            'division': product.location.city,
            'district': product.location.area ?? product.location.city,
            'images': product.images,
            'featured': product.featured,
          })
          .select()
          .single();

      return Product.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create product: $e');
    }
  }

  /// Get all products with optional filters
  Stream<List<Product>> getProducts({
    String? category,
    String? type,
    String? status = 'active',
    int limit = 20,
  }) {
    try {
      var query = _client
          .from('products')
          .stream(primaryKey: ['id'])
          .order('created_at', ascending: false)
          .limit(limit);

      return query.map((data) {
        return data.map((item) => Product.fromJson(item)).toList();
      });
    } catch (e) {
      throw Exception('Failed to get products: $e');
    }
  }

  /// Get a single product by ID
  Future<Product> getProductById(String id) async {
    try {
      final response = await _client
          .from('products')
          .select()
          .eq('id', id)
          .single();

      return Product.fromJson(response);
    } catch (e) {
      throw Exception('Failed to get product: $e');
    }
  }

  /// Update product
  Future<Product> updateProduct(String id, Map<String, dynamic> updates) async {
    try {
      final response = await _client
          .from('products')
          .update(updates)
          .eq('id', id)
          .select()
          .single();

      return Product.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update product: $e');
    }
  }

  /// Delete product
  Future<void> deleteProduct(String id) async {
    try {
      await _client.from('products').delete().eq('id', id);
    } catch (e) {
      throw Exception('Failed to delete product: $e');
    }
  }

  /// Increment product views
  Future<void> incrementViews(String id) async {
    try {
      await _client.rpc('increment_views', params: {'product_id': id});
    } catch (e) {
      // Ignore view increment errors
      print('Failed to increment views: $e');
    }
  }

  /// Search products
  Stream<List<Product>> searchProducts(String query) {
    try {
      // Using simple filter for now
      return _client
          .from('products')
          .stream(primaryKey: ['id'])
          .order('created_at', ascending: false)
          .map((data) {
        // Client-side filtering
        return data
            .map((item) => Product.fromJson(item))
            .where((product) => 
                product.title.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    } catch (e) {
      throw Exception('Failed to search products: $e');
    }
  }

  /// Get products by owner
  Stream<List<Product>> getUserProducts(String ownerId) {
    try {
      return _client
          .from('products')
          .stream(primaryKey: ['id'])
          .eq('owner_id', ownerId)
          .order('created_at', ascending: false)
          .map((data) {
        return data.map((item) => Product.fromJson(item)).toList();
      });
    } catch (e) {
      throw Exception('Failed to get user products: $e');
    }
  }

  // ==========================================
  // STORAGE OPERATIONS
  // ==========================================

  /// Upload a single image to Supabase Storage
  Future<String> uploadImage(File file, String fileName) async {
    try {
      final path = 'products/$fileName';
      
      await _client.storage
          .from('product-images')
          .upload(path, file);

      final publicUrl = _client.storage
          .from('product-images')
          .getPublicUrl(path);

      return publicUrl;
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }

  /// Upload multiple images
  Future<List<String>> uploadImages(List<File> files) async {
    try {
      final urls = <String>[];
      
      for (var i = 0; i < files.length; i++) {
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final fileName = 'image_${timestamp}_$i.jpg';
        final url = await uploadImage(files[i], fileName);
        urls.add(url);
      }
      
      return urls;
    } catch (e) {
      throw Exception('Failed to upload images: $e');
    }
  }

  /// Delete an image from storage
  Future<void> deleteImage(String imageUrl) async {
    try {
      // Extract path from URL
      final uri = Uri.parse(imageUrl);
      final path = uri.pathSegments.last;
      
      await _client.storage
          .from('product-images')
          .remove(['products/$path']);
    } catch (e) {
      print('Failed to delete image: $e');
    }
  }

  // ==========================================
  // FAVORITES OPERATIONS
  // ==========================================

  /// Add product to favorites
  Future<void> addToFavorites(String userId, String productId) async {
    try {
      await _client.from('favorites').insert({
        'user_id': userId,
        'product_id': productId,
      });
    } catch (e) {
      throw Exception('Failed to add to favorites: $e');
    }
  }

  /// Remove from favorites
  Future<void> removeFromFavorites(String userId, String productId) async {
    try {
      await _client
          .from('favorites')
          .delete()
          .eq('user_id', userId)
          .eq('product_id', productId);
    } catch (e) {
      throw Exception('Failed to remove from favorites: $e');
    }
  }

  /// Get user's favorite product IDs
  Stream<List<String>> getUserFavorites(String userId) {
    try {
      return _client
          .from('favorites')
          .stream(primaryKey: ['id'])
          .eq('user_id', userId)
          .map((data) {
        return data.map((item) => item['product_id'] as String).toList();
      });
    } catch (e) {
      throw Exception('Failed to get favorites: $e');
    }
  }

  // ==========================================
  // STATISTICS
  // ==========================================

  /// Get product count by category
  Future<Map<String, int>> getProductCountByCategory() async {
    try {
      final response = await _client
          .from('products')
          .select('category')
          .eq('status', 'active');

      final counts = <String, int>{};
      for (var item in response) {
        final category = item['category'] as String;
        counts[category] = (counts[category] ?? 0) + 1;
      }

      return counts;
    } catch (e) {
      throw Exception('Failed to get category counts: $e');
    }
  }
}
