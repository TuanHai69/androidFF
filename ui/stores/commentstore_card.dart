import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'commentstore_manager.dart';

class CommentStoreCard extends StatefulWidget {
  final String storeId;

  const CommentStoreCard({super.key, required this.storeId});

  @override
  _CommentStoreCardState createState() => _CommentStoreCardState();
}

class _CommentStoreCardState extends State<CommentStoreCard> {
  @override
  void initState() {
    super.initState();
    _fetchComments();
  }

  Future<void> _fetchComments() async {
    final commentStoreManager =
        Provider.of<CommentStoreManager>(context, listen: false);
    await commentStoreManager.fetchCommentStoresByStore(widget.storeId);
  }

  @override
  Widget build(BuildContext context) {
    final commentStoreManager = Provider.of<CommentStoreManager>(context);

    if (commentStoreManager.commentStoreCount == 0) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            'Cửa hàng chưa có đánh giá nào',
            style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: commentStoreManager.commentStoreCount,
      itemBuilder: (context, index) {
        final commentStore = commentStoreManager.commentStores[index];
        final name = commentStore.name ?? 'Người dùng chưa đặt tên';
        final picture = commentStore.picture;

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundImage: picture != null
                      ? MemoryImage(base64Decode(picture))
                      : null,
                  radius: 30,
                  child: picture == null
                      ? const Icon(Icons.person, size: 30)
                      : null,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: List.generate(
                          commentStore.rate,
                          (index) => const Icon(Icons.star,
                              color: Colors.amber, size: 20),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        commentStore.commentstore,
                        style: const TextStyle(fontSize: 16),
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
}
