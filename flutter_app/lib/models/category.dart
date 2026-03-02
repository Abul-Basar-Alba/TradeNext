class Category {
  final String id;
  final String name;
  final String nameBn;
  final String? icon;
  final String? parentId;

  Category({
    required this.id,
    required this.name,
    required this.nameBn,
    this.icon,
    this.parentId,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as String,
      name: json['name'] as String,
      nameBn: json['name_bn'] as String,
      icon: json['icon'] as String?,
      parentId: json['parent_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'name_bn': nameBn,
      'icon': icon,
      'parent_id': parentId,
    };
  }
}

// Default categories (fallback if DB not available)
class AppCategories {
  static const List<Map<String, String>> categories = [
    {'id': 'mobiles', 'name': 'Mobiles', 'nameBn': 'মোবাইল', 'icon': '📱'},
    {'id': 'electronics', 'name': 'Electronics', 'nameBn': 'ইলেকট্রনিক্স', 'icon': '📺'},
    {'id': 'vehicles', 'name': 'Vehicles', 'nameBn': 'গাড়ি', 'icon': '🚗'},
    {'id': 'property', 'name': 'Property', 'nameBn': 'প্রপার্টি', 'icon': '🏠'},
    {'id': 'fashion', 'name': 'Fashion', 'nameBn': 'ফ্যাশন', 'icon': '👕'},
    {'id': 'furniture', 'name': 'Furniture', 'nameBn': 'ফার্নিচার', 'icon': '🪑'},
    {'id': 'services', 'name': 'Services', 'nameBn': 'সেবা', 'icon': '🔧'},
    {'id': 'others', 'name': 'Others', 'nameBn': 'অন্যান্য', 'icon': '📦'},
  ];

  static const Map<String, List<Map<String, String>>> subCategories = {
    'mobiles': [
      {'id': 'mobile_phones', 'name': 'Mobile Phones', 'nameBn': 'মোবাইল ফোন'},
      {'id': 'tablets', 'name': 'Tablets', 'nameBn': 'ট্যাবলেট'},
      {'id': 'accessories', 'name': 'Accessories', 'nameBn': 'এক্সেসরিজ'},
    ],
    'electronics': [
      {'id': 'tv', 'name': 'TV', 'nameBn': 'টিভি'},
      {'id': 'refrigerator', 'name': 'Refrigerator', 'nameBn': 'ফ্রিজ'},
      {'id': 'ac', 'name': 'AC', 'nameBn': 'এসি'},
      {'id': 'washing_machine', 'name': 'Washing Machine', 'nameBn': 'ওয়াশিং মেশিন'},
    ],
    'fashion': [
      {'id': 'mens_fashion', 'name': "Men's Fashion", 'nameBn': 'পুরুষদের পোশাক'},
      {'id': 'womens_fashion', 'name': "Women's Fashion", 'nameBn': 'মহিলাদের পোশাক'},
      {'id': 'kids_fashion', 'name': "Kids Fashion", 'nameBn': 'বাচ্চাদের পোশাক'},
    ],
    'services': [
      {'id': 'mobile_servicing', 'name': 'Mobile Servicing', 'nameBn': 'মোবাইল সার্ভিসিং'},
      {'id': 'electronics_repair', 'name': 'Electronics Repair', 'nameBn': 'ইলেকট্রনিক্স মেরামত'},
      {'id': 'home_services', 'name': 'Home Services', 'nameBn': 'হোম সার্ভিস'},
    ],
  };
}
