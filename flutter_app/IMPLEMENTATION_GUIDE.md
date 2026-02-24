# Step-by-Step Implementation Guide

This guide will help you complete the remaining features of the TradeNest app.

## Phase 1: Complete Product Listing (2-3 hours)

### 1.1 Update ProductsListScreen

Open `lib/screens/products/products_list_screen.dart` and implement:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/product_provider.dart';
import '../../widgets/product_card.dart';
import '../../widgets/loading_widget.dart';
import '../../config/constants.dart';

class ProductsListScreen extends ConsumerStatefulWidget {
  final String? type;
  final String? category;

  const ProductsListScreen({
    super.key,
    this.type,
    this.category,
  });

  @override
  ConsumerState<ProductsListScreen> createState() => _ProductsListScreenState();
}

class _ProductsListScreenState extends ConsumerState<ProductsListScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Set initial filters
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(productFiltersProvider.notifier).state = ProductFilters(
        type: widget.type,
        category: widget.category,
      );
    });

    // Pagination listener
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent * 0.9) {
        ref.read(productsNotifierProvider.notifier).loadMore();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productsState = ref.watch(productsNotifierProvider);
    final filters = ref.watch(productFiltersProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(_getTitle()),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilters(context),
          ),
        ],
      ),
      body: productsState.when(
        data: (products) {
          if (products.isEmpty) {
            return const EmptyWidget(
              message: 'কোন পণ্য পাওয়া যায়নি',
              icon: Icons.shopping_bag_outlined,
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              await ref.read(productsNotifierProvider.notifier).refresh();
            },
            child: GridView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                return ProductCard(
                  product: products[index],
                  onTap: () {
                    // Navigate to product details
                  },
                );
              },
            ),
          );
        },
        loading: () => const LoadingWidget(message: 'লোড হচ্ছে...'),
        error: (error, _) => ErrorWidget(
          message: error.toString(),
          onRetry: () {
            ref.read(productsNotifierProvider.notifier).refresh();
          },
        ),
      ),
    );
  }

  String _getTitle() {
    if (widget.type == 'rent') return 'ভাড়ার পণ্য';
    if (widget.type == 'sell') return 'বিক্রয়ের পণ্য';
    if (widget.category != null) {
      return AppConstants.categoriesBengali[widget.category] ?? '';
    }
    return 'সব পণ্য';
  }

  void _showFilters(BuildContext context) {
    // TODO: Implement filter bottom sheet
  }
}
```

### 1.2 Test Product Listing

1. Start backend server
2. Add some test products via Postman/API
3. Run app and navigate to products list
4. Verify pagination works

## Phase 2: Product Details Screen (2-3 hours)

### 2.1 Create Image Carousel Widget

Create `lib/widgets/image_carousel.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../config/constants.dart';

class ImageCarousel extends StatefulWidget {
  final List<String> images;

  const ImageCarousel({super.key, required this.images});

  @override
  State<ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty) {
      return Container(
        height: 300,
        color: Colors.grey[200],
        child: const Icon(Icons.image, size: 80),
      );
    }

    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: widget.images.length,
          itemBuilder: (context, index, realIndex) {
            return CachedNetworkImage(
              imageUrl: '${AppConstants.baseUrl}/${widget.images[index]}',
              fit: BoxFit.cover,
              width: double.infinity,
              placeholder: (context, url) => const Center(
                child: CircularProgressIndicator(),
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            );
          },
          options: CarouselOptions(
            height: 300,
            viewportFraction: 1.0,
            enableInfiniteScroll: widget.images.length > 1,
            onPageChanged: (index, reason) {
              setState(() => _currentIndex = index);
            },
          ),
        ),
        if (widget.images.length > 1)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.images.asMap().entries.map((entry) {
              return Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 4,
                ),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentIndex == entry.key
                      ? Theme.of(context).primaryColor
                      : Colors.grey[300],
                ),
              );
            }).toList(),
          ),
      ],
    );
  }
}
```

### 2.2 Implement Product Details

Update `lib/screens/products/product_details_screen.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../providers/product_provider.dart';
import '../../providers/app_provider.dart';
import '../../widgets/image_carousel.dart';
import '../../widgets/loading_widget.dart';
import '../../config/theme.dart';
import '../../config/constants.dart';
import '../../utils/helpers.dart';

class ProductDetailsScreen extends ConsumerWidget {
  final String productId;

  const ProductDetailsScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productAsync = ref.watch(productProvider(productId));
    final favorites = ref.watch(favoritesProvider);
    final isFavorite = favorites.contains(productId);

