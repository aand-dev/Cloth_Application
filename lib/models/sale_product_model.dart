class SaleProduct {
  final int productId;
  final int variantId;
  final int quantity;
  final double unitPrice;
  final String productName;
  final String variantDescription;

  SaleProduct({
    required this.productId,
    required this.variantId,
    required this.quantity,
    required this.unitPrice,
    required this.productName,
    required this.variantDescription,
  });

  factory SaleProduct.fromJson(Map<String, dynamic> json) {
    return SaleProduct(
      productId: json['productId'] ?? 0,
      variantId: json['variantId'] ?? 0,
      quantity: json['quantity'] ?? 0,
      unitPrice: (json['unitPrice'] ?? 0).toDouble(),
      productName: json['productName'] ?? 'Producto Desconocido',
      variantDescription: json['variantDescription'] ?? 'No Disponible',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'variantId': variantId,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'productName': productName,
      'variantDescription': variantDescription,
    };
  }
}
