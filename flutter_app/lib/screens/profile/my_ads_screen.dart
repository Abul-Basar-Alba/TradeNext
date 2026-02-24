import 'package:flutter/material.dart';

class MyAdsScreen extends StatelessWidget {
  const MyAdsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('আমার বিজ্ঞাপনসমূহ'),
      ),
      body: const Center(
        child: Text('My Ads - TODO'),
      ),
    );
  }
}
