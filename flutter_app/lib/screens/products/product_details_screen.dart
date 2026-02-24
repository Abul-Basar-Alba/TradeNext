import 'package:flutter/material.dart';

class ProductDetailsScreen extends StatelessWidget {
  final String productId;

  const ProductDetailsScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('পণ্যের বিস্তারিত'),
      ),
      body: Center(
        child: Text('Product Details for ID: $productId - TODO'),
      ),
    );
  }
}
