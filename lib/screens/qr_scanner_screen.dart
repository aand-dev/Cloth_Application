import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScannerScreen extends StatelessWidget {
  final void Function(String qrCode) onScan;

  const QRScannerScreen({super.key, required this.onScan});

  @override
  Widget build(BuildContext context) {
    bool isScanning = false; // Bandera para evitar lecturas duplicadas

    return Scaffold(
      appBar: AppBar(
        title: const Text('Escaneo QR'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Coloca el QR dentro del marco.')),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                MobileScanner(
                  onDetect: (capture) {
                    if (!isScanning) {
                      isScanning = true; // Bloquea nuevas lecturas
                      final List<Barcode> barcodes = capture.barcodes;
                      for (final barcode in barcodes) {
                        if (barcode.rawValue != null) {
                          final qrCode = barcode.rawValue!;
                          try {
                            final Map<String, dynamic> data =
                                jsonDecode(qrCode);
                            if (data.containsKey('productId')) {
                              onScan(data['productId'].toString());
                              return;
                            } else {
                              throw Exception(
                                  'El QR no contiene un productId.');
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('QR inválido: $e')),
                            );
                          } finally {
                            Future.delayed(const Duration(seconds: 2), () {
                              isScanning = false; // Permite nuevas lecturas
                            });
                          }
                        }
                      }
                    }
                  },
                ),
                // Marco oscuro con área transparente en el centro
                ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.6),
                    BlendMode.srcOut,
                  ),
                  child: Stack(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          backgroundBlendMode: BlendMode.dstOut,
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: 250,
                          height: 250,
                          decoration: const BoxDecoration(
                            color: Colors.transparent,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Marco visual verde
                Center(
                  child: Container(
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.green,
                        width: 4,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Botón de cancelar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                side: const BorderSide(color: Colors.black, width: 1),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.close),
              label: const Text('Cancelar'),
            ),
          ),
        ],
      ),
    );
  }
}
