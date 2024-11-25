import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/commentstore.dart';
import '../../models/store.dart';
import 'store_product_list.dart';
import 'commentstore_card.dart';
import 'commentstore_manager.dart';

class StoreDetailScreen extends StatefulWidget {
  final Store store;

  const StoreDetailScreen({super.key, required this.store});

  @override
  State<StoreDetailScreen> createState() => _StoreDetailScreenState();
}

class _StoreDetailScreenState extends State<StoreDetailScreen> {
  double _averageRating = 0.0;
  bool _isFetching = false;
  bool _isLiked = false;
  String? _userId;

  @override
  void initState() {
    super.initState();
    _fetchComments();
    _checkLikedStatus();
  }

  Future<void> _fetchComments() async {
    if (_isFetching) return;
    _isFetching = true;
    final commentStoreManager =
        Provider.of<CommentStoreManager>(context, listen: false);
    await commentStoreManager.fetchCommentStoresByStore(widget.store.id);
    final comments = commentStoreManager.commentStores;
    if (comments.isNotEmpty) {
      final totalRating = comments.map((c) => c.rate).reduce((a, b) => a + b);
      setState(() {
        _averageRating = totalRating / comments.length;
      });
    } else {
      setState(() {
        _averageRating = 0.0;
      });
    }
    _isFetching = false;
  }

  Future<void> _checkLikedStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    if (userId == null) {
      return; // Nếu không có userId trong prefs
    }
    setState(() {
      _userId = userId;
    });
    final commentStoreManager =
        Provider.of<CommentStoreManager>(context, listen: false);
    await commentStoreManager.fetchCommentStoresByUser(userId);
    final comments = commentStoreManager.commentStores.where((comment) {
      return comment.storeid == widget.store.id;
    }).toList();

    if (comments.isNotEmpty) {
      final currentComment = comments.first;
      setState(() {
        _isLiked = currentComment.isliked;
      });
    }
  }

  Future<void> _toggleFollow() async {
    if (_userId == null) {
      return; // Không có userId, không thể tiếp tục
    }
    final commentStoreManager =
        Provider.of<CommentStoreManager>(context, listen: false);

    await commentStoreManager.fetchCommentStoresByUser(_userId!);
    final comments = commentStoreManager.commentStores.where((comment) {
      return comment.storeid == widget.store.id;
    }).toList();

    if (_isLiked) {
      if (comments.isNotEmpty) {
        final updatedComment = await commentStoreManager.updateCommentStore(
          comments.first.copyWith(isliked: false),
        );
        if (updatedComment) {
          setState(() {
            _isLiked = false;
          });
        }
      }
    } else {
      // Nếu chưa theo dõi, thêm vào danh sách theo dõi
      if (comments.isEmpty) {
        // Nếu không có commentstore nào, thêm mới
        await commentStoreManager.addCommentStore(
          CommentStore(
            id: _userId!,
            userid: _userId!,
            storeid: widget.store.id,
            rate: 0,
            commentstore: '',
            state: 'Nopay',
            isliked: true,
          ),
        );
      } else {
        // Nếu có commentstore, cập nhật
        await commentStoreManager.updateCommentStore(
          comments.first.copyWith(isliked: true),
        );
      }
      setState(() {
        _isLiked = true;
      });
    }
    await commentStoreManager.fetchCommentStoresByStore(widget.store.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.store.name),
        actions: [
          TextButton(
            onPressed: _toggleFollow,
            style: TextButton.styleFrom(
              backgroundColor: _isLiked ? Colors.red : Colors.blue,
            ),
            child: Text(
              _isLiked ? 'Đã theo dõi' : 'Theo dõi',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 4,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: MemoryImage(base64Decode(widget.store.picture)),
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
                    Row(
                      children: [
                        const Text(
                          'Đánh giá:',
                          style: TextStyle(fontSize: 18),
                        ),
                        const SizedBox(width: 5),
                        ...List.generate(5, (index) {
                          if (index < _averageRating.floor()) {
                            return const Icon(Icons.star,
                                color: Colors.amber, size: 20);
                          } else if (index < _averageRating) {
                            return const Icon(Icons.star_half,
                                color: Colors.amber, size: 20);
                          } else {
                            return const Icon(Icons.star_border,
                                color: Colors.amber, size: 20);
                          }
                        }),
                      ],
                    ),
                    Text('Địa chỉ: ${widget.store.address}',
                        style: const TextStyle(fontSize: 18)),
                    const SizedBox(height: 10),
                    Text('Số điện thoại: ${widget.store.phonenumber}',
                        style: const TextStyle(fontSize: 18)),
                    const SizedBox(height: 10),
                    Text('Email: ${widget.store.email}',
                        style: const TextStyle(fontSize: 18)),
                    const SizedBox(height: 10),
                    Text('Thời gian mở cửa: ${widget.store.opentime}',
                        style: const TextStyle(fontSize: 18)),
                    const SizedBox(height: 10),
                    Text('Mô tả cửa hàng: ${widget.store.description}',
                        style: const TextStyle(fontSize: 18)),
                  ],
                ),
              ),
            ),
            // Use StoreProductListScreen
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('Đánh giá cửa hàng',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            ),
            CommentStoreCard(storeId: widget.store.id), // Use CommentStoreCard
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('Danh sách sản phẩm',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            ),
            StoreProductListScreen(storeId: widget.store.id),
          ],
        ),
      ),
    );
  }
}
