import 'package:stock_application/models/sale_product_model.dart';

class SaleCreate {
  final String clientName;
  final String clientDni;
  final String clientEmail;
  final String paymentMethod;
  final double totalAmount;
  final List<SaleProduct> products;

  SaleCreate({
    required this.clientName,
    required this.clientDni,
    required this.clientEmail,
    required this.paymentMethod,
    required this.totalAmount,
    required this.products,
  });

  Map<String, dynamic> toJson() {
    return {
      'clientName': clientName,
      'clientDni': clientDni,
      'clientEmail': clientEmail,
      'paymentMethod': paymentMethod,
      'totalAmount': totalAmount,
      'products': products.map((product) => product.toJson()).toList(),
    };
  }
}
