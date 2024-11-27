import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import '../../models/cart.dart';
import '../../models/product.dart';
import '../../models/order.dart';

import '../carts/cart_manager.dart';
import '../products/product_manager.dart';

class OrderDetailScreen extends StatefulWidget {
  final Order order;

  const OrderDetailScreen({Key? key, required this.order}) : super(key: key);

  @override
  _OrderDetailScreenState createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  Map<String, Product> _products = {};
  List<Cart> _carts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCarts();
  }

  Future<void> _fetchCarts() async {
    final cartManager = Provider.of<CartManager>(context, listen: false);
    final productManager = Provider.of<ProductManager>(context, listen: false);
    await cartManager.fetchCartsByOrderId(widget.order.id);
    final carts =
        cartManager.carts.where((cart) => cart.state == 'done').toList();

    for (var cart in carts) {
      final product = await productManager.fetchProduct(cart.productid);
      if (product != null) {
        _products[cart.productid] = product;
      }
    }

    setState(() {
      _carts = carts;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết đơn hàng'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _carts.length,
              itemBuilder: (context, index) {
                final cart = _carts[index];
                final product = _products[cart.productid];
                if (product != null) {
                  return Card(
                    margin: const EdgeInsets.all(8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Image.memory(base64Decode(product.picture),
                              width: 100, height: 100),
                          const SizedBox(width: 16.0),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Tên sản phẩm: ${product.name}',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8.0),
                                Text('Số lượng: ${cart.count}',
                                    style: const TextStyle(fontSize: 14)),
                                const SizedBox(height: 4.0),
                                Text(
                                    'Tổng giá: ${(cart.count * product.cost * (1 - cart.discount / 100)).toStringAsFixed(2)}',
                                    style: const TextStyle(fontSize: 14)),
                                const SizedBox(height: 4.0),
                                Text('Địa chỉ giao hàng: ${cart.address}',
                                    style: const TextStyle(fontSize: 14)),
                                const SizedBox(height: 4.0),
                                Text(
                                    'Số điện thoại người nhận: ${cart.phonenumber}',
                                    style: const TextStyle(fontSize: 14)),
                                const SizedBox(height: 4.0),
                                Text('Mô tả: ${cart.note}',
                                    style: const TextStyle(fontSize: 14)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
    );
  }
}
