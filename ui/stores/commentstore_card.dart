import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/commentstore.dart';
import 'commentstore_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../order/order_manager.dart';

class CommentStoreCard extends StatefulWidget {
  final String storeId;

  const CommentStoreCard({super.key, required this.storeId});

  @override
  _CommentStoreCardState createState() => _CommentStoreCardState();
}

class _CommentStoreCardState extends State<CommentStoreCard> {
  final _formKey = GlobalKey<FormState>();
  int _rating = 0;
  String _comment = '';
  CommentStore? _existingComment;
  bool _canSubmitReview = false;
  bool _hasPurchased = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkConditions();
    // _fetchUserComments();
    // _fetchComments();
  }

  Future<void> _checkConditions() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    if (userId == null) {
      return; // Không có userId, không thể tiếp tục
    }

    final commentStoreManager =
        Provider.of<CommentStoreManager>(context, listen: false);
    await commentStoreManager.fetchCommentStoresByStore(widget.storeId);

    final existingComments = commentStoreManager.commentStores.where((comment) {
      return comment.userid == userId && comment.state != 'Nopay';
    }).toList();

    if (existingComments.isNotEmpty) {
      setState(() {
        _canSubmitReview = false;
        _hasPurchased = true;
        _isLoading = false;
      });
      return;
    }

    final orderManager = Provider.of<OrderManager>(context, listen: false);
    await orderManager.fetchOrdersByUserIdAndStoreId(userId, widget.storeId);

    final orders = orderManager.orders;
    if (orders.isEmpty) {
      setState(() {
        _canSubmitReview = false;
        _hasPurchased = false;
        _isLoading = false;
      });
      return;
    }
    final hasReceivedOrder = orders.any((order) => order.state == 'Received');
    setState(() {
      _canSubmitReview = hasReceivedOrder;
      _hasPurchased = true;
      _isLoading = false;
    });
  }

  Future<void> _fetchComments() async {
    final commentStoreManager =
        Provider.of<CommentStoreManager>(context, listen: false);
    await commentStoreManager.fetchCommentStoresByStore(widget.storeId);
  }

  // Future<void> _fetchUserComments() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final userId = prefs.getString('userId');
  //   if (userId == null) {
  //     return; // Không có userId, không thể tiếp tục
  //   }
  //   final commentStoreManager =
  //       Provider.of<CommentStoreManager>(context, listen: false);

  //   await commentStoreManager.fetchCommentStoresByUser(userId);
  //   final userComments = commentStoreManager.commentStores;

  //   setState(() {
  //     _existingComment = userComments.firstWhere(
  //       (comment) => comment.storeid == widget.storeId,
  //       orElse: () => CommentStore(
  //         id: '',
  //         userid: userId,
  //         storeid: widget.storeId,
  //         rate: 0,
  //         commentstore: '',
  //         state: 'Nopay',
  //         isliked: false,
  //       ),
  //     );
  //     if (_existingComment != null) {
  //       _rating = _existingComment!.rate;
  //       _comment = _existingComment!.commentstore;
  //     }
  //   });
  //   await commentStoreManager.fetchCommentStoresByStore(widget.storeId);
  // }

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
    final commentStoreManager =
        Provider.of<CommentStoreManager>(context, listen: false);

    if (_existingComment == null) {
      // Thêm mới commentstore
      await commentStoreManager.addCommentStore(CommentStore(
        id: '',
        userid: userId,
        storeid: widget.storeId,
        rate: _rating,
        commentstore: _comment,
        state: 'show',
        isliked: false,
      ));
    } else {
      // Cập nhật commentstore hiện có
      await commentStoreManager.updateCommentStore(_existingComment!.copyWith(
        rate: _rating,
        commentstore: _comment,
        state: 'show',
      ));
    }
    _fetchComments(); // Cập nhật danh sách commentstore sau khi thêm hoặc cập nhật
  }

  @override
  Widget build(BuildContext context) {
    final commentStoreManager = Provider.of<CommentStoreManager>(context);
    // Lọc các commentstore có state là "show"
    final visibleComments = commentStoreManager.commentStores.where((comment) {
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
                'Bạn chưa mua đồ nội thất từ cửa hàng này nên chưa thể đánh giá',
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
                      initialValue: _comment,
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
                      onSaved: (value) {
                        _comment = value ?? '';
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Hãy nhập đánh giá của bạn';
                        }
                        return null;
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
                    'Cửa hàng chưa có đánh giá nào',
                    style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                  ),
                ),
              )
            : SizedBox(
                height:
                    400.0, // Thiết lập chiều cao đủ lớn để chứa 2 hàng commentstore
                child: ListView.builder(
                  scrollDirection: Axis.horizontal, // Thiết lập lướt ngang
                  itemCount: (visibleComments.length / 2)
                      .ceil(), // Hiển thị số cột tương ứng với số hàng chia đôi
                  itemBuilder: (context, index) {
                    final int startIndex =
                        index * 2; // Chỉ mục bắt đầu của mỗi cột
                    final List<CommentStore> columnComments =
                        visibleComments.sublist(
                      startIndex,
                      startIndex + 2 <= visibleComments.length
                          ? startIndex + 2
                          : visibleComments.length,
                    );

                    return Column(
                      children: columnComments.map((commentStore) {
                        final name =
                            commentStore.name ?? 'Người dùng chưa đặt tên';
                        final picture = commentStore.picture;

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
                                            commentStore.rate,
                                            (index) => const Icon(Icons.star,
                                                color: Colors.amber, size: 20),
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Container(
                                          constraints: const BoxConstraints(
                                            maxHeight:
                                                60.0, // Giới hạn chiều cao của Container để chứa tối đa 3 dòng văn bản
                                          ),
                                          child: SingleChildScrollView(
                                            child: Text(
                                              commentStore.commentstore,
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
