import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product_model.dart';
import '../models/product_variant_model.dart';
import '../providers/inventory_provider.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();

  final _firstVariantSizeController = TextEditingController();
  final _firstVariantColorController = TextEditingController();
  final _firstVariantPriceController = TextEditingController();
  final _firstVariantStockController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _firstVariantSizeController.text = _firstVariant.size;
    _firstVariantColorController.text = _firstVariant.color;
    _priceController.text =
        _firstVariant.price.toString(); // Sincronizar precios
    _firstVariantPriceController.text = _priceController.text;
    _firstVariantStockController.text = _firstVariant.stock.toString();
  }

  bool _isLoading = false;
  String? _selectedCategory;

  // Variables para manejar los mensajes de error
  String? _nameError, _descriptionError, _basePriceError, _categoryError;

  final List<ProductVariant> _additionalVariants = [];

  final Map<String, List<String>> categorySizes = {
    'Zapatos': ['35', '36', '37', '38', '39', '40'],
    'Poleras': ['XS', 'S', 'M', 'L', 'XL'],
    'Pantalones': ['28', '30', '32', '34'],
    'Accesorios': ['Única'],
  };

  final Map<String, List<String>> categoryColors = {
    'Zapatos': ['Negro', 'Blanco', 'Rojo', 'Azul', 'Marrón'],
    'Poleras': ['Rojo', 'Azul', 'Verde', 'Amarillo', 'Negro'],
    'Pantalones': ['Negro', 'Azul', 'Gris', 'Verde'],
    'Accesorios': ['Rojo', 'Blanco', 'Negro', 'Verde'],
  };

  ProductVariant _firstVariant = ProductVariant(
    id: 0,
    size: '',
    color: '',
    price: 0.0,
    stock: 0,
    imageUrl: null,
  );

  Future<void> _saveProduct() async {
    if (_nameController.text.trim().isEmpty || _selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('El nombre y la categoría son obligatorios')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Copiar valores de la primera variante
    _firstVariant = _firstVariant.copyWith(
      size: _firstVariantSizeController.text.trim(),
      color: _firstVariantColorController.text.trim(),
      price: double.tryParse(_priceController.text.trim()) ?? 0.0,
      stock: int.tryParse(_firstVariantStockController.text.trim()) ?? 0,
    );

    // Verifica las variantes antes de enviarlas
    final variants = [_firstVariant, ..._additionalVariants];
    debugPrint('Nombre: ${_nameController.text}');
    debugPrint('Categoría: $_selectedCategory');
    debugPrint('Variantes: $variants');

    final newProduct = Product(
      id: 0,
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      category: _selectedCategory ?? '',
      basePrice: double.tryParse(_priceController.text.trim()) ?? 0.0,
      imageUrl: null,
      qrCodeUrl: null,
      variants: variants,
    );

    final inventoryProvider =
        Provider.of<InventoryProvider>(context, listen: false);

    try {
      final errors = await inventoryProvider.addProduct(newProduct);

      if (!mounted) return;

      if (errors != null) {
        setState(() {
          _nameError = errors['Name'];
          _descriptionError = errors['Description'];
          _basePriceError = errors['BasePrice'];
          _categoryError = errors['Category'];
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Producto agregado exitosamente')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error inesperado: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _addVariantDialog() {
    final TextEditingController sizeController = TextEditingController();
    final TextEditingController colorController = TextEditingController();
    final TextEditingController priceController =
        TextEditingController(text: _priceController.text);
    final TextEditingController stockController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Agregar Variante'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                DropdownButtonFormField<String>(
                  value: sizeController.text.isNotEmpty
                      ? sizeController.text
                      : null,
                  items: (_selectedCategory != null &&
                          categorySizes[_selectedCategory!] != null)
                      ? categorySizes[_selectedCategory!]!
                          .map((size) => DropdownMenuItem<String>(
                                value: size,
                                child: Text(size),
                              ))
                          .toList()
                      : [],
                  onChanged: (value) {
                    sizeController.text = value ?? '';
                  },
                  decoration: const InputDecoration(
                    labelText: 'Talla',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: colorController.text.isNotEmpty
                      ? colorController.text
                      : null,
                  items: (_selectedCategory != null &&
                          categoryColors[_selectedCategory!] != null)
                      ? categoryColors[_selectedCategory!]!
                          .map((color) => DropdownMenuItem<String>(
                                value: color,
                                child: Text(color),
                              ))
                          .toList()
                      : [],
                  onChanged: (value) {
                    colorController.text = value ?? '';
                  },
                  decoration: const InputDecoration(
                    labelText: 'Color',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Precio'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: stockController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Stock'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                final String size = sizeController.text.trim();
                final String color = colorController.text.trim();
                final double price =
                    double.tryParse(priceController.text.trim()) ?? 0.0;
                final int stock =
                    int.tryParse(stockController.text.trim()) ?? 0;

                if (size.isEmpty || color.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('La talla y el color son obligatorios'),
                    ),
                  );
                  return;
                }

                setState(() {
                  _additionalVariants.add(
                    ProductVariant(
                      id: 0,
                      size: size,
                      color: color,
                      price: price,
                      stock: stock,
                      imageUrl: null,
                    ),
                  );
                });
                Navigator.pop(context);
              },
              child: const Text('Agregar'),
            ),
          ],
        );
      },
    );
  }

  void _removeVariant(int index) {
    setState(() {
      _additionalVariants.removeAt(index);
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _firstVariantSizeController.dispose();
    _firstVariantColorController.dispose();
    _firstVariantPriceController.dispose();
    _firstVariantStockController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Producto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nombre',
                  border: const OutlineInputBorder(),
                  errorText: _nameError,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Descripción',
                  border: const OutlineInputBorder(),
                  errorText: _descriptionError,
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: categorySizes.keys
                    .map((category) => DropdownMenuItem<String>(
                          value: category,
                          child: Text(category),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                    if (_selectedCategory != null) {
                      final sizes = categorySizes[_selectedCategory];
                      final colors = categoryColors[_selectedCategory];
                      _firstVariantSizeController.text = sizes?.first ?? '';
                      _firstVariantColorController.text = colors?.first ?? '';
                    }
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Categoría',
                  border: const OutlineInputBorder(),
                  errorText: _categoryError,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Precio Base',
                  border: const OutlineInputBorder(),
                  errorText: _basePriceError,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Detalles',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      DropdownButtonFormField<String>(
                        value: _firstVariantSizeController.text.isNotEmpty
                            ? _firstVariantSizeController.text
                            : null,
                        items: (_selectedCategory != null &&
                                categorySizes[_selectedCategory!] != null)
                            ? categorySizes[_selectedCategory!]!
                                .map((size) => DropdownMenuItem<String>(
                                      value: size,
                                      child: Text(size),
                                    ))
                                .toList()
                            : [],
                        onChanged: (value) {
                          setState(() {
                            _firstVariantSizeController.text = value ?? '';
                          });
                        },
                        decoration: const InputDecoration(
                          labelText: 'Talla',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _firstVariantColorController.text.isNotEmpty
                            ? _firstVariantColorController.text
                            : null,
                        items: (_selectedCategory != null &&
                                categoryColors[_selectedCategory!] != null)
                            ? categoryColors[_selectedCategory!]!
                                .map((color) => DropdownMenuItem<String>(
                                      value: color,
                                      child: Text(color),
                                    ))
                                .toList()
                            : [],
                        onChanged: (value) {
                          setState(() {
                            _firstVariantColorController.text = value ?? '';
                          });
                        },
                        decoration: const InputDecoration(
                          labelText: 'Color',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _priceController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Precio Base',
                          border: const OutlineInputBorder(),
                          errorText: _basePriceError,
                        ),
                        onChanged: (value) {
                          setState(() {
                            _firstVariantPriceController.text =
                                double.tryParse(value) != null ? value : '0.0';
                          });
                        },
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _firstVariantStockController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Stock',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Variantes Adicionales',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton(
                    onPressed: _addVariantDialog,
                    style: ElevatedButton.styleFrom(
                        side: BorderSide(color: Color(0xFF82A7EF)),
                        backgroundColor: Color(0xFFDEEAFF),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8))),
                    child: const Text('Agregar Variante'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _additionalVariants.length,
                itemBuilder: (context, index) {
                  final variant = _additionalVariants[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          TextField(
                            decoration: InputDecoration(
                              labelText: 'Talla',
                              border: const OutlineInputBorder(),
                              hintText: variant.size,
                            ),
                            controller:
                                TextEditingController(text: variant.size),
                            onChanged: (value) {
                              setState(() {
                                _additionalVariants[index] =
                                    variant.copyWith(size: value);
                              });
                            },
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            decoration: InputDecoration(
                              labelText: 'Color',
                              border: const OutlineInputBorder(),
                              hintText: variant.color,
                            ),
                            controller:
                                TextEditingController(text: variant.color),
                            onChanged: (value) {
                              setState(() {
                                _additionalVariants[index] =
                                    variant.copyWith(color: value);
                              });
                            },
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            decoration: InputDecoration(
                              labelText: 'Precio',
                              border: const OutlineInputBorder(),
                              hintText: variant.price.toString(),
                            ),
                            controller: TextEditingController(
                                text: variant.price.toString()),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              setState(() {
                                _additionalVariants[index] = variant.copyWith(
                                    price: double.tryParse(value) ?? 0.0);
                              });
                            },
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            decoration: InputDecoration(
                              labelText: 'Stock',
                              border: const OutlineInputBorder(),
                              hintText: variant.stock.toString(),
                            ),
                            controller: TextEditingController(
                                text: variant.stock.toString()),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              setState(() {
                                _additionalVariants[index] = variant.copyWith(
                                    stock: int.tryParse(value) ?? 0);
                              });
                            },
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _removeVariant(index),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 48),
                        backgroundColor: Color(0XFF265DD4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      onPressed: _saveProduct,
                      child: const Text(
                        'Guardar Producto',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
