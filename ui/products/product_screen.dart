import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:marquee/marquee.dart';
import 'product_manager.dart';
import '../../models/product.dart';
import 'product_detail.dart'; // Import ProductDetailScreen

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    final productManager = Provider.of<ProductManager>(context, listen: false);
    await productManager.fetchAllProducts();
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
