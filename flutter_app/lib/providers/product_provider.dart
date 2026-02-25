import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product.dart';
import '../services/firestore_service.dart';

// Firestore Service Provider
final firestoreServiceProvider = Provider<FirestoreService>((ref) {
  return FirestoreService();
});

// Product Filter State
class ProductFilters {
  final String? type;
  final String? category;
  final String? status;
  final int? limit;

  ProductFilters({
    this.type,
    this.category,
    this.status,
    this.limit,
  });

  ProductFilters copyWith({
    String? type,
    String? category,
    String? status,
    int? limit,
  }) {
    return ProductFilters(
      type: type ?? this.type,
      category: category ?? this.category,
      status: status ?? this.status,
      limit: limit ?? this.limit,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductFilters &&
          runtimeType == other.runtimeType &&
          category == other.category &&
          type == other.type &&
          status == other.status &&
          limit == other.limit;

  @override
  int get hashCode =>
      category.hashCode ^ type.hashCode ^ status.hashCode ^ limit.hashCode;

}

// Default filters
final ProductFilters defaultFilters = ProductFilters(
  status: 'active',
  limit: 20,
);

// Product Filter Provider
final productFiltersProvider = StateProvider<ProductFilters>((ref) {
  return defaultFilters;
});

// Products Stream Provider - Real-time from Firestore
final productsProvider = StreamProvider<List<Product>>((ref) {
  final firestoreService = ref.watch(firestoreServiceProvider);
  final filters = ref.watch(productFiltersProvider);
  
  return firestoreService.getProducts(
    category: filters.category,
    type: filters.type,
    status: filters.status ?? 'active',
    limit: filters.limit ?? 20,
  );
});

// Single Product Provider
final productByIdProvider = FutureProvider.family<Product?, String>((ref, productId) async {
  final firestoreService = ref.read(firestoreServiceProvider);
  
  // Increment views
  await firestoreService.incrementViews(productId);
  
  return await firestoreService.getProductById(productId);
});

// User Products Provider
final userProductsProvider = StreamProvider.family<List<Product>, String>((ref, userId) {
  final firestoreService = ref.watch(firestoreServiceProvider);
  return firestoreService.getUserProducts(userId);
});

// Search Products Provider
final searchProductsProvider = StreamProvider.family<List<Product>, String>((ref, searchTerm) {
  final firestoreService = ref.watch(firestoreServiceProvider);
  
  if (searchTerm.isEmpty) {
    return Stream.value([]);
  }
  
  return firestoreService.searchProducts(searchTerm);
});

// User Favorites Provider
final userFavoritesProvider = StreamProvider.family<List<String>, String>((ref, userId) {
  final firestoreService = ref.watch(firestoreServiceProvider);
  return firestoreService.getUserFavorites(userId);
});

// Category Counts Provider
final categoryCountsProvider = FutureProvider<Map<String, int>>((ref) async {
  final firestoreService = ref.read(firestoreServiceProvider);
  return await firestoreService.getProductCountByCategory();
});
