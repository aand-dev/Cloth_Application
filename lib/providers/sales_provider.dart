import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:stock_application/models/sale_create_model.dart';
import 'package:stock_application/models/sale_detail_model.dart';
import 'package:stock_application/models/sale_summary_model.dart';
import '../services/sales_service.dart';

class SalesProvider with ChangeNotifier {
  final SalesService _salesService = SalesService();

  List<SaleSummary> _sales = [];
  SaleDetail? _selectedSaleDetail;
  SaleDetail? _clientDetails; // Detalles del cliente seleccionado
  List<SaleSummary> _filteredClients = [];
  bool _isLoading = false;

  // Getters
  List<SaleSummary> get sales => _sales;
  SaleDetail? get selectedSaleDetail => _selectedSaleDetail;
  SaleDetail? get clientDetails => _clientDetails;
  List<SaleSummary> get filteredClients => _filteredClients;
  bool get isLoading => _isLoading;

  /// Obtener todas las ventas
  Future<void> fetchSales() async {
    _isLoading = true;
    notifyListeners();

    try {
      _sales = await _salesService.getAllSales();
      _filteredClients = _getUniqueClients(); // Genera clientes únicos
    } catch (e) {
      debugPrint('Error al obtener las ventas: $e');
      _sales = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Obtener detalles de una venta específica
  Future<SaleDetail?> fetchSaleDetails(int saleId, {bool notify = true}) async {
    try {
      if (notify) _isLoading = true;
      if (notify) notifyListeners();

      final saleDetail = await _salesService.getSaleDetails(saleId);
      _selectedSaleDetail = saleDetail;

      return saleDetail;
    } catch (e) {
      debugPrint('Error al obtener los detalles de la venta: $e');
      _selectedSaleDetail = null;
      return null;
    } finally {
      if (notify) _isLoading = false;
      if (notify) notifyListeners();
    }
  }

  /// Registrar una nueva venta
  Future<int> registerSale(SaleCreate saleCreate) async {
    _isLoading = true;
    notifyListeners();

    try {
      final saleId = await _salesService.registerSale(saleCreate);
      await fetchSales();
      debugPrint('Venta registrada exitosamente con ID: $saleId');
      return saleId;
    } on Exception catch (e) {
      debugPrint('Error al registrar la venta: $e');
      throw Exception('Error al registrar la venta: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Generar un recibo
  Future<Uint8List?> generateReceipt(int saleId) async {
    try {
      final receiptBytes = await _salesService.generateReceipt(saleId);
      debugPrint('Recibo generado para la venta con ID: $saleId');
      return receiptBytes;
    } catch (e) {
      debugPrint('Error al generar el recibo: $e');
      return null;
    }
  }

  /// Filtrar clientes por nombre
  void filterClientsByName(String query) {
    if (query.isEmpty) {
      _filteredClients = _getUniqueClients();
    } else {
      _filteredClients = _getUniqueClients().where((client) {
        return client.clientName.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    notifyListeners();
  }

  /// Obtener detalles de un cliente (basado en ventas)
  Future<SaleDetail?> fetchClientDetails(int saleId) async {
    try {
      _isLoading = true;
      notifyListeners();
      final saleDetail = await _salesService.getSaleDetails(saleId);
      _clientDetails = saleDetail;
      return saleDetail;
    } catch (e) {
      debugPrint('Error al obtener los detalles del cliente: $e');
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Obtener lista única de clientes a partir de las ventas
  List<SaleSummary> _getUniqueClients() {
    final Map<String, SaleSummary> uniqueClients = {};
    for (var sale in _sales) {
      if (!uniqueClients.containsKey(sale.clientName)) {
        uniqueClients[sale.clientName] = sale;
      }
    }
    return uniqueClients.values.toList();
  }

  /// Obtener cliente por ID de venta
  SaleSummary? getClientById(int saleId) {
    try {
      return _sales.firstWhere((sale) => sale.id == saleId);
    } catch (e) {
      debugPrint('Cliente con ID $saleId no encontrado: $e');
      return null;
    }
  }
}
