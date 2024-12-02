import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_application/models/sale_create_model.dart';
import 'package:stock_application/providers/inventory_provider.dart';
import 'package:stock_application/widgets/variant_selection_dialog.dart';
import '../models/sale_product_model.dart';
import '../providers/sales_provider.dart';
import '../config/routes.dart';

class SalesFormScreen extends StatefulWidget {
  const SalesFormScreen({super.key});

  @override
  State<SalesFormScreen> createState() => _SalesFormScreenState();
}

class _SalesFormScreenState extends State<SalesFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _clientName;
  String? _clientDni;
  String? _clientEmail;
  List<SaleProduct> _products = [];
  double _totalAmount = 0.0;
  String _paymentMethod = 'Efectivo';

  /// Calcular el total de la venta
  void _calculateTotal() {
    _totalAmount = _products.fold(
      0.0,
      (total, product) => total + (product.quantity * product.unitPrice),
    );
    setState(() {});
  }

  /// Validar stock del producto seleccionado
  Future<bool> _validateStock(SaleProduct selectedProduct) async {
    final inventoryProvider =
        Provider.of<InventoryProvider>(context, listen: false);
    await inventoryProvider.loadProductDetails(selectedProduct.productId);

    final product = inventoryProvider.selectedProduct;
    if (product == null) return false;

    final selectedVariant = product.variants.firstWhere(
      (variant) => variant.id == selectedProduct.variantId,
      orElse: () => throw Exception('Variante no encontrada.'),
    );

    if (selectedVariant.stock < selectedProduct.quantity) {
      _showSnackBar('Stock insuficiente para ${selectedProduct.productName}.');
      return false;
    }
    return true;
  }

  /// Mostrar mensajes de error o éxito
  void _showSnackBar(String message, {Color color = Colors.red}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
  }

  /// Agregar un producto desde un escaneo QR
  Future<void> _addProductFromQR(String productId) async {
    try {
      final inventoryProvider =
          Provider.of<InventoryProvider>(context, listen: false);
      await inventoryProvider.loadProductDetails(int.parse(productId));

      final product = inventoryProvider.selectedProduct;

      if (product == null) {
        throw Exception('Producto no encontrado.');
      }

      if (product.variants.isNotEmpty) {
        final selectedProduct = await showDialog<SaleProduct>(
          context: context,
          builder: (_) => VariantSelectionDialog(product: product),
        );

        if (selectedProduct != null && await _validateStock(selectedProduct)) {
          setState(() {
            _products.add(selectedProduct);
            _calculateTotal();
          });
        }
      } else {
        _showSnackBar('Producto sin variantes no permitido.');
      }
    } catch (e) {
      _showSnackBar('Error al agregar producto: $e');
    }
  }

  /// Abrir la selección manual de productos
  Future<void> _openManualSelection() async {
    final selectedProducts = await Navigator.pushNamed(
      context,
      AppRoutes.selectProduct,
    );

    if (selectedProducts != null && selectedProducts is List<SaleProduct>) {
      for (var product in selectedProducts) {
        if (!await _validateStock(product)) {
          return;
        }
      }

      setState(() {
        _products.addAll(selectedProducts);
        _calculateTotal();
      });
    }
  }

  /// Registrar la venta
  Future<void> _submitForm() async {
    if (_products.isEmpty) {
      _showSnackBar('Debes agregar al menos un producto.');
      return;
    }

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final saleCreate = SaleCreate(
        clientName: _clientName!,
        clientDni: _clientDni!,
        clientEmail: _clientEmail!,
        paymentMethod: _paymentMethod,
        totalAmount: _totalAmount,
        products: _products,
      );

      try {
        final salesProvider =
            Provider.of<SalesProvider>(context, listen: false);

        final saleId = await salesProvider.registerSale(saleCreate);
        debugPrint('Venta registrada con ID: $saleId');

        final inventoryProvider =
            Provider.of<InventoryProvider>(context, listen: false);
        for (var product in _products) {
          await inventoryProvider.reduceStock(
            productId: product.productId,
            variantId: product.variantId,
            quantity: product.quantity,
          );
        }

        final receipt = await salesProvider.generateReceipt(saleId);

        if (receipt != null) {
          _showSnackBar('Venta registrada exitosamente.', color: Colors.green);
          Navigator.pushNamed(
            context,
            AppRoutes.receiptViewer,
            arguments: {'receiptBytes': receipt, 'saleId': saleId},
          );
        } else {
          throw Exception('No se pudo generar el recibo.');
        }
      } catch (e, stackTrace) {
        debugPrint('Error al registrar venta: $e');
        debugPrint('Detalles del stacktrace: $stackTrace');
        debugPrint('Datos de la venta: ${saleCreate.toJson()}');
        debugPrint('Datos enviados al servidor: ${saleCreate.toJson()}');
        _showSnackBar('Error al registrar venta: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrar Venta')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration:
                    const InputDecoration(labelText: 'Nombre del Cliente'),
                validator: (value) =>
                    value!.isEmpty ? 'Campo obligatorio' : null,
                onSaved: (value) => _clientName = value,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'DNI'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Campo obligatorio' : null,
                onSaved: (value) => _clientDni = value,
              ),
              TextFormField(
                decoration:
                    const InputDecoration(labelText: 'Correo Electrónico'),
                keyboardType: TextInputType.emailAddress,
                onSaved: (value) => _clientEmail = value,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () async {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.qrScanner,
                        arguments: (qrCode) {
                          _addProductFromQR(qrCode);
                          Navigator.pop(context);
                        },
                      );
                    },
                    icon: const Icon(Icons.qr_code_scanner),
                    label: const Text('Escanear QR'),
                  ),
                  ElevatedButton.icon(
                    onPressed: _openManualSelection,
                    icon: const Icon(Icons.search),
                    label: const Text('Agregar Producto'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (_products.isNotEmpty)
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _products.length,
                  itemBuilder: (context, index) {
                    final product = _products[index];
                    return ListTile(
                      title: Text(product.productName),
                      subtitle: Text(
                        '${product.variantDescription} - Cantidad: ${product.quantity}, Precio: \$${product.unitPrice}',
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            _products.removeAt(index);
                            _calculateTotal();
                          });
                        },
                      ),
                    );
                  },
                ),
              const SizedBox(height: 16),
              Text(
                'Total: \$${_totalAmount.toStringAsFixed(2)}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _paymentMethod,
                items: const [
                  DropdownMenuItem(value: 'Efectivo', child: Text('Efectivo')),
                  DropdownMenuItem(value: 'Tarjeta', child: Text('Tarjeta')),
                ],
                onChanged: (value) => _paymentMethod = value!,
                decoration: const InputDecoration(labelText: 'Método de Pago'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Registrar Venta'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
