import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../models/product_variant_model.dart';
import '../providers/inventory_provider.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
  final Product product;

  const EditProductScreen({super.key, required this.product});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  late List<ProductVariant> _variants;
  late List<int> _deletedVariantIds; // Lista para manejar variantes eliminadas
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.product.name;
    _descriptionController.text = widget.product.description;
    _priceController.text = widget.product.basePrice.toStringAsFixed(2);
    _variants = List.from(widget.product.variants);
    _deletedVariantIds = [];
  }

  Future<void> _saveChanges() async {
    if (!_validateFields()) return;

    setState(() {
      _isSaving = true;
    });

    final updatedProduct = widget.product.copyWith(
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      basePrice: double.tryParse(_priceController.text.trim()) ?? 0.0,
      variants: _variants,
    );

    final inventoryProvider =
        Provider.of<InventoryProvider>(context, listen: false);

    try {
      await inventoryProvider.updateProduct(updatedProduct);

      // Recargar los detalles del producto actualizado
      await inventoryProvider.loadProductDetails(updatedProduct.id);

      setState(() {
        _isSaving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Producto actualizado exitosamente')),
      );

      Navigator.pop(context); // Volver a ProductDetailsScreen
    } catch (e) {
      setState(() {
        _isSaving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar el producto: $e')),
      );
    }
  }

  bool _validateFields() {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El nombre del producto es obligatorio')),
      );
      return false;
    }

    for (var variant in _variants) {
      if (variant.size.isEmpty || variant.color.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Todas las variantes deben tener talla y color')),
        );
        return false;
      }
    }

    return true;
  }

  void _deleteVariant(int index) {
    setState(() {
      if (_variants[index].id != 0) {
        _deletedVariantIds.add(
            _variants[index].id); // Guardar el ID para borrar en el backend
      }
      _variants.removeAt(index); // Eliminar localmente
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Producto'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nombre',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Descripción',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Precio Base',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Variantes',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: _variants.length,
              itemBuilder: (context, index) {
                final variant = _variants[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        TextField(
                          decoration: const InputDecoration(
                            labelText: 'Talla',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _variants[index] = variant.copyWith(size: value);
                            });
                          },
                          controller: TextEditingController.fromValue(
                            TextEditingValue(
                              text: variant.size,
                              selection: TextSelection.collapsed(
                                offset: variant.size.length,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          decoration: const InputDecoration(
                            labelText: 'Color',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _variants[index] = variant.copyWith(color: value);
                            });
                          },
                          controller: TextEditingController.fromValue(
                            TextEditingValue(
                              text: variant.color,
                              selection: TextSelection.collapsed(
                                offset: variant.color.length,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          decoration: const InputDecoration(
                            labelText: 'Precio',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            setState(() {
                              _variants[index] = variant.copyWith(
                                price: double.tryParse(value) ?? 0.0,
                              );
                            });
                          },
                          controller: TextEditingController.fromValue(
                            TextEditingValue(
                              text: variant.price.toStringAsFixed(2),
                              selection: TextSelection.collapsed(
                                offset: variant.price.toStringAsFixed(2).length,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          decoration: const InputDecoration(
                            labelText: 'Stock',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            setState(() {
                              _variants[index] = variant.copyWith(
                                stock: int.tryParse(value) ?? 0,
                              );
                            });
                          },
                          controller: TextEditingController.fromValue(
                            TextEditingValue(
                              text: variant.stock.toString(),
                              selection: TextSelection.collapsed(
                                offset: variant.stock.toString().length,
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteVariant(index),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            _isSaving
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: _saveChanges,
                    child: const Text('Guardar Cambios'),
                  ),
          ],
        ),
      ),
    );
  }
}
