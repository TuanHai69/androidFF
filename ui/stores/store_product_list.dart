import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:marquee/marquee.dart';
import '../products/comment_manager.dart';
import '../products/product_manager.dart';
import '../../models/product.dart';
import '../products/product_detail.dart';

class StoreProductListScreen extends StatefulWidget {
  final String storeId;

  const StoreProductListScreen({super.key, required this.storeId});

  @override
  _StoreProductListScreenState createState() => _StoreProductListScreenState();
}

class _StoreProductListScreenState extends State<StoreProductListScreen> {
  final Map<String, double> _averageRatings = {};

  @override
  void initState() {
    super.initState();
    _fetchProductsByStore();
  }

  Future<void> _fetchProductsByStore() async {
    final productManager = Provider.of<ProductManager>(context, listen: false);
    await productManager.fetchProductsByStore(widget.storeId);
    _fetchCommentsForProducts();
  }

  Future<void> _fetchCommentsForProducts() async {
    final commentManager = Provider.of<CommentManager>(context, listen: false);
    final productManager = Provider.of<ProductManager>(context, listen: false);

    for (var product in productManager.products) {
      await commentManager.fetchCommentsByProduct(product.id);
      final comments = commentManager.comments;

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

  @override
  Widget build(BuildContext context) {
    final productManager = Provider.of<ProductManager>(context);

    return productManager.productCount == 0
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
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
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
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
                      if (product.discount > 0)
                        Positioned(
                          top: 10,
                          left: 10,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
    String text,
    double fontSize,
    FontWeight fontWeight, {
    TextDecoration? textDecoration,
  }) {
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
