import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/order.dart';

class OrderService {
  static const String baseUrl = 'http://192.168.56.1:3000/api/order';

  Future<Order?> fetchOrder(String id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$id'));

      if (response.statusCode == 200) {
        final orderMap = json.decode(response.body) as Map<String, dynamic>;
        return Order.fromJson(orderMap);
      } else {
        print('Failed to load order: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching order: $error');
    }
    return null;
  }

  Future<List<Order>> fetchAllOrders() async {
    List<Order> orders = [];
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        final orderList = json.decode(response.body) as List<dynamic>;
        orders = orderList.map((order) => Order.fromJson(order)).toList();
      } else {
        print('Failed to load orders: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching orders: $error');
    }
    return orders;
  }

  Future<List<Order>> fetchOrdersByUser(String userid) async {
    List<Order> orders = [];
    try {
      final response = await http.get(Uri.parse('$baseUrl/user/$userid'));
      if (response.statusCode == 200) {
        final orderList = json.decode(response.body) as List<dynamic>;
        orders = orderList.map((order) => Order.fromJson(order)).toList();
      } else {
        print('Failed to load orders by user: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching orders by user: $error');
    }
    return orders;
  }

  Future<List<Order>> fetchOrdersByStore(String storeid) async {
    List<Order> orders = [];
    try {
      final response = await http.get(Uri.parse('$baseUrl/store/$storeid'));
      if (response.statusCode == 200) {
        final orderList = json.decode(response.body) as List<dynamic>;
        orders = orderList.map((order) => Order.fromJson(order)).toList();
      } else {
        print('Failed to load orders by store: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching orders by store: $error');
    }
    return orders;
  }

  Future<List<Order>> fetchOrdersByUserIdAndStoreId(
      String userid, String storeid) async {
    List<Order> orders = [];
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/user/$userid/store/$storeid'));
      if (response.statusCode == 200) {
        final orderList = json.decode(response.body) as List<dynamic>;
        orders = orderList.map((order) => Order.fromJson(order)).toList();
      } else {
        print(
            'Failed to load orders by user and store: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching orders by user and store: $error');
    }
    return orders;
  }

  Future<Order?> addOrder(Order order) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(order.toJson()),
      );
      if (response.statusCode == 200) {
        final newOrder = json.decode(response.body) as Map<String, dynamic>;
        return Order.fromJson(newOrder);
      } else {
        print('Failed to add order: ${response.statusCode}');
      }
    } catch (error) {
      print('Error adding order: $error');
    }
    return null;
  }

  Future<bool> updateOrder(Order order) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/${order.id}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(order.toJson()),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to update order: ${response.statusCode}');
      }
    } catch (error) {
      print('Error updating order: $error');
    }
    return false;
  }

  Future<bool> deleteOrder(String id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));
      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to delete order: ${response.statusCode}');
      }
    } catch (error) {
      print('Error deleting order: $error');
    }
    return false;
  }
}
