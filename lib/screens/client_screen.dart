import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/sales_provider.dart';

class ClientScreen extends StatelessWidget {
  const ClientScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clientes'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Buscar clientes...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onChanged: (value) {
                Provider.of<SalesProvider>(context, listen: false)
                    .filterClientsByName(value);
              },
            ),
            const SizedBox(height: 16),
            const Text(
              'Lista de Clientes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Consumer<SalesProvider>(
                builder: (context, provider, child) {
                  final clients = provider.filteredClients;

                  if (provider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (clients.isEmpty) {
                    return const Center(
                      child: Text('No hay clientes disponibles.'),
                    );
                  }

                  return ListView.separated(
                    itemCount: clients.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (context, index) {
                      final client = clients[index];
                      return ListTile(
                        leading: CircleAvatar(
                          child: Text(client.clientName[0].toUpperCase()),
                        ),
                        title: Text(client.clientName),
                        subtitle: Text(
                          'Última compra: ${client.saleDate.toLocal().toString().split(' ')[0]}',
                        ),
                        trailing: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              side: BorderSide(color: Color(0xFF82A7EF)),
                              backgroundColor: Color(0xFFDEEAFF),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8))),
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              '/client-details',
                              arguments: client.id,
                            );
                          },
                          child: const Text('Historial de Compras'),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
