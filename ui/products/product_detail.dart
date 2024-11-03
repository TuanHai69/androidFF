import 'dart:convert';
import 'package:flutter/material.dart';
import '../../models/product.dart';
import 'comment_card.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 4,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: MemoryImage(base64Decode(product.picture)),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Material: ${product.material}',
                        style: const TextStyle(fontSize: 18)),
                    const SizedBox(height: 10),
                    Text('Size: ${product.size}',
                        style: const TextStyle(fontSize: 18)),
                    const SizedBox(height: 10),
                    Text('Description: ${product.description}',
                        style: const TextStyle(fontSize: 18)),
                    const SizedBox(height: 10),
                    Text('Warranty: ${product.warranty}',
                        style: const TextStyle(fontSize: 18)),
                    const SizedBox(height: 10),
                    Text('Delivery: ${product.delivery}',
                        style: const TextStyle(fontSize: 18)),
                    const SizedBox(height: 10),
                    Text('Discount: ${product.discount}%',
                        style: const TextStyle(fontSize: 18)),
                    const SizedBox(height: 10),
                    Text('Store ID: ${product.storeid}',
                        style: const TextStyle(fontSize: 18)),
                    const SizedBox(height: 10),
                    Text('State: ${product.state}',
                        style: const TextStyle(fontSize: 18)),
                    const SizedBox(height: 10),
                    Text('Count: ${product.count}',
                        style: const TextStyle(fontSize: 18)),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('Đánh giá sản phẩm',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            ),
            CommentCard(productId: product.id), // Use CommentCard
          ],
        ),
      ),
    );
  }
}
