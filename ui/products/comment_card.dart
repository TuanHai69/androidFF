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
  final _formKey = GlobalKey<FormState>();
  int _rating = 0;
  String _comment = '';
  bool _canSubmitReview = false;
  bool _hasPurchased = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkConditions();
  }

  Future<void> _checkConditions() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    if (userId == null) {
      return; // Không có userId, không thể tiếp tục
    }

    final commentManager = Provider.of<CommentManager>(context, listen: false);
    await commentManager.fetchCommentsByProduct(widget.productId);

    final userComments = commentManager.comments
        .where((comment) => comment.userid == userId)
        .toList();

    if (userComments.any((comment) =>
        comment.productid == widget.productId &&
        (comment.state == 'show' || comment.state == 'hide'))) {
      setState(() {
        _canSubmitReview = false;
        _hasPurchased = true;
        _isLoading = false;
      });
      return;
    }

    final hasPurchased = userComments.any((comment) =>
        comment.productid == widget.productId && comment.state == '');

    setState(() {
      _canSubmitReview = hasPurchased;
      _hasPurchased = hasPurchased;
      _isLoading = false;
    });
  }

  Future<void> _submitComment() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    if (userId == null) {
      return;
    }
    final commentManager = Provider.of<CommentManager>(context, listen: false);

    // Fetch all comments by the user
    await commentManager.fetchCommentsByUser(userId);
    final userComments = commentManager.comments;

    // Check if there's a comment for the product with state = ""
    final existingComment = userComments.firstWhere(
      (comment) => comment.productid == widget.productId && comment.state == '',
      orElse: () => Comment(
          id: "",
          userid: userId,
          productid: widget.productId,
          rate: _rating,
          comment: _comment,
          state: "show",
          islike: false),
    );

    if (existingComment.id != "") {
      // Update the existing comment
      final updatedComment = existingComment.copyWith(
        rate: _rating,
        comment: _comment,
        state: 'show',
      );
      await commentManager.updateComment(updatedComment);
    } else {
      // No action needed
      return;
    }
    _canSubmitReview = false;
    _fetchComments();
  }

  Future<void> _fetchComments() async {
    final commentManager = Provider.of<CommentManager>(context, listen: false);
    await commentManager.fetchCommentsByProduct(widget.productId);
  }

  @override
  Widget build(BuildContext context) {
    final commentManager = Provider.of<CommentManager>(context);

    // Lọc các comment có state là "show"
    final visibleComments = commentManager.comments.where((comment) {
      return comment.state == "show";
    }).toList();

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        if (!_hasPurchased)
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                'Bạn chưa mua sản phẩm này nên chưa thể đánh giá',
                style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
              ),
            ),
          ),
        if (_canSubmitReview)
          Form(
            key: _formKey,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 2.0),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return IconButton(
                          icon: Icon(
                            index < _rating ? Icons.star : Icons.star_border,
                            color: Colors.amber,
                          ),
                          onPressed: () {
                            setState(() {
                              _rating = index + 1;
                            });
                          },
                        );
                      }),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Đánh giá của bạn',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(
                            color: Colors.black,
                            width: 1.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(
                            color: Colors.blue,
                            width: 2.0,
                          ),
                        ),
                      ),
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Hãy nhập đánh giá của bạn';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _comment = value ?? '';
                      },
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: _submitComment,
                    child: const Text('Gửi đánh giá'),
                  ),
                ],
              ),
            ),
          ),
        visibleComments.isEmpty
            ? const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    'Sản phẩm chưa có đánh giá nào',
                    style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                  ),
                ),
              )
            : SizedBox(
                height:
                    400.0, // Thiết lập chiều cao đủ lớn để chứa 2 hàng comment
                child: ListView.builder(
                  scrollDirection: Axis.horizontal, // Thiết lập lướt ngang
                  itemCount: (visibleComments.length / 2)
                      .ceil(), // Hiển thị số cột tương ứng với số hàng chia đôi
                  itemBuilder: (context, index) {
                    final int startIndex =
                        index * 2; // Chỉ mục bắt đầu của mỗi cột
                    final List<Comment> columnComments = visibleComments
                        .sublist(
                          startIndex,
                          startIndex + 2 <= visibleComments.length
                              ? startIndex + 2
                              : visibleComments.length,
                        )
                        .toList();

                    return Column(
                      children: columnComments.map((comment) {
                        final name = comment.name ?? 'Người dùng chưa đặt tên';
                        final picture = comment.picture;

                        return Container(
                          width: MediaQuery.of(context).size.width *
                              0.8, // Đảm bảo mỗi bình luận chiếm 80% chiều rộng màn hình
                          margin: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          child: Card(
                            margin: const EdgeInsets.symmetric(vertical: 5),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          name,
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
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
                                        Container(
                                          constraints: const BoxConstraints(
                                            maxHeight: 60.0,
                                          ),
                                          child: SingleChildScrollView(
                                            child: Text(
                                              comment.comment,
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
      ],
    );
  }
}
