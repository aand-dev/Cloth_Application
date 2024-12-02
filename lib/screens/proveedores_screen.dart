import 'package:flutter/material.dart';

class ProveedoresScreen extends StatelessWidget {
  const ProveedoresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Proveedores'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Buscar proveedores',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onChanged: (value) {
                // Implementar lógica de búsqueda
              },
            ),
            const SizedBox(height: 16),
            const Text(
              'Lista de Proveedores',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.separated(
                itemCount: 4, // Número de proveedores (cambiar dinámicamente)
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const CircleAvatar(
                      backgroundImage: NetworkImage(
                        'https://via.placeholder.com/150', // Imagen del proveedor
                      ),
                    ),
                    title: Text('Proveedor ${index + 1}'),
                    subtitle: const Text(
                      'Proveedor de productos variados',
                    ),
                    trailing: const Text('10:30 AM'),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/proveedor-details',
                        arguments: index, // Pasar ID del proveedor
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                // Lógica para añadir proveedor
              },
              icon: const Icon(Icons.add),
              label: const Text('Añadir proveedor'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFDEEAFF),
                padding: const EdgeInsets.symmetric(vertical: 12),
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
