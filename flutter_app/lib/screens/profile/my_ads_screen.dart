import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_provider.dart';
import '../../providers/products_list_provider.dart';
import '../../config/app_colors.dart';

class MyAdsScreen extends ConsumerWidget {
  const MyAdsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(languageProvider);
    final user = ref.watch(authProvider);
    
    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(lang == 'bn' ? 'আমার বিজ্ঞাপনসমূহ' : 'My Ads'),
        ),
        body: Center(
          child: Text(lang == 'bn' ? 'দয়া করে লগইন করুন' : 'Please login'),
        ),
      );
    }

    final myProductsAsync = ref.watch(myProductsProvider(user.uid));

    return Scaffold(
      appBar: AppBar(
        title: Text(lang == 'bn' ? 'আমার বিজ্ঞাপনসমূহ' : 'My Ads'),
      ),
      body: myProductsAsync.when(
        data: (products) {
          if (products.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    lang == 'bn' ? 'কোন বিজ্ঞাপন নেই' : 'No ads yet',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(myProductsProvider(user.uid));
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return _MyAdCard(product: product);
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(lang == 'bn' ? 'কিছু ভুল হয়েছে' : 'Something went wrong'),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => ref.invalidate(myProductsProvider(user.uid)),
                child: Text(lang == 'bn' ? 'আবার চেষ্টা করুন' : 'Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MyAdCard extends StatelessWidget {
  final Map<String, dynamic> product;

  const _MyAdCard({required this.product});

  @override
  Widget build(BuildContext context) {
    final images = product['images'] as List<dynamic>?;
    final imageUrl = (images != null && images.isNotEmpty) ? images[0] : null;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          // TODO: Navigate to product details or edit
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Product Image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: imageUrl != null
                    ? Image.network(
                        imageUrl,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 80,
                            height: 80,
                            color: Colors.grey[300],
                            child: const Icon(Icons.image, size: 40, color: Colors.grey),
                          );
                        },
                      )
                    : Container(
                        width: 80,
                        height: 80,
                        color: Colors.grey[300],
                        child: const Icon(Icons.image, size: 40, color: Colors.grey),
                      ),
              ),
              const SizedBox(width: 12),
              
              // Product Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product['title'] ?? 'No title',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '৳${product['price']?.toString() ?? '0'}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product['condition'] ?? '',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              
              // Action Buttons
              Column(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, size: 20),
                    onPressed: () {
                      // TODO: Navigate to edit screen
                    },
                    color: AppColors.primary,
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, size: 20),
                    onPressed: () {
                      // TODO: Show delete confirmation
                    },
                    color: Colors.red,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
