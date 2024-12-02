import 'package:stock_application/models/sale_product_detail_model.dart';

class SaleDetail {
  final int id;
  final String clientName;
  final String clientDni;
  final String clientEmail;
  final String paymentMethod;
  final double totalAmount;
  final DateTime saleDate;
  final List<SaleProductDetail> products;

  SaleDetail({
    required this.id,
    required this.clientName,
    required this.clientDni,
    required this.clientEmail,
    required this.paymentMethod,
    required this.totalAmount,
    required this.saleDate,
    required this.products,
  });

  factory SaleDetail.fromJson(Map<String, dynamic> json) {
    return SaleDetail(
      id: json['id'] ?? 0,
      clientName: json['clientName'] ?? 'Sin Nombre',
      clientDni: json['clientDNI'] ?? 'Desconocido',
      clientEmail: json['clientEmail'] ?? 'No Disponible',
      paymentMethod: json['paymentMethod'] ?? 'Desconocido',
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      saleDate: DateTime.tryParse(json['saleDate'] ?? '') ?? DateTime.now(),
      products: (json['products'] as List<dynamic>?)
              ?.map((product) => SaleProductDetail.fromJson(product))
              .toList() ??
          [],
    );
  }
}
