import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/orderdetail.dart';

class OrderDetailService {
  static const String baseUrl = 'http://192.168.56.1:3000/api/orderdetail';

  Future<OrderDetail?> fetchOrderDetail(String id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$id'));

      if (response.statusCode == 200) {
        final orderDetailMap =
            json.decode(response.body) as Map<String, dynamic>;
        return OrderDetail.fromJson(orderDetailMap);
      } else {
        print('Failed to load order detail: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching order detail: $error');
    }
    return null;
  }

  Future<List<OrderDetail>> fetchAllOrderDetails() async {
    List<OrderDetail> orderDetails = [];
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        final orderDetailList = json.decode(response.body) as List<dynamic>;
        orderDetails = orderDetailList
            .map((orderDetail) => OrderDetail.fromJson(orderDetail))
            .toList();
      } else {
        print('Failed to load order details: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching order details: $error');
    }
    return orderDetails;
  }

  Future<List<OrderDetail>> fetchOrderDetailsByOrder(String orderid) async {
    List<OrderDetail> orderDetails = [];
    try {
      final response = await http.get(Uri.parse('$baseUrl/order/$orderid'));
      if (response.statusCode == 200) {
        final orderDetailList = json.decode(response.body) as List<dynamic>;
        orderDetails = orderDetailList
            .map((orderDetail) => OrderDetail.fromJson(orderDetail))
            .toList();
      } else {
        print('Failed to load order details by order: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching order details by order: $error');
    }
    return orderDetails;
  }

  Future<OrderDetail?> addOrderDetail(OrderDetail orderDetail) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(orderDetail.toJson()),
      );
      if (response.statusCode == 200) {
        final newOrderDetail =
            json.decode(response.body) as Map<String, dynamic>;
        return OrderDetail.fromJson(newOrderDetail);
      } else {
        print('Failed to add order detail: ${response.statusCode}');
      }
    } catch (error) {
      print('Error adding order detail: $error');
    }
    return null;
  }

  Future<bool> updateOrderDetail(OrderDetail orderDetail) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/${orderDetail.id}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(orderDetail.toJson()),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to update order detail: ${response.statusCode}');
      }
    } catch (error) {
      print('Error updating order detail: $error');
    }
    return false;
  }

  Future<bool> deleteOrderDetail(String id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));
      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to delete order detail: ${response.statusCode}');
      }
    } catch (error) {
      print('Error deleting order detail: $error');
    }
    return false;
  }
}
