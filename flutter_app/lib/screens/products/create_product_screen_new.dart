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
  String _condition = 'used';
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
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('অন্তত একটি ছবি নির্বাচন করুন')),
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
          const SnackBar(
            content: Text('বিজ্ঞাপন সফলভাবে যুক্ত হয়েছে!'),
            backgroundColor: Color(0xFF23E5DB),
          ),
        );
        context.go('/');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('সমস্যা হয়েছে: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
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

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFF23E5DB),
        elevation: 0,
        title: Text(
          language == 'bn' ? 'বিজ্ঞাপন পোস্ট করুন' : 'Post Ad',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImageSection(language),
                const SizedBox(height: 16),
                _buildAdTypeSection(language),
                const SizedBox(height: 16),
                _buildCategorySection(language),
                const SizedBox(height: 16),
                _buildProductDetailsSection(language),
                const SizedBox(height: 16),
                _buildContactSection(language),
                const SizedBox(height: 24),
                _buildSubmitButton(language),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection(String language) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF23E5DB).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.photo_camera,
                  color: Color(0xFF23E5DB),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                language == 'bn' ? 'ছবি যুক্ত করুন' : 'Add Photos',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2C3E50),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            language == 'bn' ? 'সর্বোচ্চ ৫টি ছবি' : 'Maximum 5 photos',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          if (_selectedImages.isEmpty)
            GestureDetector(
              onTap: _pickImages,
              child: Container(
                height: 180,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xFF23E5DB).withOpacity(0.3),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  color: const Color(0xFF23E5DB).withOpacity(0.05),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF23E5DB).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.add_photo_alternate,
                        size: 48,
                        color: Color(0xFF23E5DB),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      language == 'bn' ? 'ছবি নির্বাচন করুন' : 'Select Photos',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF23E5DB),
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _selectedImages.length + 1,
                itemBuilder: (context, index) {
                  if (index == _selectedImages.length) {
                    return GestureDetector(
                      onTap: _pickImages,
                      child: Container(
                        width: 120,
                        margin: const EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xFF23E5DB).withOpacity(0.3),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          color: const Color(0xFF23E5DB).withOpacity(0.05),
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add,
                              size: 32,
                              color: Color(0xFF23E5DB),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Add More',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF23E5DB),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return Stack(
                    children: [
                      Container(
                        width: 120,
                        margin: const EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                            image: FileImage(_selectedImages[index]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 4,
                        right: 16,
                        child: GestureDetector(
                          onTap: () => _removeImage(index),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAdTypeSection(String language) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            language == 'bn' ? 'বিজ্ঞাপনের ধরন' : 'Ad Type',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2C3E50),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildAdTypeOption(
                  value: 'sell',
                  label: language == 'bn' ? 'বিক্রয়' : 'Sell',
                  icon: Icons.sell_outlined,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildAdTypeOption(
                  value: 'rent',
                  label: language == 'bn' ? 'ভাড়া' : 'Rent',
                  icon: Icons.key_outlined,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAdTypeOption({
    required String value,
    required String label,
    required IconData icon,
  }) {
    final isSelected = _adType == value;
    return GestureDetector(
      onTap: () => setState(() => _adType = value),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF23E5DB).withOpacity(0.1)
              : Colors.grey[100],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? const Color(0xFF23E5DB) : Colors.grey[300]!,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? const Color(0xFF23E5DB) : Colors.grey[600],
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: isSelected ? const Color(0xFF23E5DB) : Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySection(String language) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            language == 'bn' ? 'ক্যাটাগরি নির্বাচন করুন' : 'Select Category',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2C3E50),
            ),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _selectedCategory,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFF23E5DB), width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              filled: true,
              fillColor: Colors.grey[50],
            ),
            hint: Text(
              language == 'bn' ? 'ক্যাটাগরি নির্বাচন করুন' : 'Select Category',
              style: TextStyle(color: Colors.grey[600]),
            ),
            items: AppCategories.categories.map((cat) {
              return DropdownMenuItem(
                value: cat['id'],
                child: Row(
                  children: [
                    Text(cat['icon']!, style: const TextStyle(fontSize: 22)),
                    const SizedBox(width: 12),
                    Text(
                      language == 'bn' ? cat['nameBn']! : cat['name']!,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
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
          ),
          if (_selectedCategory != null &&
              AppCategories.subCategories.containsKey(_selectedCategory)) ...[
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedSubCategory,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFF23E5DB), width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                filled: true,
                fillColor: Colors.grey[50],
              ),
              hint: Text(
                language == 'bn' ? 'উপ-ক্যাটাগরি নির্বাচন করুন' : 'Select Sub-Category',
                style: TextStyle(color: Colors.grey[600]),
              ),
              items: (AppCategories.subCategories[_selectedCategory] ?? [])
                  .map((subCat) {
                return DropdownMenuItem(
                  value: subCat['id'],
                  child: Text(
                    language == 'bn' ? subCat['nameBn']! : subCat['name']!,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => _selectedSubCategory = value);
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildProductDetailsSection(String language) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            language == 'bn' ? 'পণ্যের বিস্তারিত' : 'Product Details',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2C3E50),
            ),
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: language == 'bn' ? 'শিরোনাম' : 'Title',
            hint: language == 'bn' ? 'পণ্যের শিরোনাম লিখুন' : 'Enter product title',
            controller: _titleController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return language == 'bn' ? 'শিরোনাম দিন' : 'Enter title';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: language == 'bn' ? 'বিবরণ' : 'Description',
            hint: language == 'bn' ? 'পণ্যের বিস্তারিত লিখুন' : 'Enter product description',
            controller: _descriptionController,
            maxLines: 4,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: language == 'bn' ? 'মূল্য (৳)' : 'Price (৳)',
            hint: language == 'bn' ? 'মূল্য লিখুন' : 'Enter price',
            controller: _priceController,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return language == 'bn' ? 'মূল্য দিন' : 'Enter price';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _condition,
            decoration: InputDecoration(
              labelText: language == 'bn' ? 'অবস্থা' : 'Condition',
              labelStyle: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Color(0xFF2C3E50),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFF23E5DB), width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              filled: true,
              fillColor: Colors.grey[50],
            ),
            items: [
              DropdownMenuItem(
                value: 'new',
                child: Text(
                  language == 'bn' ? 'নতুন' : 'New',
                  style: const TextStyle(fontSize: 15),
                ),
              ),
              DropdownMenuItem(
                value: 'like_new',
                child: Text(
                  language == 'bn' ? 'নতুনের মতো' : 'Like New',
                  style: const TextStyle(fontSize: 15),
                ),
              ),
              DropdownMenuItem(
                value: 'used',
                child: Text(
                  language == 'bn' ? 'ব্যবহৃত' : 'Used',
                  style: const TextStyle(fontSize: 15),
                ),
              ),
            ],
            onChanged: (value) {
              setState(() => _condition = value!);
            },
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF23E5DB).withOpacity(0.05),
              borderRadius: BorderRadius.circular(10),
            ),
            child: SwitchListTile(
              value: _isNegotiable,
              onChanged: (value) {
                setState(() => _isNegotiable = value);
              },
              title: Text(
                language == 'bn' ? 'দর কষাকষিযোগ্য' : 'Negotiable',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF2C3E50),
                ),
              ),
              activeColor: const Color(0xFF23E5DB),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection(String language) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            language == 'bn' ? 'যোগাযোগের তথ্য' : 'Contact Information',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2C3E50),
            ),
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: language == 'bn' ? 'ফোন নম্বর' : 'Phone Number',
            hint: '01XXXXXXXXX',
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return language == 'bn' ? 'ফোন নম্বর দিন' : 'Enter phone number';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: language == 'bn' ? 'স্থান' : 'Location',
            hint: language == 'bn' ? 'এলাকা, শহর' : 'Area, City',
            controller: _locationController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return language == 'bn' ? 'স্থান দিন' : 'Enter location';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: const TextStyle(fontSize: 15),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: Color(0xFF2C3E50),
        ),
        hintStyle: TextStyle(
          fontSize: 14,
          color: Colors.grey[400],
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF23E5DB), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      validator: validator,
    );
  }

  Widget _buildSubmitButton(String language) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _submitAd,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF23E5DB),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
          shadowColor: const Color(0xFF23E5DB).withOpacity(0.3),
        ),
        child: _isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check_circle_outline, size: 22),
                  const SizedBox(width: 8),
                  Text(
                    language == 'bn' ? 'বিজ্ঞাপন পোস্ট করুন' : 'Post Ad',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
