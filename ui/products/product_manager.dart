import 'package:flutter/material.dart';
import '../../models/product.dart';
import '../../services/product_service.dart';

class ProductManager with ChangeNotifier {
  Product? _product;
  List<Product> _products = [];

  final ProductService _productService = ProductService();

  Future<Product?> fetchProduct(String id) async {
    print(id);
    _product = await _productService.fetchProduct(id);
    print(_product);
    notifyListeners();
    return _product;
  }

  Future<void> fetchAllProducts() async {
    _products = await _productService.fetchAllProducts();
    notifyListeners();
  }

  Future<void> fetchProductsByStore(String storeid) async {
    _products = await _productService.fetchProductsByStore(storeid);
    notifyListeners();
  }

  Future<void> fetchProductsByState(String state) async {
    _products = await _productService.fetchProductsByState(state);
    notifyListeners();
  }

  int get productCount {
    return _products.length;
  }

  Future<String> addProduct(Product product) async {
    try {
      final newProduct = await _productService.addProduct(product);
      if (newProduct != null) {
        _products.add(newProduct);
        notifyListeners();
        return 'Product added successfully';
      } else {
        return 'Failed to add product';
      }
    } catch (error) {
      return 'Failed to add product: $error';
    }
  }

  Product? get product {
    return _product;
  }

  List<Product> get products {
    return [..._products];
  }

  Future<bool> updateProduct(Product product) async {
    final updated = await _productService.updateProduct(product);
    if (updated) {
      final index = _products.indexWhere((p) => p.id == product.id);
      if (index != -1) {
        _products[index] = product;
        notifyListeners();
      }
    }
    return updated;
  }

  Future<bool> deleteProduct(String id) async {
    final success = await _productService.deleteProduct(id);
    if (success) {
      _products.removeWhere((product) => product.id == id);
      notifyListeners();
    }
    return success;
  }
}
