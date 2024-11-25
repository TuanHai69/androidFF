import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/order.dart';

class OrderService {
  static const String baseUrl = 'http://192.168.56.1:3000/api/order';

  Future<Order?> fetchOrder(String id) async {
    return _handleGetRequest('$baseUrl/$id');
  }

  Future<List<Order>> fetchAllOrders() async {
    return _handleGetListRequest(baseUrl);
  }

  Future<List<Order>> fetchOrdersByUser(String userid) async {
    return _handleGetListRequest('$baseUrl/user/$userid');
  }

  Future<List<Order>> fetchOrdersByStore(String storeid) async {
    return _handleGetListRequest('$baseUrl/store/$storeid');
  }

  Future<List<Order>> fetchOrdersByUserIdAndStoreId(
      String userid, String storeid) async {
    return _handleGetListRequest('$baseUrl/user/$userid/store/$storeid');
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

  Future<Order?> _handleGetRequest(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
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

  Future<List<Order>> _handleGetListRequest(String url) async {
    List<Order> orders = [];
    try {
      final response = await http.get(Uri.parse(url));
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
}
