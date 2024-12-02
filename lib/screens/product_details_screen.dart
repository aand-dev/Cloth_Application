import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:typed_data'; // Para manejar los bytes de la imagen
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:provider/provider.dart';
import 'package:stock_application/config/app_config.dart';
import 'package:stock_application/screens/edit_product_screen.dart';
import '../providers/inventory_provider.dart';

class ProductDetailsScreen extends StatefulWidget {
  final int productId;

  const ProductDetailsScreen({super.key, required this.productId});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late Future<void> _loadProductFuture;

  @override
  void initState() {
    super.initState();
    _loadProductFuture = _loadProductDetails();
  }

  Future<void> _loadProductDetails() async {
    final inventoryProvider =
        Provider.of<InventoryProvider>(context, listen: false);
    await inventoryProvider.loadProductDetails(widget.productId);
  }

  Future<void> _exportQR(BuildContext context, String qrImageUrl) async {
    try {
      // Descargar la imagen QR desde la URL
      final response = await http.get(Uri.parse(qrImageUrl));
      if (response.statusCode != 200) {
        throw Exception('No se pudo descargar la imagen del QR.');
      }
      final Uint8List imageBytes =
          response.bodyBytes; // Obtener los bytes de la imagen

      // Crear el documento PDF
      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          build: (pw.Context context) => pw.Center(
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text('Etiqueta QR', style: pw.TextStyle(fontSize: 24)),
                pw.SizedBox(height: 20),
                pw.Image(pw.MemoryImage(imageBytes), width: 200, height: 200),
                pw.SizedBox(height: 20),
                pw.Text(
                  'Utiliza este código QR para consultar la información del producto.',
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      );

      // Obtener directorio para guardar el archivo
      final directory = await getTemporaryDirectory();
      final filePath = '${directory.path}/qr_code_product.pdf';

      // Guardar el PDF
      final file = File(filePath);
      await file.writeAsBytes(await pdf.save());

      // Abrir el archivo PDF
      await OpenFile.open(file.path);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al exportar el QR: $e')),
      );
    }
  }

  void _showQRExportDialog(String qrImageUrl, String productName) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Exportar QR'),
        content: const Text(
            '¿Quieres exportar este código QR como una etiqueta en formato PDF?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _exportQR(context, qrImageUrl); // Orden corregido
            },
            child: const Text('Exportar'),
          ),
        ],
      ),
    );
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Información'),
        content: const Text(
            'Puedes exportar el código QR para imprimirlo como etiqueta. Solo toca el QR para comenzar.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar Producto'),
        content:
            const Text('¿Estás seguro de que deseas eliminar este producto?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              final inventoryProvider =
                  Provider.of<InventoryProvider>(context, listen: false);
              await inventoryProvider.deleteProduct(widget.productId);
              Navigator.pop(context); // Vuelve a la lista de productos
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedProduct =
        Provider.of<InventoryProvider>(context).selectedProduct;

    return WillPopScope(
      onWillPop: () async {
        final inventoryProvider =
            Provider.of<InventoryProvider>(context, listen: false);
        await inventoryProvider.loadProducts();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Detalles del Producto'),
          actions: [
            IconButton(
              icon: const Icon(Icons.info_outline),
              onPressed: _showInfoDialog,
            ),
          ],
        ),
        body: FutureBuilder<void>(
          future: _loadProductFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else if (selectedProduct == null) {
              return const Center(
                child: Text('Producto no encontrado.'),
              );
            } else {
              final product = selectedProduct;
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundImage: product.imageUrl != null
                              ? NetworkImage(product.imageUrl!)
                              : const AssetImage(
                                      'assets/images/placeholder.png')
                                  as ImageProvider,
                        ),
                        if (product.qrCodeUrl != null)
                          GestureDetector(
                            onTap: () => _showQRExportDialog(
                                product.getFullQrCodeUrl(AppConfig.urlQr),
                                product.name),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border:
                                    Border.all(color: const Color(0XFF82A7EF)),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  product.getFullQrCodeUrl(AppConfig.urlQr),
                                  height: 120,
                                  width: 120,
                                  errorBuilder: (_, __, ___) =>
                                      const Text('QR no disponible'),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Nombre: ${product.name}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Text('Descripción: ${product.description}'),
                    const SizedBox(height: 16),
                    Text('Categoría: ${product.category}'),
                    const SizedBox(height: 16),
                    Text(
                        'Precio Base: \$${product.basePrice.toStringAsFixed(2)}'),
                    const SizedBox(height: 16),
                    const Text(
                      'Variantes',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: product.variants.length,
                      itemBuilder: (context, index) {
                        final variant = product.variants[index];
                        return ListTile(
                          title: Text(
                              'Talla: ${variant.size} - Color: ${variant.color}'),
                          subtitle: Text(
                              'Stock: ${variant.stock} - Precio: \$${variant.price.toStringAsFixed(2)}'),
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0XFFDEEAFF)),
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    EditProductScreen(product: product),
                              ),
                            );
                            setState(() {
                              _loadProductFuture = _loadProductDetails();
                            });
                          },
                          child: const Text('Actualizar'),
                        ),
                        ElevatedButton(
                          onPressed: _confirmDelete,
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red),
                          child: const Text(
                            'Eliminar Producto',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
