import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/comment.dart';
import 'comment_manager.dart';

class CommentCard extends StatefulWidget {
  final String productId;

  const CommentCard({super.key, required this.productId});

  @override
  _CommentCardState createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  bool canComment = false;
  bool hasCommented = false;

  @override
  void initState() {
    super.initState();
    _checkIfUserCanComment();
    _fetchComments();
  }

  Future<void> _fetchComments() async {
    final commentManager = Provider.of<CommentManager>(context, listen: false);
    await commentManager.fetchCommentsByProduct(widget.productId);
  }

  Future<void> _checkIfUserCanComment() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId');
      if (userId == null) return;
      final commentManager =
          Provider.of<CommentManager>(context, listen: false);
      await commentManager.fetchCommentsByUser(userId);
      final userComments = commentManager.comments;
      if (userComments.isEmpty) {
        setState(() {
          canComment = false;
        });
      } else {
        final hasCommentedProduct = userComments.any((comment) =>
            comment.productid == widget.productId && comment.state == '');
        final hasCommented = userComments.any((comment) =>
            comment.productid == widget.productId &&
            (comment.state == 'show' || comment.state == 'hide'));
        setState(() {
          canComment = hasCommentedProduct || hasCommented;
          this.hasCommented = hasCommented;
        });
      }
    } catch (error) {
      print('Error checking purchase status: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final commentManager = Provider.of<CommentManager>(context);

    return Column(
      children: [
        if (canComment && !hasCommented)
          _buildCommentForm()
        else
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                'Bạn chưa mua sản phẩm này hoặc đã bình luận rồi, không thể bình luận thêm.',
                style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
              ),
            ),
          ),
        const SizedBox(height: 20),
        if (commentManager.commentCount == 0)
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                'Sản phẩm chưa có đánh giá nào',
                style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: commentManager.commentCount,
            itemBuilder: (context, index) {
              final comment = commentManager.comments[index];
              final name = comment.name ?? 'Người dùng chưa đặt tên';
              final picture = comment.picture;

              return Card(
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
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
          ),
      ],
    );
  }

  Widget _buildCommentForm() {
    final _commentController = TextEditingController();
    final _rateController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Viết đánh giá của bạn',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _rateController,
            decoration: const InputDecoration(
              labelText: 'Đánh giá (1-5)',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _commentController,
            decoration: const InputDecoration(
              labelText: 'Bình luận của bạn',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              final userId = prefs.getString('userId');

              if (userId == null) {
                _showMessage('Không có userId, không thể tiếp tục');
                return;
              }

              final commentManager =
                  Provider.of<CommentManager>(context, listen: false);
              final newComment = Comment(
                id: DateTime.now().toString(),
                userid: userId,
                productid: widget.productId,
                rate: int.tryParse(_rateController.text) ?? 0,
                comment: _commentController.text,
                state: '',
                islike: false,
              );

              final response = await commentManager.addComment(newComment);
              _showMessage(response);
              _fetchComments(); // Refresh the comments list
            },
            child: const Text('Gửi'),
          ),
        ],
      ),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
