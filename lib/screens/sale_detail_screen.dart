import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/sales_provider.dart';

class SaleDetailScreen extends StatelessWidget {
  final int saleId;

  const SaleDetailScreen({super.key, required this.saleId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalles de la Venta')),
      body: FutureBuilder(
        future: Provider.of<SalesProvider>(context, listen: false)
            .fetchSaleDetails(saleId, notify: false), // No notifiques aquí
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error al cargar los detalles: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          final salesProvider =
              Provider.of<SalesProvider>(context, listen: false);
          final saleDetails = salesProvider.selectedSaleDetail;

          if (saleDetails == null) {
            return const Center(
              child: Text('No se encontraron los detalles.'),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cliente: ${saleDetails.clientName}',
                  style: const TextStyle(fontSize: 18),
                ),
                Text(
                  'DNI: ${saleDetails.clientDni}',
                  style: const TextStyle(fontSize: 18),
                ),
                Text(
                  'Método de Pago: ${saleDetails.paymentMethod}',
                  style: const TextStyle(fontSize: 18),
                ),
                Text(
                  'Fecha: ${saleDetails.saleDate}',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Productos:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Divider(),
                Expanded(
                  child: ListView.builder(
                    itemCount: saleDetails.products.length,
                    itemBuilder: (context, index) {
                      final product = saleDetails.products[index];
                      return ListTile(
                        title: Text(product.productName),
                        subtitle: Text(
                          'Cantidad: ${product.quantity}, Precio: \$${product.unitPrice}',
                        ),
                        trailing: Text('Subtotal: \$${product.subtotal}'),
                      );
                    },
                  ),
                ),
                const Divider(),
                Text(
                  'Total: \$${saleDetails.totalAmount}',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
