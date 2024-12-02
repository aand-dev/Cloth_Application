import 'package:flutter/material.dart';
import 'package:stock_application/models/product_model.dart';
import 'package:stock_application/models/product_variant_model.dart';
import 'package:stock_application/models/sale_product_model.dart';

class VariantSelectionDialog extends StatefulWidget {
  final Product product;

  const VariantSelectionDialog({super.key, required this.product});

  @override
  State<VariantSelectionDialog> createState() => _VariantSelectionDialogState();
}

class _VariantSelectionDialogState extends State<VariantSelectionDialog> {
  ProductVariant? _selectedVariant;
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Seleccionar Variante: ${widget.product.name}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButton<ProductVariant>(
            isExpanded: true,
            value: _selectedVariant,
            items: widget.product.variants.map((variant) {
              return DropdownMenuItem(
                value: variant,
                child: Text(
                    '${variant.size} - ${variant.color} (\$${variant.price})'),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedVariant = value;
              });
            },
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Cantidad:'),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove_circle),
                    onPressed: _quantity > 1
                        ? () => setState(() {
                              _quantity--;
                            })
                        : null,
                  ),
                  Text('$_quantity'),
                  IconButton(
                    icon: const Icon(Icons.add_circle),
                    onPressed: () => setState(() {
                      _quantity++;
                    }),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _selectedVariant != null
              ? () {
                  Navigator.pop(
                    context,
                    SaleProduct(
                      productId: widget.product.id,
                      variantId: _selectedVariant!.id,
                      productName: widget.product.name,
                      variantDescription:
                          '${_selectedVariant!.size} - ${_selectedVariant!.color}',
                      unitPrice: _selectedVariant!.price,
                      quantity: _quantity,
                    ),
                  );
                }
              : null,
          child: const Text('Agregar'),
        ),
      ],
    );
  }
}
