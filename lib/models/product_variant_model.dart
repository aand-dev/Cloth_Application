class ProductVariant {
  final int id;
  final String size;
  final String color;
  final double price;
  final int stock;
  final String? imageUrl;

  ProductVariant({
    required this.id,
    required this.size,
    required this.color,
    required this.price,
    required this.stock,
    this.imageUrl,
  });

  ProductVariant copyWith({
    int? id,
    String? size,
    String? color,
    double? price,
    int? stock,
    String? imageUrl,
  }) {
    return ProductVariant(
      id: id ?? this.id,
      size: size ?? this.size,
      color: color ?? this.color,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  // Factory para crear una variante desde JSON
  factory ProductVariant.fromJson(Map<String, dynamic> json) {
    return ProductVariant(
      id: json['id'],
      size: json['size'] ?? '',
      color: json['color'] ?? '',
      price: json['price'] is int
          ? (json['price'] as int).toDouble()
          : json['price']?.toDouble() ?? 0.0,
      stock: json['stock'] ?? 0,
      imageUrl: json['imageUrl'],
    );
  }

  // Método para convertir la variante a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'size': size,
      'color': color,
      'price': price,
      'stock': stock,
      'imageUrl': imageUrl,
    };
  }
}
