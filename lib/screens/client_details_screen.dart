import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/sale_detail_model.dart';
import '../providers/sales_provider.dart';

class ClientDetailsScreen extends StatelessWidget {
  final int clientId;

  const ClientDetailsScreen({super.key, required this.clientId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles del Cliente'),
        centerTitle: true,
      ),
      body: FutureBuilder<SaleDetail?>(
        future: Provider.of<SalesProvider>(context, listen: false)
            .fetchSaleDetails(clientId, notify: false),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || snapshot.data == null) {
            return Center(
              child: Text(
                'Error al cargar los detalles del cliente: ${snapshot.error ?? 'Cliente no encontrado.'}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          final client = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                const Text(
                  'Información del Cliente',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: client.clientName,
                  decoration: const InputDecoration(
                    labelText: 'Nombre Completo',
                    border: OutlineInputBorder(),
                  ),
                  readOnly: true,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: client.clientDni,
                  decoration: const InputDecoration(
                    labelText: 'DNI',
                    border: OutlineInputBorder(),
                  ),
                  readOnly: true,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: client.clientEmail ?? 'No disponible',
                  decoration: const InputDecoration(
                    labelText: 'Correo Electrónico',
                    border: OutlineInputBorder(),
                  ),
                  readOnly: true,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Historial de Compras',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ...client.products.map(
                  (product) => ListTile(
                    title: Text(product.productName),
                    subtitle: Text(
                      'Cantidad: ${product.quantity}, Total: \$${(product.unitPrice * product.quantity).toStringAsFixed(2)}',
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFDEEAFF)),
                  onPressed: () {
                    // Lógica para guardar cambios (si se necesita)
                  },
                  child: const Text('Guardar Cambios'),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    // Lógica para eliminar cliente (si es necesario)
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Eliminar Cliente'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
