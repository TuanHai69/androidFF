import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/order.dart';
import 'order_manager.dart';
import 'order_detail.dart'; // Import trang order_detail.dart
import 'package:intl/intl.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');

    if (userId != null) {
      await Provider.of<OrderManager>(context, listen: false)
          .fetchOrdersByUser(userId);
    }
  }

  String formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(date);
  }

  List<Order> _sortOrdersByDate(List<Order> orders) {
    List<Order> sortedOrders = List.from(orders);
    sortedOrders.sort((a, b) => b.date.compareTo(a.date));
    return sortedOrders;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đơn hàng của bạn'),
      ),
      body: Consumer<OrderManager>(
        builder: (context, orderManager, child) {
          List<Order> sortedOrders = _sortOrdersByDate(orderManager.orders);

          return ListView.builder(
            itemCount: sortedOrders.length,
            itemBuilder: (context, index) {
              final order = sortedOrders[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          'Mã đơn hàng: MD${order.id}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Tổng giá: ${order.price}',
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 4.0),
                              Text(
                                'Ngày đặt hàng: ${formatDate(order.date)}',
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 4.0),
                              Text(
                                'Trạng thái: ${order.state}',
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.green),
                              ),
                            ],
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      OrderDetailScreen(order: order),
                                ),
                              );
                            },
                            child: const Text('Xem chi tiết'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8.0),
                      if (order.state == 'Shipping')
                        ElevatedButton(
                          onPressed: () async {
                            await _confirmOrder(context, order);
                          },
                          child: const Text('Xác nhận đơn hàng'),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _confirmOrder(BuildContext context, Order order) async {
    await Provider.of<OrderManager>(context, listen: false).updateOrder(
      order.copyWith(state: 'Received'),
    );
  }
}
