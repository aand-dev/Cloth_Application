import 'package:flutter/material.dart';
import 'package:stock_application/models/product_model.dart';
import 'package:stock_application/models/product_variant_model.dart';
import 'package:stock_application/services/inventory_service.dart';

class InventoryProvider with ChangeNotifier {
  final InventoryService _inventoryService = InventoryService();
  List<Product> _products = [];
  Product? _selectedProduct;

  List<Product> get products => _products;
  Product? get selectedProduct => _selectedProduct;

  // Cargar todos los productos desde el servicio
  Future<void> loadProducts() async {
    try {
      _products = await _inventoryService.fetchProducts();
      notifyListeners(); // Notifica a los listeners después de la carga
    } catch (e) {
      debugPrint('Error al cargar productos: $e');
      throw Exception('Error al cargar productos');
    }
  }

  // Obtener los detalles de un producto específico
  Future<void> loadProductDetails(int productId) async {
    try {
      final updatedProduct =
          await _inventoryService.fetchProductDetails(productId);
      _selectedProduct = updatedProduct;

      // Opcional: Actualizar la lista de productos si es necesario
      final productIndex = _products.indexWhere((p) => p.id == productId);
      if (productIndex != -1) {
        _products[productIndex] = updatedProduct;
      }

      notifyListeners(); // Notifica a los listeners de los cambios
    } catch (e) {
      debugPrint('Error al cargar detalles del producto: $e');
      throw Exception('Error al cargar detalles del producto');
    }
  }

  // Agregar un producto con variantes
  Future<Map<String, String>?> addProduct(Product product) async {
    try {
      final errors = await _inventoryService.addProduct(product);
      if (errors == null) {
        await loadProducts(); // Recargar la lista después de agregar
      }
      return errors; // Retornar errores para manejar en la vista
    } catch (e) {
      debugPrint('Error al agregar producto: $e');
      throw Exception('Error al agregar producto');
    }
  }

  // Actualizar un producto y sus variantes
  Future<void> updateProduct(Product product) async {
    try {
      await _inventoryService.updateProduct(product);
      await loadProducts(); // Recargar la lista después de actualizar
    } catch (e) {
      debugPrint('Error al actualizar producto: $e');
      throw Exception('Error al actualizar producto');
    }
  }

  // Eliminar un producto
  Future<void> deleteProduct(int productId) async {
    try {
      await _inventoryService.deleteProduct(productId);
      await loadProducts(); // Recargar la lista después de eliminar
    } catch (e) {
      debugPrint('Error al eliminar producto: $e');
      throw Exception('Error al eliminar producto');
    }
  }

  // Obtener el stock total de un producto (sumando todas sus variantes)
  int getTotalStock(Product product) {
    return product.variants.fold(0, (total, variant) => total + variant.stock);
  }

  // Reducir stock de un producto
  Future<void> reduceStock({
    required int productId,
    required int variantId,
    required int quantity,
  }) async {
    try {
      final productIndex = _products.indexWhere((p) => p.id == productId);
      if (productIndex == -1) {
        throw Exception('Producto no encontrado.');
      }

      final product = _products[productIndex];
      final variantIndex =
          product.variants.indexWhere((v) => v.id == variantId);
      if (variantIndex == -1) {
        throw Exception('Variante no encontrada.');
      }

      final variant = product.variants[variantIndex];

      if (variant.stock < quantity) {
        throw Exception(
            'Stock insuficiente para la variante seleccionada del producto.');
      }

      // Crear una nueva variante con el stock reducido
      final updatedVariant = variant.copyWith(stock: variant.stock - quantity);

      // Actualizar la lista de variantes del producto
      final updatedVariants = List<ProductVariant>.from(product.variants)
        ..[variantIndex] = updatedVariant;

      // Crear un nuevo producto con las variantes actualizadas
      final updatedProduct = product.copyWith(variants: updatedVariants);

      // Actualizar la lista de productos
      _products[productIndex] = updatedProduct;

      // Actualizar en el backend
      await _inventoryService.updateProduct(updatedProduct);

      notifyListeners();
    } catch (e) {
      debugPrint('Error al reducir el stock: $e');
      throw Exception('Error al reducir el stock');
    }
  }

  // Obtener variantes de un producto
  List<ProductVariant> getVariants(Product product) {
    return product.variants;
  }
}
