import 'package:flutter/material.dart';
import '../../models/comment.dart';
import '../../services/comment_service.dart';
import '../../services/account_service.dart';

class CommentManager with ChangeNotifier {
  Comment? _comment;
  List<Comment> _comments = [];

  final CommentService _commentService = CommentService();
  final AccountService _accountService = AccountService();

  Future<Comment?> fetchComment(String id) async {
    _comment = await _commentService.fetchComment(id);
    notifyListeners();
    return _comment;
  }

  Future<void> fetchAllComments() async {
    _comments = await _commentService.fetchAllComments();
    notifyListeners();
  }

  Future<void> fetchCommentsByUser(String userid) async {
    _comments = await _commentService.fetchCommentsByUser(userid);
    notifyListeners();
  }

  Future<void> fetchCommentsByProduct(String productid) async {
    _comments = await _commentService.fetchCommentsByProduct(productid);
    for (var i = 0; i < _comments.length; i++) {
      final account = await _accountService.fetchAccount(_comments[i].userid);
      _comments[i] = _comments[i].copyWith(
        name: account?.name,
        picture: account?.picture,
      );
    }
    notifyListeners();
  }

  int get commentCount {
    return _comments.length;
  }

  Future<String> addComment(Comment comment) async {
    try {
      final newComment = await _commentService.addComment(comment);
      if (newComment != null) {
        _comments.add(newComment);
        notifyListeners();
        return 'Comment added successfully';
      } else {
        return 'Failed to add comment';
      }
    } catch (error) {
      return 'Failed to add comment: $error';
    }
  }

  Comment? get comment {
    return _comment;
  }

  List<Comment> get comments {
    return [..._comments];
  }

  Future<bool> updateComment(Comment comment) async {
    final updated = await _commentService.updateComment(comment);
    if (updated) {
      final index = _comments.indexWhere((c) => c.id == comment.id);
      if (index != -1) {
        _comments[index] = comment;
        notifyListeners();
      }
    }
    return updated;
  }

  Future<bool> deleteComment(String id) async {
    final success = await _commentService.deleteComment(id);
    if (success) {
      _comments.removeWhere((comment) => comment.id == id);
      notifyListeners();
    }
    return success;
  }
}
