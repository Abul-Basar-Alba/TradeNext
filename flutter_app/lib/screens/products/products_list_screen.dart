import 'package:flutter/material.dart';

class ProductsListScreen extends StatelessWidget {
  final String? type;
  final String? category;

  const ProductsListScreen({
    super.key,
    this.type,
    this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(type == 'rent' ? 'ভাড়ার পণ্য' : 'বিক্রয়ের পণ্য'),
      ),
      body: const Center(
        child: Text('Products List - TODO'),
      ),
    );
  }
}
