import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../providers/sales_provider.dart';
import '../config/routes.dart';

class ReceiptViewerScreen extends StatefulWidget {
  final Map<String, dynamic>? arguments;

  const ReceiptViewerScreen({super.key, this.arguments});

  @override
  State<ReceiptViewerScreen> createState() => _ReceiptViewerScreenState();
}

class _ReceiptViewerScreenState extends State<ReceiptViewerScreen> {
  Uint8List? _receiptBytes;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _downloadReceipt();
  }

  Future<void> _downloadReceipt() async {
    final saleId = widget.arguments?['saleId'];
    if (saleId == null) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'ID de venta no proporcionado.';
      });
      return;
    }

    try {
      final salesProvider = Provider.of<SalesProvider>(context, listen: false);
      final receipt = await salesProvider.generateReceipt(saleId);

      if (receipt != null && receipt.isNotEmpty) {
        setState(() {
          _receiptBytes = receipt;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Recibo vacío o no disponible.';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error al descargar el recibo: $e';
      });
    }
  }

  Future<void> _saveReceiptToDownloads() async {
    if (_receiptBytes == null) return;

    try {
      final directory = await getExternalStorageDirectory();
      final downloadPath =
          '${directory!.path}/Recibo_${widget.arguments?['saleId']}.pdf';
      final file = File(downloadPath);
      await file.writeAsBytes(_receiptBytes!);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Recibo guardado en Descargas: $downloadPath'),
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al guardar el recibo: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Boleta de Venta')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Boleta de Venta')),
        body: Center(
          child: Text(
            _errorMessage!,
            style: const TextStyle(color: Colors.red),
          ),
        ),
      );
    }

    if (_receiptBytes != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Boleta de Venta'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacementNamed(context, AppRoutes.sales);
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.download),
              onPressed: _saveReceiptToDownloads,
            ),
          ],
        ),
        body: SfPdfViewer.memory(
          _receiptBytes!,
          onDocumentLoadFailed: (details) {
            setState(() {
              _errorMessage = 'Error al cargar el PDF: ${details.description}';
            });
            debugPrint('Error al cargar el PDF: ${details.description}');
          },
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Boleta de Venta')),
      body: const Center(
        child: Text('No se pudo descargar el recibo.'),
      ),
    );
  }
}
