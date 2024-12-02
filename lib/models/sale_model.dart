import 'sale_product_model.dart';

class Sale {
  final int id;
  final String clientName;
  final String clientDni;
  final String clientEmail;
  final String paymentMethod;
  final double totalAmount;
  final DateTime saleDate;
  final List<SaleProduct> products;

  Sale({
    required this.id,
    required this.clientName,
    required this.clientDni,
    required this.clientEmail,
    required this.paymentMethod,
    required this.totalAmount,
    required this.saleDate,
    required this.products,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'clientName': clientName,
      'clientDni': clientDni,
      'clientEmail': clientEmail,
      'paymentMethod': paymentMethod,
      'totalAmount': totalAmount,
      'saleDate': saleDate.toIso8601String(),
      'products': products.map((p) => p.toJson()).toList(),
    };
  }
}
