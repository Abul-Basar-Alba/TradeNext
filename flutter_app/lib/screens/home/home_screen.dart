import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../config/theme.dart';
import '../../config/constants.dart';
import '../../config/app_strings.dart';
import '../../providers/auth_provider.dart';
import '../../providers/language_provider.dart';
import '../../providers/products_list_provider.dart';
import '../../widgets/loading_widget.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);
    final authState = ref.watch(authNotifierProvider);
    final isLoggedIn = authState.value != null;
    
    String tr(String key) => AppStrings.translate(key, language);

    return Scaffold(
      appBar: AppBar(
        title: Text(language == 'bn' ? 'ট্রেডনেস্ট' : 'TradeNest'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Notifications
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: tr('search_placeholder'),
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                ),
                readOnly: true,
                onTap: () {
                  // Will switch to search tab
                },
              ),
            ),
            const SizedBox(height: 16),
            // Main Options
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: _OptionCard(
                      title: tr('rent_now'),
                      icon: Icons.shopping_bag_outlined,
                      color: Colors.blue,
                      onTap: () => context.push('/products?type=rent'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _OptionCard(
                      title: tr('buy_sell'),
                      icon: Icons.sell_outlined,
                      color: Colors.green,
                      onTap: () => context.push('/products?type=sell'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // Categories
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(tr('categories'), style: AppTheme.headingMedium),
                  TextButton(
                    onPressed: () {
                      // View all categories
                    },
                    child: Text(tr('view_all')),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: AppConstants.categories.length,
                itemBuilder: (context, index) {
                  final category = AppConstants.categories[index];
                  return _CategoryCard(
                    category: category,
                    onTap: () => context.push('/products?category=$category'),
                  );
                },
              ),
            ),
            const SizedBox(height: 32),
            // Featured Products Section - Real Firestore Data
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(tr('recent_ads'), style: AppTheme.headingMedium),
                  TextButton(
                    onPressed: () => context.push('/products'),
                    child: Text(tr('view_all')),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Load Products from Supabase
            Consumer(
              builder: (context, ref, child) {
                final productsAsync = ref.watch(allProductsProvider);

                return productsAsync.when(
                  data: (products) {
                    if (products.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Center(
                          child: Column(
                            children: [
                              const Icon(Icons.inbox_outlined, size: 64, color: Colors.grey),
                              const SizedBox(height: 16),
                              Text(
                                tr('no_ads'),
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.75,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: products.length > 6 ? 6 : products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return _ProductCard(product: product);
                      },
                    );
                  },
                  loading: () => const LoadingWidget(),
                  error: (error, stack) => Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline, size: 48, color: Colors.red),
                          const SizedBox(height: 16),
                          Text(
                            language == 'bn' ? 'লোড করতে সমস্যা হয়েছে' : 'Failed to load',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => ref.refresh(allProductsProvider),
                            child: Text(language == 'bn' ? 'আবার চেষ্টা করুন' : 'Retry'),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _OptionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _OptionCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Icon(icon, size: 48, color: color),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final String category;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: 12),
      child: Card(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _getCategoryIcon(category),
                style: const TextStyle(fontSize: 32),
              ),
              const SizedBox(height: 8),
              Text(
                AppConstants.categoriesBengali[category] ?? category,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 11),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getCategoryIcon(String category) {
    switch (category) {
      case 'vehicles':
        return '🚗';
      case 'property':
        return '🏠';
      case 'electronics':
        return '📱';
      case 'fashion':
        return '👕';
      case 'furniture':
        return '🪑';
      case 'event-equipment':
        return '🎪';
      default:
        return '📦';
    }
  }
}

// Simple Product Card Widget
class _ProductCard extends StatelessWidget {
  final Map<String, dynamic> product;

  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    final images = product['images'] as List<dynamic>?;
    final imageUrl = images != null && images.isNotEmpty ? images[0] as String : '';
    final price = product['price'];
    final title = product['title'] ?? 'No Title';

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          // TODO: Navigate to product details
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Expanded(
              flex: 3,
              child: imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[200],
                          child: const Icon(Icons.image_not_supported, size: 48, color: Colors.grey),
                        );
                      },
                    )
                  : Container(
                      color: Colors.grey[200],
                      child: const Icon(Icons.image, size: 48, color: Colors.grey),
                    ),
            ),
            // Product Info
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '৳ ${price?.toString() ?? '0'}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF23E5DB),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
