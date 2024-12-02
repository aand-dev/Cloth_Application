import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/sales_provider.dart';
import '../config/routes.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({super.key});

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final salesProvider = Provider.of<SalesProvider>(context, listen: false);
      salesProvider.fetchSales();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text('Gestión de Ventas'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.salesForm);
              },
              icon: const Icon(Icons.add),
              label: const Text('Generar Nueva Venta'),
              style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 48),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  backgroundColor: Color(0xFFDEEAFF)),
            ),
          ),
          Expanded(
            child: Consumer<SalesProvider>(
              builder: (context, salesProvider, child) {
                if (salesProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (salesProvider.sales.isEmpty) {
                  return const Center(
                    child: Text('No hay ventas registradas.'),
                  );
                }

                return ListView.separated(
                  itemCount: salesProvider.sales.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final sale = salesProvider.sales[index];
                    return ListTile(
                      title: Text('Venta ID: ${sale.id}'),
                      subtitle: Text(
                        'Cliente: ${sale.clientName} - Total: \$${sale.totalAmount.toStringAsFixed(2)}',
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.saleDetails,
                          arguments: sale.id,
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
