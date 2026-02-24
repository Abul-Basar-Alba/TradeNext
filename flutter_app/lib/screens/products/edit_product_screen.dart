import 'package:flutter/material.dart';

class EditProductScreen extends StatelessWidget {
  final String productId;

  const EditProductScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('বিজ্ঞাপন সম্পাদনা'),
      ),
      body: Center(
        child: Text('Edit Product $productId - TODO'),
      ),
    );
  }
}
