import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/price.dart';

class PriceService {
  static const String baseUrl = 'http://192.168.56.1:3000/api/price';

  Future<Price?> fetchPrice(String id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$id'));

      if (response.statusCode == 200) {
        final priceMap = json.decode(response.body) as Map<String, dynamic>;
        return Price.fromJson(priceMap);
      } else {
        print('Failed to load price: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching price: $error');
    }
    return null;
  }

  Future<List<Price>> fetchAllPrices() async {
    List<Price> prices = [];
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        final priceList = json.decode(response.body) as List<dynamic>;
        prices = priceList.map((price) => Price.fromJson(price)).toList();
      } else {
        print('Failed to load prices: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching prices: $error');
    }
    return prices;
  }

  Future<List<Price>> fetchPricesByProduct(String productid) async {
    List<Price> prices = [];
    try {
      final response = await http.get(Uri.parse('$baseUrl/product/$productid'));
      if (response.statusCode == 200) {
        final priceList = json.decode(response.body) as List<dynamic>;
        prices = priceList.map((price) => Price.fromJson(price)).toList();
      } else {
        print('Failed to load prices by product: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching prices by product: $error');
    }
    return prices;
  }

  Future<List<Price>> fetchPricesByProductWithNoEndDate(
      String productid) async {
    List<Price> prices = [];
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/product/$productid/no-end-date'));
      if (response.statusCode == 200) {
        final priceList = json.decode(response.body) as List<dynamic>;
        prices = priceList.map((price) => Price.fromJson(price)).toList();
      } else {
        print(
            'Failed to load prices by product with no end date: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching prices by product with no end date: $error');
    }
    return prices;
  }

  Future<Price?> addPrice(Price price) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(price.toJson()),
      );
      if (response.statusCode == 200) {
        final newPrice = json.decode(response.body) as Map<String, dynamic>;
        return Price.fromJson(newPrice);
      } else {
        print('Failed to add price: ${response.statusCode}');
      }
    } catch (error) {
      print('Error adding price: $error');
    }
    return null;
  }

  Future<bool> updatePrice(Price price) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/${price.id}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(price.toJson()),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to update price: ${response.statusCode}');
      }
    } catch (error) {
      print('Error updating price: $error');
    }
    return false;
  }

  Future<bool> deletePrice(String id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));
      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to delete price: ${response.statusCode}');
      }
    } catch (error) {
      print('Error deleting price: $error');
    }
    return false;
  }
}
