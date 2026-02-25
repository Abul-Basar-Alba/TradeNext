import 'package:json_annotation/json_annotation.dart';
import 'user.dart';

part 'product.g.dart';

@JsonSerializable()
class Product {
  @JsonKey(name: '_id')
  final String id;
  final String title;
  final String description;
  final String category;
  final String type; // 'rent' or 'sell'
  final double price;
  final double? rentalPrice;
  final String? rentalPeriod; // 'daily' or 'monthly'
  final String condition;
  final ProductLocation location;
  final List<String> images;
  final bool isForSale;
  final bool isForRent;
  final String owner; // Deprecated - use ownerId
  final String? ownerId; // Firebase Auth UID
  final String? ownerName; // Owner display name
  final String? ownerPhone; // Owner phone number
  final User? ownerDetails; // Populated owner data
  final String status; // 'available', 'rented', 'sold', 'unavailable', 'active'
  final int views;
  final bool featured;
  final bool? isFeatured; // Alias for featured
  final DateTime createdAt;
  final DateTime updatedAt;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.type,
    required this.price,
    this.rentalPrice,
    this.rentalPeriod,
    required this.condition,
    required this.location,
    this.images = const [],
    this.isForSale = false,
    this.isForRent = false,
    required this.owner,
    this.ownerId,
    this.ownerName,
    this.ownerPhone,
    this.ownerDetails,
    this.status = 'available',
    this.views = 0,
    this.featured = false,
    this.isFeatured,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) => 
      _$ProductFromJson(json);
  Map<String, dynamic> toJson() => _$ProductToJson(this);

  Product copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    String? type,
    double? price,
    double? rentalPrice,
    String? rentalPeriod,
    String? condition,
    ProductLocation? location,
    List<String>? images,
    bool? isForSale,
    bool? isForRent,
    String? owner,
    User? ownerDetails,
    String? status,
    int? views,
    bool? featured,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      type: type ?? this.type,
      price: price ?? this.price,
      rentalPrice: rentalPrice ?? this.rentalPrice,
      rentalPeriod: rentalPeriod ?? this.rentalPeriod,
      condition: condition ?? this.condition,
      location: location ?? this.location,
      images: images ?? this.images,
      isForSale: isForSale ?? this.isForSale,
      isForRent: isForRent ?? this.isForRent,
      owner: owner ?? this.owner,
      ownerDetails: ownerDetails ?? this.ownerDetails,
      status: status ?? this.status,
      views: views ?? this.views,
      featured: featured ?? this.featured,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Get display price with Bengali formatting
  String getDisplayPrice() {
    if (price >= 100000) {
      return '৳${(price / 100000).toStringAsFixed(1)} লক্ষ';
    } else if (price >= 1000) {
      return '৳${(price / 1000).toStringAsFixed(0)}k';
    } else {
      return '৳$price';
    }
  }

  // Check if product is available
  bool get isAvailable => status == 'available';
}

@JsonSerializable()
class ProductLocation {
  final String city;
  final String? area;

  ProductLocation({
    required this.city,
    this.area,
  });

  factory ProductLocation.fromJson(Map<String, dynamic> json) => 
      _$ProductLocationFromJson(json);
  Map<String, dynamic> toJson() => _$ProductLocationToJson(this);

  String getFullLocation() {
    return area != null ? '$area, $city' : city;
  }
}

// For creating/updating products
@JsonSerializable()
class ProductInput {
  final String title;
  final String description;
  final String category;
  final String type;
  final double price;
  final double? rentalPrice;
  final String? rentalPeriod;
  final String condition;
  final String city;
  final String? area;
  final List<String>? images;

  ProductInput({
    required this.title,
    required this.description,
    required this.category,
    required this.type,
    required this.price,
    this.rentalPrice,
    this.rentalPeriod,
    required this.condition,
    required this.city,
    this.area,
    this.images,
  });

  Map<String, dynamic> toJson() => _$ProductInputToJson(this);
}
