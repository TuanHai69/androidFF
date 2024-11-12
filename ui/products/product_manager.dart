import 'package:flutter/material.dart';
import '../../models/product.dart';
import '../../services/product_service.dart';
import '../../services/price_service.dart';

class ProductManager with ChangeNotifier {
  Product? _product;
  List<Product> _products = [];
  final ProductService _productService = ProductService();
  final PriceService _priceService = PriceService();

  Future<Product?> fetchProduct(String id) async {
    _product = await _productService.fetchProduct(id);
    if (_product != null) {
      _product = await _fetchAndSetPrice(_product!);
    }
    notifyListeners();
    return _product;
  }

  Future<void> fetchAllProducts() async {
    _products = await _productService.fetchAllProducts();
    for (int i = 0; i < _products.length; i++) {
      _products[i] = await _fetchAndSetPrice(_products[i]);
    }
    notifyListeners();
  }

  Future<void> fetchProductsByStore(String storeid) async {
    _products = await _productService.fetchProductsByStore(storeid);
    for (int i = 0; i < _products.length; i++) {
      _products[i] = await _fetchAndSetPrice(_products[i]);
    }
    notifyListeners();
  }

  Future<void> fetchProductsByState(String state) async {
    _products = await _productService.fetchProductsByState(state);
    for (int i = 0; i < _products.length; i++) {
      _products[i] = await _fetchAndSetPrice(_products[i]);
    }
    notifyListeners();
  }

  Future<Product> _fetchAndSetPrice(Product product) async {
    final prices =
        await _priceService.fetchPricesByProductWithNoEndDate(product.id);
    if (prices.isNotEmpty) {
      final latestPrice = prices.first;
      return product.copyWith(
        cost: latestPrice.price,
        discount: latestPrice.discount,
      );
    }
    return product;
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
