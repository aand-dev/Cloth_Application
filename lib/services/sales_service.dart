import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:stock_application/models/sale_create_model.dart';
import 'package:stock_application/models/sale_detail_model.dart';
import 'package:stock_application/models/sale_summary_model.dart';
import '../config/app_config.dart';

class SalesService {
  final String _baseUrl = '${AppConfig.apiBaseUrl}/sales';

  // Registrar una nueva venta
  Future<int> registerSale(SaleCreate saleCreate) async {
    final url = Uri.parse(_baseUrl);
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(saleCreate.toJson()),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Verificar que `saleId` esté presente y sea válido
        if (data.containsKey('saleId') && data['saleId'] != null) {
          return data['saleId'];
        } else {
          throw Exception(
              'Error en la respuesta: `saleId` no proporcionado o inválido.');
        }
      } else if (response.statusCode == 400) {
        throw Exception(
            'Error en los datos enviados al registrar la venta: ${response.body}');
      } else if (response.statusCode == 404) {
        throw Exception(
            'El recurso solicitado no fue encontrado: ${response.body}');
      } else if (response.statusCode == 500) {
        throw Exception('Error interno en el servidor al registrar la venta.');
      } else {
        throw Exception(
            'Error inesperado: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      // Manejar excepciones de red u otros errores
      throw Exception('Error al registrar la venta: $e');
    }
  }

  /// Obtener detalles de una venta específica
  Future<SaleDetail> getSaleDetails(int saleId) async {
    final url = Uri.parse('$_baseUrl/$saleId');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return SaleDetail.fromJson(data);
      } else if (response.statusCode == 404) {
        throw Exception('Venta no encontrada.');
      } else {
        throw Exception(
            'Error al obtener los detalles de la venta: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error al conectar con el servidor: $e');
    }
  }

  /// Listar todas las ventas
  Future<List<SaleSummary>> getAllSales() async {
    final url = Uri.parse(_baseUrl);
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        debugPrint('Respuesta del servidor: ${response.body}');
        final List<dynamic> data = jsonDecode(response.body);

        return data.map<SaleSummary>((sale) {
          debugPrint('Procesando venta: $sale');
          return SaleSummary.fromJson(sale);
        }).toList();
      } else {
        debugPrint('Error al listar ventas: ${response.body}');
        throw Exception('Error al listar las ventas: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error al conectar con el servidor: $e');
      throw Exception('Error al conectar con el servidor: $e');
    }
  }

  /// Generar recibo en formato PDF
  Future<Uint8List> generateReceipt(int saleId) async {
    final url = Uri.parse('$_baseUrl/$saleId/receipt');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else if (response.statusCode == 404) {
        throw Exception('Venta no encontrada para generar recibo.');
      } else {
        throw Exception('Error al generar el recibo: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error al conectar con el servidor: $e');
    }
  }
}
