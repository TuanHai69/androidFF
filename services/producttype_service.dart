import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/producttype.dart';

class ProductTypeService {
  static const String baseUrl = 'http://192.168.56.1:3000/api/producttype';

  Future<ProductType?> fetchProductType(String id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$id'));

      if (response.statusCode == 200) {
        final productTypeMap =
            json.decode(response.body) as Map<String, dynamic>;
        return ProductType.fromJson(productTypeMap);
      } else {
        print('Failed to load product type: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching product type: $error');
    }
    return null;
  }

  Future<List<ProductType>> fetchAllProductTypes() async {
    List<ProductType> productTypes = [];
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        final productTypeList = json.decode(response.body) as List<dynamic>;
        productTypes = productTypeList
            .map((productType) => ProductType.fromJson(productType))
            .toList();
      } else {
        print('Failed to load product types: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching product types: $error');
    }
    return productTypes;
  }

  Future<List<ProductType>> fetchProductTypesByProduct(String productid) async {
    List<ProductType> productTypes = [];
    try {
      final response = await http.get(Uri.parse('$baseUrl/product/$productid'));
      if (response.statusCode == 200) {
        final productTypeList = json.decode(response.body) as List<dynamic>;
        productTypes = productTypeList
            .map((productType) => ProductType.fromJson(productType))
            .toList();
      } else {
        print(
            'Failed to load product types by product: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching product types by product: $error');
    }
    return productTypes;
  }

  Future<List<ProductType>> fetchProductTypesByType(String typeid) async {
    List<ProductType> productTypes = [];
    try {
      final response = await http.get(Uri.parse('$baseUrl/type/$typeid'));
      if (response.statusCode == 200) {
        final productTypeList = json.decode(response.body) as List<dynamic>;
        productTypes = productTypeList
            .map((productType) => ProductType.fromJson(productType))
            .toList();
      } else {
        print('Failed to load product types by type: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching product types by type: $error');
    }
    return productTypes;
  }

  Future<ProductType?> addProductType(ProductType productType) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(productType.toJson()),
      );
      if (response.statusCode == 200) {
        final newProductType =
            json.decode(response.body) as Map<String, dynamic>;
        return ProductType.fromJson(newProductType);
      } else {
        print('Failed to add product type: ${response.statusCode}');
      }
    } catch (error) {
      print('Error adding product type: $error');
    }
    return null;
  }

  Future<bool> updateProductType(ProductType productType) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/${productType.id}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(productType.toJson()),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to update product type: ${response.statusCode}');
      }
    } catch (error) {
      print('Error updating product type: $error');
    }
    return false;
  }

  Future<bool> deleteProductType(String id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));
      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to delete product type: ${response.statusCode}');
      }
    } catch (error) {
      print('Error deleting product type: $error');
    }
    return false;
  }
}
