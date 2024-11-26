import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:marquee/marquee.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/cart.dart';
import '../carts/cart_manager.dart';
import 'product_manager.dart';
import '../../models/product.dart';
import 'product_detail.dart';
import 'comment_manager.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final Map<String, double> _averageRatings = {};

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    final productManager = Provider.of<ProductManager>(context, listen: false);
    await productManager.fetchAllProducts();
    _fetchCommentsForProducts();
  }

  Future<void> _fetchCommentsForProducts() async {
    final commentManager = Provider.of<CommentManager>(context, listen: false);
    final productManager = Provider.of<ProductManager>(context, listen: false);

    for (var product in productManager.products) {
      await commentManager.fetchCommentsByProduct(product.id);
      final comments = commentManager.comments
          .where((comment) => comment.rate != 0 && comment.rate != '')
          .toList();

      if (comments.isNotEmpty) {
        final averageRating =
            comments.map((c) => c.rate).reduce((a, b) => a + b) /
                comments.length;
        if (mounted) {
          setState(() {
            _averageRatings[product.id] = averageRating;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _averageRatings[product.id] = 0.0;
          });
        }
      }
    }
  }

  Future<void> _addToCart(Product product) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');

    if (userId == null) {
      _showMessage('Không có userId, không thể tiếp tục');
      return;
    }

    final productManager = Provider.of<ProductManager>(context, listen: false);
    final fetchedProduct = await productManager.fetchProduct(product.id);

    if (fetchedProduct == null) {
      _showMessage('Sản phẩm không hợp lệ, vui lòng thử lại sau ít phút');
      return;
    }

    if (fetchedProduct.count <= 0) {
      _showMessage('Sản phẩm ${fetchedProduct.name} không còn hàng');
      return;
    }

    final cartManager = Provider.of<CartManager>(context, listen: false);
    await cartManager.fetchCartsByUserIdAndStoreId(userId, product.storeid);
    final carts = cartManager.carts;

    final existingCart = carts.firstWhere(
      (cart) => cart.productid == product.id,
      orElse: () => Cart(
        id: "", // Tạo id tạm thời, có thể thay đổi theo yêu cầu của bạn
        userid: userId,
        productid: product.id,
        count: 1,
        note: '',
        discount: 0,
        storeid: product.storeid,
        state: '1',
      ),
    );

    if (existingCart.id == "") {
      await cartManager.addCart(
        Cart(
          id: "", // Tạo id tạm thời, có thể thay đổi theo yêu cầu của bạn
          userid: userId,
          productid: product.id,
          count: 1,
          note: '',
          discount: 0,
          storeid: product.storeid,
          state: '1',
        ),
      );
    } else {
      await cartManager.updateCart(
        existingCart.copyWith(count: existingCart.count + 1),
      );
    }
    productManager.updateProduct(
      fetchedProduct.copyWith(count: fetchedProduct.count - 1),
    );
    _showMessage('Đã thêm sản phẩm vào giỏ hàng');
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productManager = Provider.of<ProductManager>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách sản phẩm'),
      ),
      body: productManager.productCount == 0
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: productManager.productCount,
              itemBuilder: (context, index) {
                final product = productManager.products[index];
                final averageRating = _averageRatings[product.id] ?? 0.0;

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProductDetailScreen(product: product),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    child: Stack(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height / 4,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            image: DecorationImage(
                              image: MemoryImage(base64Decode(product.picture)),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height / 4,
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
                          right: 10,
                          child: Row(
                            children: List.generate(5, (index) {
                              if (index < averageRating.floor()) {
                                return const Icon(Icons.star,
                                    color: Colors.amber, size: 20);
                              } else if (index < averageRating) {
                                return const Icon(Icons.star_half,
                                    color: Colors.amber, size: 20);
                              } else {
                                return const Icon(Icons.star_border,
                                    color: Colors.amber, size: 20);
                              }
                            }),
                          ),
                        ),
                        Positioned(
                          top: 10,
                          left: 10,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Builder(
                              builder: (BuildContext context) {
                                final currentDate = DateTime.now();
                                final productDate =
                                    DateTime.parse(product.day!);
                                final endDate =
                                    productDate.add(const Duration(days: 7));
                                if (currentDate.isAfter(productDate) &&
                                    currentDate.isBefore(endDate)) {
                                  return const Text(
                                    'NEW',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                } else {
                                  return const SizedBox.shrink();
                                }
                              },
                            ),
                          ),
                        ),
                        if (product.discount > 0)
                          Positioned(
                            top: 10,
                            left: product.day != null &&
                                    DateTime.now().isBefore(
                                        DateTime.parse(product.day!)
                                            .add(const Duration(days: 7)))
                                ? 70
                                : 10,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                '${product.discount}% OFF',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        Positioned(
                          bottom: 10,
                          left: 10,
                          right: 10,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildMarqueeOrText(
                                  product.name, 24, FontWeight.bold),
                              const SizedBox(height: 5),
                              _buildMarqueeOrText(
                                  product.description, 16, FontWeight.normal),
                              const SizedBox(height: 5),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: _buildPriceText(product),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: _buildMarqueeOrText(
                                      'Số lượng: ${product.count}',
                                      16,
                                      FontWeight.normal,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.shopping_cart,
                                      color: Colors.blue,
                                    ),
                                    onPressed: () => _addToCart(product),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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
        'Giá giảm: $discountedPrice',
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
        )..layout(minWidth: 0, maxWidth: constraints.maxWidth);

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
