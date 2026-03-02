import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../config/theme.dart';
import '../../config/app_strings.dart';
import '../../providers/language_provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/supabase_service.dart';
import '../../models/category.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';

class CreateProductScreen extends ConsumerStatefulWidget {
  const CreateProductScreen({super.key});

  @override
  ConsumerState<CreateProductScreen> createState() => _CreateProductScreenState();
}

class _CreateProductScreenState extends ConsumerState<CreateProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _locationController = TextEditingController();
  final _phoneController = TextEditingController();
  
  String _adType = 'sell'; // 'sell' or 'rent'
  String? _selectedCategory;
  String? _selectedSubCategory;
  String _condition = 'used'; // 'new', 'used', 'like_new'
  bool _isNegotiable = true;
  bool _isLoading = false;
  
  List<File> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _locationController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    try {
      final List<XFile> images = await _picker.pickMultiImage(
        imageQuality: 70,
        maxWidth: 1200,
      );
      
      if (images.isNotEmpty && images.length <= 5) {
        setState(() {
          _selectedImages = images.map((img) => File(img.path)).toList();
        });
      } else if (images.length > 5) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('সর্বোচ্চ ৫টি ছবি নির্বাচন করতে পারবেন')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('ছবি নির্বাচন করতে সমস্যা: ${e.toString()}')),
        );
      }
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  Future<void> _submitAd() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (_selectedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('অন্তত একটি ছবি যুক্ত করুন')),
      );
      return;
    }

    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ক্যাটাগরি নির্বাচন করুন')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = ref.read(authStateProvider).value;
      if (user == null) {
        throw Exception('লগইন করুন');
      }

      final supabase = ref.read(supabaseServiceProvider);
      
      // Upload images first
      final List<String> imageUrls = [];
      for (int i = 0; i < _selectedImages.length; i++) {
        final url = await supabase.uploadProductImage(
          _selectedImages[i],
          user.uid,
        );
        imageUrls.add(url);
      }

      // Create product with correct column names
      final productData = {
        'owner_id': user.uid,
        'owner_phone': _phoneController.text.trim(),
        'title': _titleController.text.trim(),
        'description': _descriptionController.text.trim(),
        'price': double.parse(_priceController.text),
        'type': _adType, // 'sell' or 'rent'
        'category': _selectedSubCategory ?? _selectedCategory,
        'condition': _condition,
        'location': _locationController.text.trim(),
        'images': imageUrls,
      };

      await supabase.createProduct(productData);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('বিজ্ঞাপন সফলভাবে যুক্ত হয়েছে!')),
        );
        context.go('/');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('সমস্যা হয়েছে: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(languageProvider);
    String tr(String key) => AppStrings.translate(key, language);

    return Scaffold(
      appBar: AppBar(
        title: Text(language == 'bn' ? 'বিজ্ঞাপন পোস্ট করুন' : 'Post Ad'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Ad Type Selection
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      language == 'bn' ? 'বিজ্ঞাপনের ধরন' : 'Ad Type',
                      style: AppTheme.headingMedium,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile<String>(
                            value: 'sell',
                            groupValue: _adType,
                            onChanged: (value) {
                              setState(() => _adType = value!);
                            },
                            title: Text(language == 'bn' ? 'বিক্রয়' : 'Sell'),
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<String>(
                            value: 'rent',
                            groupValue: _adType,
                            onChanged: (value) {
                              setState(() => _adType = value!);
                            },
                            title: Text(language == 'bn' ? 'ভাড়া' : 'Rent'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Category Selection
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      language == 'bn' ? 'ক্যাটাগরি নির্বাচন করুন' : 'Select Category',
                      style: AppTheme.headingMedium,
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      hint: Text(language == 'bn' ? 'ক্যাটাগরি' : 'Category'),
                      items: AppCategories.categories.map((cat) {
                        return DropdownMenuItem(
                          value: cat['id'],
                          child: Row(
                            children: [
                              Text(cat['icon']!, style: const TextStyle(fontSize: 20)),
                              const SizedBox(width: 8),
                              Text(language == 'bn' ? cat['nameBn']! : cat['name']!),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value;
                          _selectedSubCategory = null;
                        });
                      },
                      validator: (value) => value == null ? 'ক্যাটাগরি নির্বাচন করুন' : null,
                    ),
                    if (_selectedCategory != null && AppCategories.subCategories.containsKey(_selectedCategory)) ...[
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: _selectedSubCategory,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        hint: Text(language == 'bn' ? 'সাব-ক্যাটাগরি' : 'Sub-Category'),
                        items: AppCategories.subCategories[_selectedCategory]!.map((subCat) {
                          return DropdownMenuItem(
                            value: subCat['id'],
                            child: Text(language == 'bn' ? subCat['nameBn']! : subCat['name']!),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() => _selectedSubCategory = value);
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Product Images
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      language == 'bn' ? 'পণ্যের ছবি (সর্বোচ্চ ৫টি)' : 'Product Images (Max 5)',
                      style: AppTheme.headingMedium,
                    ),
                    const SizedBox(height: 12),
                    if (_selectedImages.isEmpty)
                      GestureDetector(
                        onTap: _pickImages,
                        child: Container(
                          height: 150,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.add_photo_alternate, size: 48, color: Colors.grey),
                                const SizedBox(height: 8),
                                Text(
                                  language == 'bn' ? 'ছবি যুক্ত করুন' : 'Add Images',
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    else
                      Column(
                        children: [
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                            ),
                            itemCount: _selectedImages.length + 1,
                            itemBuilder: (context, index) {
                              if (index == _selectedImages.length) {
                                return GestureDetector(
                                  onTap: _pickImages,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Center(
                                      child: Icon(Icons.add, size: 32, color: Colors.grey),
                                    ),
                                  ),
                                );
                              }
                              return Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.file(
                                      _selectedImages[index],
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: double.infinity,
                                    ),
                                  ),
                                  Positioned(
                                    top: 4,
                                    right: 4,
                                    child: GestureDetector(
                                      onTap: () => _removeImage(index),
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: const BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(Icons.close, color: Colors.white, size: 16),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Product Details
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      language == 'bn' ? 'পণ্যের তথ্য' : 'Product Details',
                      style: AppTheme.headingMedium,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: language == 'bn' ? 'শিরোনাম' : 'Title',
                      hint: language == 'bn' ? 'পণ্যের নাম লিখুন' : 'Enter product name',
                      controller: _titleController,
                      validator: (value) => value == null || value.isEmpty ? 'শিরোনাম দিন' : null,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: language == 'bn' ? 'বিস্তারিত' : 'Description',
                      hint: language == 'bn' ? 'পণ্যের বিস্তারিত লিখুন' : 'Enter description',
                      controller: _descriptionController,
                      maxLines: 5,
                      validator: (value) => value == null || value.isEmpty ? 'বিস্তারিত দিন' : null,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: language == 'bn' ? 'মূল্য (টাকা)' : 'Price (BDT)',
                      hint: '0',
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'মূল্য দিন';
                        if (double.tryParse(value) == null) return 'সঠিক মূল্য দিন';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _condition,
                      decoration: InputDecoration(
                        labelText: language == 'bn' ? 'অবস্থা' : 'Condition',
                        border: const OutlineInputBorder(),
                      ),
                      items: [
                        DropdownMenuItem(
                          value: 'new',
                          child: Text(language == 'bn' ? 'নতুন' : 'New'),
                        ),
                        DropdownMenuItem(
                          value: 'like_new',
                          child: Text(language == 'bn' ? 'নতুনের মতো' : 'Like New'),
                        ),
                        DropdownMenuItem(
                          value: 'used',
                          child: Text(language == 'bn' ? 'ব্যবহৃত' : 'Used'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() => _condition = value!);
                      },
                    ),
                    const SizedBox(height: 16),
                    SwitchListTile(
                      value: _isNegotiable,
                      onChanged: (value) {
                        setState(() => _isNegotiable = value);
                      },
                      title: Text(language == 'bn' ? 'দর কষাকষিযোগ্য' : 'Negotiable'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Contact Information
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      language == 'bn' ? 'যোগাযোগের তথ্য' : 'Contact Information',
                      style: AppTheme.headingMedium,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: language == 'bn' ? 'ফোন নম্বর' : 'Phone Number',
                      hint: '01XXXXXXXXX',
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      validator: (value) => value == null || value.isEmpty ? 'ফোন নম্বর দিন' : null,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: language == 'bn' ? 'স্থান' : 'Location',
                      hint: language == 'bn' ? 'এলাকা, শহর' : 'Area, City',
                      controller: _locationController,
                      validator: (value) => value == null || value.isEmpty ? 'স্থান দিন' : null,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Submit Button
            CustomButton(
              text: language == 'bn' ? 'বিজ্ঞাপন পোস্ট করুন' : 'Post Ad',
              onPressed: _submitAd,
              isLoading: _isLoading,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
