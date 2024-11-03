import 'dart:convert';
import 'package:flutter/material.dart';
import '../../models/store.dart';
import 'store_product_list.dart';
import 'commentstore_card.dart';

class StoreDetailScreen extends StatelessWidget {
  final Store store;

  const StoreDetailScreen({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(store.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 4,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: MemoryImage(base64Decode(store.picture)),
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
                    Text('Address: ${store.address}',
                        style: const TextStyle(fontSize: 18)),
                    const SizedBox(height: 10),
                    Text('Phone: ${store.phonenumber}',
                        style: const TextStyle(fontSize: 18)),
                    const SizedBox(height: 10),
                    Text('Email: ${store.email}',
                        style: const TextStyle(fontSize: 18)),
                    const SizedBox(height: 10),
                    Text('Open Time: ${store.opentime}',
                        style: const TextStyle(fontSize: 18)),
                    const SizedBox(height: 10),
                    Text('Description: ${store.description}',
                        style: const TextStyle(fontSize: 18)),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('Danh sách sản phẩm',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            ),
            StoreProductListScreen(
                storeId: store.id), // Use StoreProductListScreen
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('Đánh giá cửa hàng',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            ),
            CommentStoreCard(storeId: store.id), // Use CommentStoreCard
          ],
        ),
      ),
    );
  }
}
