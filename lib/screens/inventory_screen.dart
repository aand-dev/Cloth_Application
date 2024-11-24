import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_application/providers/product_provider.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _InventoryScreenState createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  @override
  void initState() {
    super.initState();
    // Ejecuta loadProducts() después de que el widget esté completamente construido
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false).loadProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8F9),
      appBar: AppBar(
        title: const Text(
          'Gestión de Inventario',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Barra de búsqueda
            Container(
              color: const Color(0xFFEBEDED),
              height: 36,
              child: TextField(
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(),
                  hintText: 'Buscar productos...',
                  hintStyle: const TextStyle(fontSize: 14),
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: const Icon(Icons.mic),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Filtros
            const SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FilterButton(label: 'Categoría'),
                  SizedBox(width: 8),
                  FilterButton(label: 'Tamaño'),
                  SizedBox(width: 8),
                  FilterButton(label: 'Color'),
                  SizedBox(width: 8),
                  FilterButton(label: 'Marca'),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Lista de productos
            Expanded(
              child: provider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: provider.products.length,
                      itemBuilder: (context, index) {
                        final product = provider.products[index];
                        return ProductCard(product: product);
                      },
                    ),
            ),

            // Botón de Escanear Producto
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Actualizar Stock',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Acción de escanear producto
                      },
                      icon: const Icon(Icons.qr_code_scanner),
                      label: const Text('Escanear Producto'),
                      style: ElevatedButton.styleFrom(
                          textStyle: const TextStyle(color: Color(0xFF2D5EC6)),
                          backgroundColor: const Color(0xFFDEEAFF),
                          iconColor: const Color(0xFF2D5EC6),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          side: const BorderSide(color: Color(0xFF82A7EF))),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget para el botón de filtro
class FilterButton extends StatelessWidget {
  final String label;

  const FilterButton({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32,
      child: OutlinedButton(
        onPressed: () {
          // Acción del filtro
        },
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(label),
      ),
    );
  }
}

// Widget para la tarjeta del producto
class ProductCard extends StatelessWidget {
  final dynamic product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        leading: Image.network(product.image,
            width: 50, height: 50, fit: BoxFit.cover),
        title: Text(
          product.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
            'Categoría: ${product.category} \nStock: ${product.ratingCount}'),
        trailing: const Icon(Icons.qr_code_scanner),
      ),
    );
  }
}
