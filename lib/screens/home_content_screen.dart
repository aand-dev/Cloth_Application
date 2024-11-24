import 'package:flutter/material.dart';
import 'package:stock_application/widgets/total_revenue.dart';

class HomeContentScreen extends StatelessWidget {
  const HomeContentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8F9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Clothen',
          style: TextStyle(
            color: Color(0xFF265DD4),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black54),
            onPressed: () {
              // Implementar acción de notificaciones
            },
          ),
          IconButton(
            icon: const Icon(Icons.person_outline, color: Colors.black54),
            onPressed: () {
              // Implementar acción de perfil de usuario
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 36,
              child: TextField(
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(),
                  hintText: 'Buscar productos, clientes, etc.',
                  hintStyle: const TextStyle(fontSize: 14),
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: const Color(0xFFEBEDED),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 16.0,
              runSpacing: 16.0,
              children: [
                _buildShortcutCard(
                  icon: Icons.inventory_2_outlined,
                  title: 'Abastecimiento',
                  subtitle: 'Agregar productos',
                  context: context,
                ),
                _buildShortcutCard(
                  icon: Icons.receipt_long_outlined,
                  title: 'Kardex',
                  subtitle: 'Recientes',
                  context: context,
                ),
                _buildShortcutCard(
                  icon: Icons.people_outline,
                  title: 'Empleados',
                  subtitle: 'Devoluciones...',
                  context: context,
                ),
                _buildShortcutCard(
                  icon: Icons.local_shipping_outlined,
                  title: 'Proveedores',
                  subtitle: 'Proveedores totales',
                  context: context,
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Text(
              'Dashboard',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            TotalRevenueWidget(),
          ],
        ),
      ),
    );
  }

  Widget _buildShortcutCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required BuildContext context,
  }) {
    return GestureDetector(
      onTap: () {
        // Implementar acción para cada card
      },
      child: Container(
        width: (MediaQuery.of(context).size.width - 48) / 2,
        height: 110.0,
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: const Color(0xFFECF2FE),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 32, color: const Color(0xFF265DD4)),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
