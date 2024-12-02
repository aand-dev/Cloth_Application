import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_application/config/routes.dart';
import '../providers/inventory_provider.dart';
import '../widgets/product_card.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  late Future<void> _loadProductsFuture;
  String _searchQuery = '';
  String _selectedCategory = '';
  String _selectedSize = '';
  String _selectedColor = '';

  @override
  void initState() {
    super.initState();
    _loadProductsFuture =
        Provider.of<InventoryProvider>(context, listen: false).loadProducts();
  }

  Future<void> _refreshProducts() async {
    try {
      await Provider.of<InventoryProvider>(context, listen: false)
          .loadProducts();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lista de productos actualizada.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar: $e')),
      );
    }
  }

  void _scanQRCode() {
    Navigator.pushNamed(
      context,
      AppRoutes.qrScanner,
      arguments: (productId) {
        if (productId.isNotEmpty && mounted) {
          Navigator.pop(context); // Cierra QRScannerScreen
          Navigator.pushNamed(
            context,
            AppRoutes.productDetails,
            arguments: int.tryParse(productId),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final inventoryProvider = Provider.of<InventoryProvider>(context);

    final filteredProducts = inventoryProvider.products.where((product) {
      final matchesSearchQuery = _searchQuery.isEmpty ||
          product.name.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory =
          _selectedCategory.isEmpty || product.category == _selectedCategory;
      final matchesSize = _selectedSize.isEmpty ||
          product.variants.any((variant) => variant.size == _selectedSize);
      final matchesColor = _selectedColor.isEmpty ||
          product.variants.any((variant) => variant.color == _selectedColor);

      return matchesSearchQuery &&
          matchesCategory &&
          matchesSize &&
          matchesColor;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Inventario'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Buscar productos...',
                      border: OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.qr_code_scanner),
                        onPressed: _scanQRCode,
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          // Dropdown Filters
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _selectedCategory.isEmpty ? null : _selectedCategory,
                    hint: const Text('Categoría'),
                    items: [
                      const DropdownMenuItem(
                        value: '',
                        child: Text('Todos'),
                      ),
                      ...['Categoría 1', 'Categoría 2', 'Categoría 3']
                          .map((category) => DropdownMenuItem(
                                value: category,
                                child: Text(category),
                              )),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value ?? '';
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _selectedSize.isEmpty ? null : _selectedSize,
                    hint: const Text('Tamaño'),
                    items: [
                      const DropdownMenuItem(
                        value: '',
                        child: Text('Todos'),
                      ),
                      ...['S', 'M', 'L', 'XL'].map((size) => DropdownMenuItem(
                            value: size,
                            child: Text(size),
                          )),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedSize = value ?? '';
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _selectedColor.isEmpty ? null : _selectedColor,
                    hint: const Text('Color'),
                    items: [
                      const DropdownMenuItem(
                        value: '',
                        child: Text('Todos'),
                      ),
                      ...['Rojo', 'Azul', 'Verde']
                          .map((color) => DropdownMenuItem(
                                value: color,
                                child: Text(color),
                              )),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedColor = value ?? '';
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          // Product List
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshProducts,
              child: FutureBuilder<void>(
                future: _loadProductsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else if (filteredProducts.isEmpty) {
                    return const Center(
                      child: Text('No se encontraron productos.'),
                    );
                  } else {
                    return ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: filteredProducts.length,
                      itemBuilder: (context, index) {
                        final product = filteredProducts[index];
                        return ProductCard(
                          product: product,
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.productDetails,
                              arguments: product.id,
                            );
                          },
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.addProduct);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
} // Para parsear JSON