    return Scaffold(
      body: productAsync.when(
        data: (product) => CustomScrollView(
          slivers: [
            // App Bar
            SliverAppBar(
              expandedHeight: 300,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: ImageCarousel(images: product.images),
              ),
              actions: [
                IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : null,
                  ),
                  onPressed: () {
                    ref.read(favoritesProvider.notifier)
                        .toggleFavorite(productId);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.share),
                  onPressed: () {
                    // TODO: Implement share
                  },
                ),
              ],
            ),
            // Content
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(product.title, style: AppTheme.headingLarge),
                    const SizedBox(height: 12),
                    
                    // Price
                    Text(
                      product.getDisplayPrice(),
                      style: AppTheme.priceStyle.copyWith(fontSize: 28),
                    ),
                    if (product.type == AppConstants.typeRent)
                      Text(
                        '/ ${product.rentalPeriod == "daily" ? "দিন" : "মাস"}',
                        style: AppTheme.bodyMedium,
                      ),
                    
                    const Divider(height: 32),
                    
                    // Details
                    _buildDetailRow('Category', 
                        AppConstants.categoriesBengali[product.category] ?? ''),
                    _buildDetailRow('Condition',
                        AppConstants.conditionsBengali[product.condition] ?? ''),
                    _buildDetailRow('Location',
                        product.location.getFullLocation()),
                    _buildDetailRow('Posted',
                        Helpers.timeAgo(product.createdAt)),
                    _buildDetailRow('Views',
                        product.views.toString()),
                    
                    const Divider(height: 32),
                    
                    // Description
                    Text('বিস্তারিত বিবরণ', style: AppTheme.headingMedium),
                    const SizedBox(height: 12),
                    Text(product.description, style: AppTheme.bodyLarge),
                    
                    const SizedBox(height: 24),
                    
                    // Owner Info (if populated)
                    if (product.ownerDetails != null) ...[
                      Text('বিক্রেতার তথ্য', style: AppTheme.headingMedium),
                      const SizedBox(height: 12),
                      Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Text(product.ownerDetails!.name[0]),
                          ),
                          title: Text(product.ownerDetails!.name),
                          subtitle: Text(product.ownerDetails!.email),
                        ),
                      ),
                    ],
                    
                    const SizedBox(height: 100), // Space for bottom buttons
                  ],
                ),
              ),
            ),
          ],
        ),
        loading: () => const LoadingWidget(),
        error: (error, _) => ErrorWidget(message: error.toString()),
      ),
      bottomNavigationBar: productAsync.when(
        data: (product) => _buildBottomBar(context, product),
        loading: () => const SizedBox.shrink(),
        error: (_, __) => const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(label, style: AppTheme.bodyMedium),
          ),
          Expanded(
            flex: 3,
            child: Text(value, style: AppTheme.bodyLarge),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, product) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                // TODO: Implement call
              },
              icon: const Icon(Icons.phone),
              label: const Text('কল করুন'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {
                // TODO: Implement message
              },
              icon: const Icon(Icons.message),
              label: const Text('মেসেজ'),
            ),
          ),
        ],
      ),
    );
  }
}
```

## Phase 3: Create Product Form (3-4 hours)

### 3.1 Install Image Picker

Already in pubspec.yaml, but configure permissions:

**Android** - Add to `android/app/src/main/AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.CAMERA"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
```

**iOS** - Add to `ios/Runner/Info.plist`:
```xml
<key>NSPhotoLibraryUsageDescription</key>
<string>We need access to your photos to upload product images</string>
<key>NSCameraUsageDescription</key>
<string>We need access to your camera to take product photos</string>
```

### 3.2 Create Image Picker Widget

Create `lib/widgets/image_picker_widget.dart`:

```dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerWidget extends StatefulWidget {
  final Function(List<File>) onImagesSelected;
  final int maxImages;

  const ImagePickerWidget({
    super.key,
    required this.onImagesSelected,
    this.maxImages = 5,
  });

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  final List<File> _selectedImages = [];
  final _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    if (_selectedImages.length >= widget.maxImages) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('সর্বোচ্চ ${widget.maxImages}টি ছবি যোগ করতে পারবেন')),
      );
      return;
    }

    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _selectedImages.add(File(pickedFile.path));
      });
      widget.onImagesSelected(_selectedImages);
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
    widget.onImagesSelected(_selectedImages);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_selectedImages.isNotEmpty)
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _selectedImages.length,
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: FileImage(_selectedImages[index]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 12,
                      child: IconButton(
                        icon: const Icon(Icons.cancel, color: Colors.red),
                        onPressed: () => _removeImage(index),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        const SizedBox(height: 12),
        Row(
          children: [
            ElevatedButton.icon(
              onPressed: () => _pickImage(ImageSource.camera),
              icon: const Icon(Icons.camera_alt),
              label: const Text('ক্যামেরা'),
            ),
            const SizedBox(width: 12),
            ElevatedButton.icon(
              onPressed: () => _pickImage(ImageSource.gallery),
              icon: const Icon(Icons.photo_library),
              label: const Text('গ্যালারি'),
            ),
          ],
        ),
      ],
    );
  }
}
```

### 3.3 Implement Create Product Form

Update `lib/screens/products/create_product_screen.dart`:

```dart
// See full implementation in the next section
// This involves creating a comprehensive form with all product fields
```

## Phase 4: Testing & Debugging (1-2 hours)

### 4.1 Test Checklist

- [ ] Registration with valid data
- [ ] Login with correct credentials
- [ ] Browse products with filters
- [ ] View product details
- [ ] Create new product
- [ ] Add/remove favorites
- [ ] Pagination works
- [ ] Image upload works
- [ ] Error handling displays correctly

### 4.2 Common Issues & Solutions

See QUICKSTART.md for troubleshooting guide.

## Phase 5: Polish & Deployment (2-3 hours)

### 5.1 Add App Icon

Use `flutter_launcher_icons` package:

```yaml
# Add to pubspec.yaml
dev_dependencies:
  flutter_launcher_icons: ^0.13.1

flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/icons/app_icon.png"
```

Run:
```bash
flutter pub run flutter_launcher_icons
```

### 5.2 Build Release APK

```bash
flutter build apk --release
```

APK location: `build/app/outputs/flutter-apk/app-release.apk`

---

## 📚 Additional Resources

- See README.md for complete documentation
- Check individual files for inline comments
- Refer to Flutter/Riverpod docs for advanced patterns

**Happy Coding! 🚀**
