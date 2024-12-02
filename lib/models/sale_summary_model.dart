class SaleSummary {
  final int id;
  final String clientName;
  final String clientDni;
  final String paymentMethod;
  final double totalAmount;
  final DateTime saleDate;

  SaleSummary({
    required this.id,
    required this.clientName,
    required this.clientDni,
    required this.paymentMethod,
    required this.totalAmount,
    required this.saleDate,
  });

  factory SaleSummary.fromJson(Map<String, dynamic> json) {
    return SaleSummary(
      id: json['id'] ?? 0,
      clientName: json['clientName'] ?? 'Sin Nombre',
      clientDni: json['clientDni'] ?? 'Desconocido',
      paymentMethod: json['paymentMethod'] ?? 'Desconocido',
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      saleDate:
          DateTime.parse(json['saleDate'] ?? DateTime.now().toIso8601String()),
    );
  }
}
