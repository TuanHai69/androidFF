import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/cart.dart';

class CartService {
  static const String baseUrl = 'http://192.168.56.1:3000/api/cart';

  Future<Cart?> fetchCart(String id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$id'));

      if (response.statusCode == 200) {
        final cartMap = json.decode(response.body) as Map<String, dynamic>;
        return Cart.fromJson(cartMap);
      } else {
        print('Failed to load cart: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching cart: $error');
    }
    return null;
  }

  Future<List<Cart>> fetchAllCarts() async {
    List<Cart> carts = [];
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        final cartList = json.decode(response.body) as List<dynamic>;
        carts = cartList.map((cart) => Cart.fromJson(cart)).toList();
      } else {
        print('Failed to load carts: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching carts: $error');
    }
    return carts;
  }

  Future<List<Cart>> fetchCartsByUser(String userid) async {
    List<Cart> carts = [];
    try {
      final response = await http.get(Uri.parse('$baseUrl/user/$userid'));
      if (response.statusCode == 200) {
        final cartList = json.decode(response.body) as List<dynamic>;
        carts = cartList.map((cart) => Cart.fromJson(cart)).toList();
      } else {
        print('Failed to load carts by user: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching carts by user: $error');
    }
    return carts;
  }

  Future<List<Cart>> fetchCartsByStore(String storeid) async {
    List<Cart> carts = [];
    try {
      final response = await http.get(Uri.parse('$baseUrl/store/$storeid'));
      if (response.statusCode == 200) {
        final cartList = json.decode(response.body) as List<dynamic>;
        carts = cartList.map((cart) => Cart.fromJson(cart)).toList();
      } else {
        print('Failed to load carts by store: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching carts by store: $error');
    }
    return carts;
  }

  Future<List<Cart>> fetchCartsByUserIdAndStoreId(
      String userid, String storeid) async {
    List<Cart> carts = [];
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/user/$userid/store/$storeid'));
      if (response.statusCode == 200) {
        final cartList = json.decode(response.body) as List<dynamic>;
        carts = cartList.map((cart) => Cart.fromJson(cart)).toList();
      } else {
        print('Failed to load carts by user and store: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching carts by user and store: $error');
    }
    return carts;
  }

  Future<Cart?> addCart(Cart cart) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(cart.toJson()),
      );
      if (response.statusCode == 200) {
        final newCart = json.decode(response.body) as Map<String, dynamic>;
        return Cart.fromJson(newCart);
      } else {
        print('Failed to add cart: ${response.statusCode}');
      }
    } catch (error) {
      print('Error adding cart: $error');
    }
    return null;
  }

  Future<bool> updateCart(Cart cart) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/${cart.id}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(cart.toJson()),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to update cart: ${response.statusCode}');
      }
    } catch (error) {
      print('Error updating cart: $error');
    }
    return false;
  }

  Future<bool> deleteCart(String id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));
      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to delete cart: ${response.statusCode}');
      }
    } catch (error) {
      print('Error deleting cart: $error');
    }
    return false;
  }
}
