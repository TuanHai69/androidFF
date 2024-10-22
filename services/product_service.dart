import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ProductService {
  static const String baseUrl = 'http://192.168.56.1:3000/api/product';

  Future<Product?> fetchProduct(String id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$id'));

      if (response.statusCode == 200) {
        final productMap = json.decode(response.body) as Map<String, dynamic>;
        return Product.fromJson(productMap);
      } else {
        print('Failed to load product: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching product: $error');
    }
    return null;
  }

  Future<List<Product>> fetchAllProducts() async {
    List<Product> products = [];
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        final productList = json.decode(response.body) as List<dynamic>;
        products =
            productList.map((product) => Product.fromJson(product)).toList();
      } else {
        print('Failed to load products: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching products: $error');
    }
    return products;
  }

  Future<List<Product>> fetchProductsByStore(String storeid) async {
    List<Product> products = [];
    try {
      final response = await http.get(Uri.parse('$baseUrl/store/$storeid'));
      if (response.statusCode == 200) {
        final productList = json.decode(response.body) as List<dynamic>;
        products =
            productList.map((product) => Product.fromJson(product)).toList();
      } else {
        print('Failed to load products by store: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching products by store: $error');
    }
    return products;
  }

  Future<List<Product>> fetchProductsByState(String state) async {
    List<Product> products = [];
    try {
      final response = await http.get(Uri.parse('$baseUrl/state/$state'));
      if (response.statusCode == 200) {
        final productList = json.decode(response.body) as List<dynamic>;
        products =
            productList.map((product) => Product.fromJson(product)).toList();
      } else {
        print('Failed to load products by state: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching products by state: $error');
    }
    return products;
  }

  Future<Product?> addProduct(Product product) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(product.toJson()),
      );
      if (response.statusCode == 200) {
        final newProduct = json.decode(response.body) as Map<String, dynamic>;
        return Product.fromJson(newProduct);
      } else {
        print('Failed to add product: ${response.statusCode}');
      }
    } catch (error) {
      print('Error adding product: $error');
    }
    return null;
  }

  Future<bool> updateProduct(Product product) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/${product.id}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(product.toJson()),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to update product: ${response.statusCode}');
      }
    } catch (error) {
      print('Error updating product: $error');
    }
    return false;
  }

  Future<bool> deleteProduct(String id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));
      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to delete product: ${response.statusCode}');
      }
    } catch (error) {
      print('Error deleting product: $error');
    }
    return false;
  }
}
