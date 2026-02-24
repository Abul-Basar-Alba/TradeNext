import 'package:flutter/material.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('প্রোফাইল সম্পাদনা'),
      ),
      body: const Center(
        child: Text('Edit Profile - TODO'),
      ),
    );
  }
}
