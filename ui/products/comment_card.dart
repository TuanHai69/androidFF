import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'comment_manager.dart';

class CommentCard extends StatefulWidget {
  final String productId;

  const CommentCard({super.key, required this.productId});

  @override
  _CommentCardState createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  void initState() {
    super.initState();
    _fetchComments();
  }

  Future<void> _fetchComments() async {
    final commentManager = Provider.of<CommentManager>(context, listen: false);
    await commentManager.fetchCommentsByProduct(widget.productId);
  }

  @override
  Widget build(BuildContext context) {
    final commentManager = Provider.of<CommentManager>(context);

    if (commentManager.commentCount == 0) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            'Sản phẩm chưa có đánh giá nào',
            style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: commentManager.commentCount,
      itemBuilder: (context, index) {
        final comment = commentManager.comments[index];
        final name = comment.name ?? 'Người dùng chưa đặt tên';
        final picture = comment.picture;

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
                          comment.rate,
                          (index) => const Icon(Icons.star,
                              color: Colors.amber, size: 20),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        comment.comment,
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
