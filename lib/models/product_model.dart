import 'product_variant_model.dart';

class Product {
  final int id;
  final String name;
  final String description;
  final String category;
  final double basePrice;
  final String? imageUrl;
  final String? qrCodeUrl;
  final List<ProductVariant> variants;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.basePrice,
    this.imageUrl,
    this.qrCodeUrl,
    required this.variants,
  });

  // Método copyWith para crear una copia del producto con modificaciones
  Product copyWith({
    int? id,
    String? name,
    String? description,
    String? category,
    double? basePrice,
    String? imageUrl,
    String? qrCodeUrl,
    List<ProductVariant>? variants,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      basePrice: basePrice ?? this.basePrice,
      imageUrl: imageUrl ?? this.imageUrl,
      qrCodeUrl: qrCodeUrl ?? this.qrCodeUrl,
      variants: variants ?? this.variants,
    );
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      basePrice: json['basePrice'] is int
          ? (json['basePrice'] as int).toDouble()
          : json['basePrice']?.toDouble() ?? 0.0,
      imageUrl: json['imageUrl'],
      qrCodeUrl: json['qrCodeUrl'],
      variants: (json['variants'] as List<dynamic>?)
              ?.map((variant) => ProductVariant.fromJson(variant))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'basePrice': basePrice,
      'imageUrl': imageUrl,
      'qrCodeUrl': qrCodeUrl,
    };
  }

  Map<String, dynamic> toJsonWithVariants() {
    return {
      ...toJson(),
      'variants': variants.map((variant) => variant.toJson()).toList(),
    };
  }

  String getFullQrCodeUrl(String baseUrl) {
    return qrCodeUrl != null ? "$baseUrl$qrCodeUrl" : "";
  }
}
