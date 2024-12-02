class SaleProductDetail {
  final int productId;
  final String productName;
  final String variantDescription;
  final int quantity;
  final double unitPrice;
  final double subtotal;

  SaleProductDetail({
    required this.productId,
    required this.productName,
    required this.variantDescription,
    required this.quantity,
    required this.unitPrice,
    required this.subtotal,
  });

  factory SaleProductDetail.fromJson(Map<String, dynamic> json) {
    return SaleProductDetail(
      productId: json['productId'],
      productName: json['productName'],
      variantDescription: json['variantDescription'],
      quantity: json['quantity'],
      unitPrice: json['unitPrice'],
      subtotal: json['subtotal'],
    );
  }
}
