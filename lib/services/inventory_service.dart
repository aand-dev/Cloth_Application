import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stock_application/models/product_model.dart';
import '../config/app_config.dart';

class InventoryService {
  final String _baseUrl = AppConfig.apiBaseUrl;

  // Obtener todos los productos con sus variantes
  Future<List<Product>> fetchProducts() async {
    final url = Uri.parse('$_baseUrl/product');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => Product.fromJson(item)).toList();
    } else {
      throw Exception('Error al obtener los productos: ${response.statusCode}');
    }
  }

  // Obtener los detalles de un producto con sus variantes
  Future<Product> fetchProductDetails(int productId) async {
    final url = Uri.parse('$_baseUrl/product/$productId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Product.fromJson(data);
    } else {
      throw Exception(
          'Error al obtener los detalles del producto: ${response.body}');
    }
  }

  // Agregar un producto con variantes
  Future<Map<String, String>?> addProduct(Product product) async {
    final url = Uri.parse('$_baseUrl/product');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(product.toJsonWithVariants()),
    );

    if (response.statusCode == 201) {
      return null; // Producto creado exitosamente
    } else if (response.statusCode == 400) {
      final responseData = jsonDecode(response.body) as Map<String, dynamic>;
      if (responseData.containsKey('errors')) {
        // Convertir errores a un formato simple para el frontend
        final errors = responseData['errors'] as Map<String, dynamic>;
        return errors.map((key, value) {
          if (value is List) {
            return MapEntry(key, (value).join('\n'));
          } else if (value is String) {
            return MapEntry(key, value);
          } else {
            return MapEntry(key, 'Error desconocido.');
          }
        });
      }
      throw Exception('Error inesperado: ${response.body}');
    } else {
      throw Exception('Error al agregar el producto: ${response.body}');
    }
  }

  // Actualizar un producto y sus variantes
  Future<void> updateProduct(Product product) async {
    final url = Uri.parse('$_baseUrl/product/${product.id}');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(product.toJsonWithVariants()),
    );

    if (response.statusCode != 204) {
      throw Exception('Error al actualizar el producto: ${response.body}');
    }
  }

  // Eliminar un producto y sus variantes
  Future<void> deleteProduct(int productId) async {
    final url = Uri.parse('$_baseUrl/product/$productId');
    final response = await http.delete(url);

    if (response.statusCode != 204) {
      throw Exception('Error al eliminar el producto: ${response.body}');
    }
  }
}
