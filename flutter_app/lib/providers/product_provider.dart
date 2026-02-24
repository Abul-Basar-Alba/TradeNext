import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product.dart';
import '../models/api_response.dart';
import '../services/product_service.dart';
import '../config/constants.dart';

// Product Service Provider
final productServiceProvider = Provider<ProductService>((ref) {
  return ProductService();
});

// Product Filter State
class ProductFilters {
  final String? type;
  final String? category;
  final double? minPrice;
  final double? maxPrice;
  final String? location;
  final String? search;
  final String? sort;

  ProductFilters({
    this.type,
    this.category,
    this.minPrice,
    this.maxPrice,
    this.location,
    this.search,
    this.sort,
  });

  ProductFilters copyWith({
    String? type,
    String? category,
    double? minPrice,
    double? maxPrice,
    String? location,
    String? search,
    String? sort,
  }) {
    return ProductFilters(
      type: type ?? this.type,
      category: category ?? this.category,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      location: location ?? this.location,
      search: search ?? this.search,
      sort: sort ?? this.sort,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (type != null) 'type': type,
      if (category != null) 'category': category,
      if (minPrice != null) 'minPrice': minPrice,
      if (maxPrice != null) 'maxPrice': maxPrice,
      if (location != null) 'location': location,
      if (search != null) 'search': search,
      if (sort != null) 'sort': sort,
    };
  }
}

// Product Filter Provider
final productFiltersProvider = StateProvider<ProductFilters>((ref) {
  return ProductFilters();
});

// Products List Notifier
class ProductsNotifier extends StateNotifier<AsyncValue<List<Product>>> {
  final ProductService _productService;
  final Ref _ref;
  int _currentPage = 1;
  bool _hasMore = true;
  List<Product> _allProducts = [];

  ProductsNotifier(this._productService, this._ref)
      : super(const AsyncValue.loading()) {
    loadProducts();
  }

  // Load products with filters
  Future<void> loadProducts({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
      _hasMore = true;
      _allProducts = [];
      state = const AsyncValue.loading();
    }

    if (!_hasMore) return;

    try {
      final filters = _ref.read(productFiltersProvider);
      
      final response = await _productService.getProducts(
        type: filters.type,
        category: filters.category,
        minPrice: filters.minPrice,
        maxPrice: filters.maxPrice,
        location: filters.location,
        search: filters.search,
        sort: filters.sort,
        page: _currentPage,
        limit: AppConstants.defaultPageSize,
      );

      _allProducts.addAll(response.products);
      _hasMore = response.hasMore;
      _currentPage++;

      state = AsyncValue.data(_allProducts);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  // Load more products (pagination)
  Future<void> loadMore() async {
    if (!_hasMore || state.isLoading) return;
    await loadProducts();
  }

  // Refresh products
  Future<void> refresh() async {
    await loadProducts(refresh: true);
  }

  bool get hasMore => _hasMore;
}

// Products Notifier Provider
final productsNotifierProvider =
    StateNotifierProvider<ProductsNotifier, AsyncValue<List<Product>>>((ref) {
  final productService = ref.read(productServiceProvider);
  return ProductsNotifier(productService, ref);
});

// Single Product Provider
final productProvider = FutureProvider.family<Product, String>((ref, id) async {
  final productService = ref.read(productServiceProvider);
  return await productService.getProductById(id);
});

// My Products Provider
final myProductsProvider = FutureProvider<List<Product>>((ref) async {
  final productService = ref.read(productServiceProvider);
  return await productService.getMyProducts();
});

// Create Product Provider
final createProductProvider = Provider<ProductService>((ref) {
  return ref.read(productServiceProvider);
});

// Update Product Provider
final updateProductProvider = Provider<ProductService>((ref) {
  return ref.read(productServiceProvider);
});

// Delete Product Provider
final deleteProductProvider = Provider<ProductService>((ref) {
  return ref.read(productServiceProvider);
});
