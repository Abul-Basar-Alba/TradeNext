import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../config/theme.dart';
import '../../config/constants.dart';
import '../../providers/auth_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ট্রেডনেস্ট'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Notifications
            },
          ),
          IconButton(
            icon: const Icon(Icons.person_outlined),
            onPressed: () => context.push('/profile'),
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
                  hintText: 'আপনি কি খুঁজছেন?',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onTap: () => context.push('/products'),
              ),
            ),
            // Welcome Message
            if (authState.value != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'স্বাগতম, ${authState.value!.name}!',
                  style: AppTheme.headingMedium,
                ),
              ),
            const SizedBox(height: 24),
            // Main Options
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: _OptionCard(
                      title: 'ভাড়া নিন',
                      icon: Icons.shopping_bag_outlined,
                      color: Colors.blue,
                      onTap: () => context.push('/products?type=rent'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _OptionCard(
                      title: 'কিনুন বা বিক্রয় করুন',
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
                  Text('ক্যাটাগরি', style: AppTheme.headingMedium),
                  TextButton(
                    onPressed: () => context.push('/products'),
                    child: const Text('সব দেখুন'),
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
            // Featured Products Section (TODO)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text('জনপ্রিয় বিজ্ঞাপন', style: AppTheme.headingMedium),
            ),
            const SizedBox(height: 16),
            const Center(
              child: Text('লোড হচ্ছে...'),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/products/create'),
        icon: const Icon(Icons.add),
        label: const Text('বিজ্ঞাপন দিন'),
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
