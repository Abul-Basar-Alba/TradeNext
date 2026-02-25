import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import '../models/product.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Collections
  static const String productsCollection = 'products';
  static const String usersCollection = 'users';
  static const String categoriesCollection = 'categories';

  // ============= PRODUCTS =============

  // Create Product
  Future<String> createProduct(Product product) async {
    try {
      final docRef = await _firestore.collection(productsCollection).add({
        'title': product.title,
        'description': product.description,
        'price': product.price,
        'category': product.category,
        'condition': product.condition,
        'type': product.type,
        'location': product.location,
        'images': product.images,
        'ownerId': product.ownerId,
        'ownerName': product.ownerName,
        'ownerPhone': product.ownerPhone,
        'status': product.status,
        'views': product.views ?? 0,
        'isFeatured': product.isFeatured ?? false,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create product: $e');
    }
  }

  // Get Products (with pagination)
  Stream<List<Product>> getProducts({
    String? category,
    String? type,
    String? status,
    int limit = 20,
  }) {
    try {
      Query query = _firestore
          .collection(productsCollection)
          .where('status', isEqualTo: status ?? 'active')
          .orderBy('createdAt', descending: true)
          .limit(limit);

      if (category != null && category.isNotEmpty) {
        query = query.where('category', isEqualTo: category);
      }

      if (type != null && type.isNotEmpty) {
        query = query.where('type', isEqualTo: type);
      }

      return query.snapshots().map((snapshot) {
        return snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return Product.fromJson({
            'id': doc.id,
            ...data,
            'createdAt': (data['createdAt'] as Timestamp?)?.toDate().toIso8601String(),
            'updatedAt': (data['updatedAt'] as Timestamp?)?.toDate().toIso8601String(),
          });
        }).toList();
      });
    } catch (e) {
      throw Exception('Failed to get products: $e');
    }
  }

  // Get Product by ID
  Future<Product?> getProductById(String id) async {
    try {
      final doc = await _firestore.collection(productsCollection).doc(id).get();
      
      if (!doc.exists) return null;

      final data = doc.data() as Map<String, dynamic>;
      return Product.fromJson({
        'id': doc.id,
        ...data,
        'createdAt': (data['createdAt'] as Timestamp?)?.toDate().toIso8601String(),
        'updatedAt': (data['updatedAt'] as Timestamp?)?.toDate().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to get product: $e');
    }
  }

  // Update Product
  Future<void> updateProduct(String id, Map<String, dynamic> data) async {
    try {
      await _firestore.collection(productsCollection).doc(id).update({
        ...data,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to update product: $e');
    }
  }

  // Delete Product
  Future<void> deleteProduct(String id) async {
    try {
      await _firestore.collection(productsCollection).doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete product: $e');
    }
  }

  // Increment views
  Future<void> incrementViews(String productId) async {
    try {
      await _firestore.collection(productsCollection).doc(productId).update({
        'views': FieldValue.increment(1),
      });
    } catch (e) {
      throw Exception('Failed to increment views: $e');
    }
  }

  // Search Products
  Stream<List<Product>> searchProducts(String searchTerm) {
    try {
      return _firestore
          .collection(productsCollection)
          .where('status', isEqualTo: 'active')
          .orderBy('title')
          .startAt([searchTerm])
          .endAt(['$searchTerm\uf8ff'])
          .limit(20)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          final data = doc.data();
          return Product.fromJson({
            'id': doc.id,
            ...data,
            'createdAt': (data['createdAt'] as Timestamp?)?.toDate().toIso8601String(),
            'updatedAt': (data['updatedAt'] as Timestamp?)?.toDate().toIso8601String(),
          });
        }).toList();
      });
    } catch (e) {
      throw Exception('Failed to search products: $e');
    }
  }

  // Get User Products
  Stream<List<Product>> getUserProducts(String userId) {
    try {
      return _firestore
          .collection(productsCollection)
          .where('ownerId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          final data = doc.data();
          return Product.fromJson({
            'id': doc.id,
            ...data,
            'createdAt': (data['createdAt'] as Timestamp?)?.toDate().toIso8601String(),
            'updatedAt': (data['updatedAt'] as Timestamp?)?.toDate().toIso8601String(),
          });
        }).toList();
      });
    } catch (e) {
      throw Exception('Failed to get user products: $e');
    }
  }

  // ============= IMAGE UPLOAD =============

  // Upload single image
  Future<String> uploadImage(File imageFile, String path) async {
    try {
      final ref = _storage.ref().child(path);
      final uploadTask = await ref.putFile(imageFile);
      final downloadUrl = await uploadTask.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }

  // Upload multiple images
  Future<List<String>> uploadImages(List<File> imageFiles, String productId) async {
    try {
      final uploadedUrls = <String>[];

      for (var i = 0; i < imageFiles.length; i++) {
        final path = 'products/$productId/image_$i.jpg';
        final url = await uploadImage(imageFiles[i], path);
        uploadedUrls.add(url);
      }

      return uploadedUrls;
    } catch (e) {
      throw Exception('Failed to upload images: $e');
    }
  }

  // Delete image
  Future<void> deleteImage(String imageUrl) async {
    try {
      final ref = _storage.refFromURL(imageUrl);
      await ref.delete();
    } catch (e) {
      throw Exception('Failed to delete image: $e');
    }
  }

  // ============= USER FAVORITES =============

  // Add to favorites
  Future<void> addToFavorites(String userId, String productId) async {
    try {
      await _firestore
          .collection(usersCollection)
          .doc(userId)
          .collection('favorites')
          .doc(productId)
          .set({
        'productId': productId,
        'addedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to add to favorites: $e');
    }
  }

  // Remove from favorites
  Future<void> removeFromFavorites(String userId, String productId) async {
    try {
      await _firestore
          .collection(usersCollection)
          .doc(userId)
          .collection('favorites')
          .doc(productId)
          .delete();
    } catch (e) {
      throw Exception('Failed to remove from favorites: $e');
    }
  }

  // Get user favorites
  Stream<List<String>> getUserFavorites(String userId) {
    try {
      return _firestore
          .collection(usersCollection)
          .doc(userId)
          .collection('favorites')
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) => doc.id).toList();
      });
    } catch (e) {
      throw Exception('Failed to get favorites: $e');
    }
  }

  // ============= STATISTICS =============

  // Get products count by category
  Future<Map<String, int>> getProductCountByCategory() async {
    try {
      final snapshot = await _firestore
          .collection(productsCollection)
          .where('status', isEqualTo: 'active')
          .get();

      final counts = <String, int>{};
      for (var doc in snapshot.docs) {
        final category = doc.data()['category'] as String?;
        if (category != null) {
          counts[category] = (counts[category] ?? 0) + 1;
        }
      }

      return counts;
    } catch (e) {
      throw Exception('Failed to get category counts: $e');
    }
  }
}
