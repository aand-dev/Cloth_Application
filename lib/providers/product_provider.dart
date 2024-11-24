import 'package:flutter/material.dart';
import 'package:stock_application/models/product_model.dart';
import 'package:stock_application/services/api_service.dart';

class ProductProvider with ChangeNotifier {
  List<ProductModel> _products = [];
  bool _isLoading = false;

  List<ProductModel> get products => _products;
  bool get isLoading => _isLoading;

  // Método para cargar productos desde la API
  Future<void> loadProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      final apiService = ApiService();
      final data = await apiService.get('products');
      _products = data
          .map<ProductModel>((json) => ProductModel.fromJson(json))
          .toList();
    } catch (e) {
      //print('Error al cargar productos: $e');
    }

    _isLoading = false;
    notifyListeners();
  }
}
