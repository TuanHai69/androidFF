import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/socketio.service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:marquee/marquee.dart';
import 'cart_manager.dart';
import '../products/product_manager.dart';
import '../../models/cart.dart';
import '../../models/product.dart';
import 'payment.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Cart> _carts = [];
  Map<String, Product> _products = {};
  bool _isLoading = true;
  final SocketService socketService = SocketService();
  @override
  void initState() {
    super.initState();
    socketService.connect();
    _fetchCarts();
    socketService.on('createCart', (data) async {
      if (mounted) {
        await _fetchCarts();
      }
    });
    socketService.on('deleteCart', (data) async {
      if (mounted) {
        await _fetchCarts();
      }
    });
    socketService.on('updateCart', (data) async {
      if (mounted) {
        await _fetchCarts();
      }
    });
  }

  Future<void> _fetchCarts() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');

    if (userId != null) {
      final cartManager = Provider.of<CartManager>(context, listen: false);
      final productManager =
          Provider.of<ProductManager>(context, listen: false);
      await cartManager.fetchCartsByUser(userId);
      final carts =
          cartManager.carts.where((cart) => cart.state != 'done').toList();

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
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteCartItem(Cart cart) async {
    final productManager = Provider.of<ProductManager>(context, listen: false);
    final product = await productManager.fetchProduct(cart.productid);

    if (product != null) {
      final updatedProduct =
          product.copyWith(count: product.count + cart.count);
      await productManager.updateProduct(updatedProduct);
      final cartManager = Provider.of<CartManager>(context, listen: false);
      await cartManager.deleteCart(cart.id);
      setState(() {
        _carts.remove(cart);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Giỏ hàng của bạn'),
        automaticallyImplyLeading: false,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _carts.isEmpty
              ? const Center(child: Text('Giỏ hàng của bạn trống'))
              : ListView.builder(
                  itemCount: _carts.length,
                  itemBuilder: (context, index) {
                    final cart = _carts[index];
                    final product = _products[cart.productid];

                    if (product == null) {
                      return const SizedBox.shrink();
                    }

                    final totalPrice = (product.cost -
                            (product.cost * product.discount / 100)) *
                        cart.count;

                    return Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 15),
                      child: Stack(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height / 4,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              image: DecorationImage(
                                image:
                                    MemoryImage(base64Decode(product.picture)),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height / 4,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  Colors.black.withOpacity(0.7),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            top: 10,
                            left: 10,
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 3 / 3,
                              child: _buildMarqueeOrText(
                                  product.name, 24, FontWeight.bold),
                            ),
                          ),
                          Positioned(
                            bottom: 10,
                            left: 10,
                            right: MediaQuery.of(context).size.width / 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildPriceText(product),
                                const SizedBox(height: 5),
                                Text(
                                  'Số lượng: ${cart.count}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Tổng tiền: ${formatCurrency(totalPrice.toInt())}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            bottom: 10,
                            right: 10,
                            child: Column(
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    final product = _products[cart.productid];

                                    if (product != null) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PaymentScreen(
                                            cart: cart,
                                            product: product,
                                            totalPrice: (product.cost -
                                                    (product.cost *
                                                        product.discount /
                                                        100))
                                                .toInt(),
                                          ),
                                        ),
                                      );
                                    } else {
                                      // Hiển thị thông báo lỗi nếu sản phẩm không tìm thấy
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content:
                                                Text('Sản phẩm không hợp lệ')),
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: const Text(
                                    'Thanh toán',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.white),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () async {
                                    final confirm = await showDialog<bool>(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text('Xác nhận'),
                                          content: const Text(
                                              'Bạn có muốn xóa sản phẩm này khỏi giỏ hàng không?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.of(context)
                                                      .pop(false),
                                              child: const Text('Không'),
                                            ),
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.of(context)
                                                      .pop(true),
                                              child: const Text('Có'),
                                            ),
                                          ],
                                        );
                                      },
                                    );

                                    if (confirm == true) {
                                      _deleteCartItem(cart);
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }

  String formatCurrency(int amount) {
    return '${amount.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (match) => '${match[1]}.')}₫';
  }

  Widget _buildPriceText(Product product) {
    final originalPrice = formatCurrency(product.cost);
    final discountedPrice = formatCurrency(
        (product.cost - (product.cost * product.discount / 100)).toInt());

    if (product.discount > 0) {
      return _buildMarqueeOrText(
        'Giá mới: $discountedPrice',
        16,
        FontWeight.normal,
      );
    } else {
      return _buildMarqueeOrText(
        'Giá: $originalPrice',
        16,
        FontWeight.normal,
      );
    }
  }

  Widget _buildMarqueeOrText(
      String text, double fontSize, FontWeight fontWeight,
      {TextDecoration? textDecoration}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth * 2 / 3;
        final textPainter = TextPainter(
          text: TextSpan(
            text: text,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: fontWeight,
              decoration: textDecoration,
            ),
          ),
          maxLines: 1,
          textDirection: TextDirection.ltr,
        )..layout(minWidth: 0, maxWidth: maxWidth);

        if (textPainter.didExceedMaxLines) {
          return SizedBox(
            height: fontSize + 10,
            child: Marquee(
              text: text,
              style: TextStyle(
                color: Colors.white,
                fontSize: fontSize,
                fontWeight: fontWeight,
                decoration: textDecoration,
              ),
              scrollAxis: Axis.horizontal,
              blankSpace: 20.0,
              velocity: 50.0,
              pauseAfterRound: const Duration(seconds: 1),
              startPadding: 10.0,
              accelerationDuration: const Duration(seconds: 1),
              accelerationCurve: Curves.linear,
              decelerationDuration: const Duration(milliseconds: 500),
              decelerationCurve: Curves.easeOut,
            ),
          );
        } else {
          return Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: fontSize,
              fontWeight: fontWeight,
              decoration: textDecoration,
            ),
          );
        }
      },
    );
  }
}
