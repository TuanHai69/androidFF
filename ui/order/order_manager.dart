import 'package:flutter/material.dart';
import '../../models/order.dart';
import '../../services/order_service.dart';

class OrderManager with ChangeNotifier {
  List<Order> _orders = [];
  Order? _order;

  final OrderService _orderService = OrderService();

  List<Order> get orders => [..._orders];
  Order? get order => _order;

  Future<void> fetchOrder(String id) async {
    _order = await _orderService.fetchOrder(id);
    notifyListeners();
  }

  Future<void> fetchAllOrders() async {
    _orders = await _orderService.fetchAllOrders();
    notifyListeners();
  }

  Future<void> fetchOrdersByUser(String userid) async {
    _orders = await _orderService.fetchOrdersByUser(userid);
    notifyListeners();
  }

  Future<void> fetchOrdersByStore(String storeid) async {
    _orders = await _orderService.fetchOrdersByStore(storeid);
    notifyListeners();
  }

  Future<void> fetchOrdersByUserIdAndStoreId(
      String userid, String storeid) async {
    _orders =
        await _orderService.fetchOrdersByUserIdAndStoreId(userid, storeid);
    notifyListeners();
  }

  Future<void> addOrder(Order order) async {
    final newOrder = await _orderService.addOrder(order);
    if (newOrder != null) {
      _orders.add(newOrder);
      notifyListeners();
    }
  }

  Future<void> updateOrder(Order order) async {
    final success = await _orderService.updateOrder(order);
    if (success) {
      final index = _orders.indexWhere((o) => o.id == order.id);
      if (index != -1) {
        _orders[index] = order;
        notifyListeners();
      }
    }
  }

  Future<void> deleteOrder(String id) async {
    final success = await _orderService.deleteOrder(id);
    if (success) {
      _orders.removeWhere((order) => order.id == id);
      notifyListeners();
    }
  }
}
