import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_application/models/product_variant_model.dart';
import '../models/product_model.dart';
import '../models/sale_product_model.dart';
import '../providers/inventory_provider.dart';

class SelectProductScreen extends StatefulWidget {
  final Map<String, dynamic>? arguments;

  const SelectProductScreen({super.key, this.arguments});

  @override
  State<SelectProductScreen> createState() => _SelectProductScreenState();
}

class _SelectProductScreenState extends State<SelectProductScreen> {
  List<Product> _products = [];
  List<ProductVariant> _selectedVariants = [];
  final Map<int, int> _selectedQuantities = {};

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    try {
      final inventoryProvider =
          Provider.of<InventoryProvider>(context, listen: false);
      await inventoryProvider.loadProducts();
      setState(() {
        _products = inventoryProvider.products;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar productos: $e')),
      );
    }
  }

  void _selectVariant(ProductVariant variant) {
    setState(() {
      if (!_selectedVariants.contains(variant)) {
        _selectedVariants.add(variant);
        _selectedQuantities[variant.id] = 1; // Cantidad inicial por defecto
      }
    });
  }

  void _removeVariant(ProductVariant variant) {
    setState(() {
      _selectedVariants.remove(variant);
      _selectedQuantities.remove(variant.id);
    });
  }

  void _confirmSelection() {
    final List<SaleProduct> selectedProducts = _selectedVariants.map((variant) {
      final quantity = _selectedQuantities[variant.id] ?? 1;

      // Obtén el producto principal de esta variante
      final product = _products.firstWhere(
        (p) => p.variants.contains(variant),
        orElse: () =>
            throw Exception('Producto no encontrado para la variante'),
      );

      return SaleProduct(
        productId: product.id, // Usa el id del producto
        variantId: variant.id,
        productName: product.name,
        variantDescription: '${variant.size} - ${variant.color}',
        unitPrice: variant.price,
        quantity: quantity,
      );
    }).toList();

    Navigator.pop(context, selectedProducts);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seleccionar Productos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _confirmSelection,
          ),
        ],
      ),
      body: _products.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _products.length,
              itemBuilder: (context, index) {
                final product = _products[index];
                return ExpansionTile(
                  title: Text(product.name), // Usa el nombre del producto
                  subtitle: Text(product.description),
                  children: product.variants.map((variant) {
                    final isSelected = _selectedVariants.contains(variant);
                    return ListTile(
                      title: Text('${variant.size} - ${variant.color}'),
                      subtitle: Text('Precio: \$${variant.price}'),
                      trailing: isSelected
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove_circle),
                                  onPressed: () {
                                    _removeVariant(variant);
                                  },
                                ),
                                Text('${_selectedQuantities[variant.id]}'),
                                IconButton(
                                  icon: const Icon(Icons.add_circle),
                                  onPressed: () {
                                    setState(() {
                                      _selectedQuantities[variant.id] =
                                          (_selectedQuantities[variant.id] ??
                                                  1) +
                                              1;
                                    });
                                  },
                                ),
                              ],
                            )
                          : IconButton(
                              icon: const Icon(Icons.add_circle_outline),
                              onPressed: () {
                                _selectVariant(variant);
                              },
                            ),
                    );
                  }).toList(),
                );
              },
            ),
    );
  }
}
