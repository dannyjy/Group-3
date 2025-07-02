import 'package:flutter/material.dart';
import 'package:group_3/models/product.dart';
// For accessing AuthService

class ProductService extends ChangeNotifier {
  final List<Product> _products = []; // In-memory storage for products

  List<Product> get products => List.unmodifiable(_products); // Immutable list

  // Add a new product
  Future<String> addProduct({
    required String name,
    required int quantity,
    required String category,
  }) async {
    try {
      final Product product = Product(
        name: name,
        quantity: quantity,
        category: category,
      );

      _products.add(product);
      notifyListeners(); // Notify listeners that the product list has changed
      return 'success';
    } catch (e) {
      return e.toString();
    }
  }

  // Update an existing product
  Future<String> updateProduct({
    required String productId,
    required String name,
    required int quantity,
    required String category,
  }) async {
    try {
      final int index = _products.indexWhere((p) => p.id == productId);
      if (index == -1) {
        return 'Product not found.';
      }

      _products[index] = _products[index].copyWith(
        name: name,
        quantity: quantity,
        category: category,
      );
      notifyListeners();
      return 'success';
    } catch (e) {
      return e.toString();
    }
  }

  // Delete a product
  Future<String> deleteProduct({
    required String productId,
  }) async {
    try {
      _products.removeWhere((p) => p.id == productId);
      notifyListeners();
      return 'success';
    } catch (e) {
      return e.toString();
    }
  }
}
