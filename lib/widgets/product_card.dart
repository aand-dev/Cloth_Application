import 'package:flutter/material.dart';
import 'package:stock_application/models/product_model.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const ProductCard({super.key, required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final totalStock = product.variants.fold(
      0,
      (sum, variant) => sum + variant.stock,
    );

    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundImage:
                product.imageUrl != null && product.imageUrl!.isNotEmpty
                    ? NetworkImage(product.imageUrl!)
                    : const AssetImage('assets/images/placeholder.png')
                        as ImageProvider,
            onBackgroundImageError: (_, __) {
              // Manejo de error si la imagen no se carga.
            },
          ),
          title: Text(
            product.name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          subtitle: Text(
            'Categoría: ${product.category}\n'
            'Variantes: ${product.variants.length}\n'
            'Stock Total: $totalStock',
            style: TextStyle(
              color: totalStock == 0 ? Colors.red : Colors.black54,
            ),
          ),
          trailing: Icon(
            totalStock == 0 ? Icons.warning : Icons.check_circle,
            color: totalStock == 0 ? Colors.red : Colors.green,
          ),
        ),
      ),
    );
  }
}
