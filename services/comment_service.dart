import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/comment.dart';

class CommentService {
  static const String baseUrl = 'http://192.168.56.1:3000/api/comment';

  Future<Comment?> fetchComment(String id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$id'));

      if (response.statusCode == 200) {
        final commentMap = json.decode(response.body) as Map<String, dynamic>;
        return Comment.fromJson(commentMap);
      } else {
        print('Failed to load comment: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching comment: $error');
    }
    return null;
  }

  Future<List<Comment>> fetchAllComments() async {
    List<Comment> comments = [];
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        final commentList = json.decode(response.body) as List<dynamic>;
        comments =
            commentList.map((comment) => Comment.fromJson(comment)).toList();
      } else {
        print('Failed to load comments: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching comments: $error');
    }
    return comments;
  }

  Future<List<Comment>> fetchCommentsByUser(String userid) async {
    List<Comment> comments = [];
    try {
      final response = await http.get(Uri.parse('$baseUrl/user/$userid'));
      if (response.statusCode == 200) {
        final commentList = json.decode(response.body) as List<dynamic>;
        comments =
            commentList.map((comment) => Comment.fromJson(comment)).toList();
      } else {
        print('Failed to load comments by user: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching comments by user: $error');
    }
    return comments;
  }

  Future<List<Comment>> fetchCommentsByProduct(String productid) async {
    List<Comment> comments = [];
    try {
      final response = await http.get(Uri.parse('$baseUrl/product/$productid'));
      if (response.statusCode == 200) {
        final commentList = json.decode(response.body) as List<dynamic>;
        comments =
            commentList.map((comment) => Comment.fromJson(comment)).toList();
      } else {
        print('Failed to load comments by product: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching comments by product: $error');
    }
    return comments;
  }

  Future<Comment?> addComment(Comment comment) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(comment.toJson()),
      );
      if (response.statusCode == 200) {
        final newComment = json.decode(response.body) as Map<String, dynamic>;
        return Comment.fromJson(newComment);
      } else {
        print('Failed to add comment: ${response.statusCode}');
      }
    } catch (error) {
      print('Error adding comment: $error');
    }
    return null;
  }

  Future<bool> updateComment(Comment comment) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/${comment.id}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(comment.toJson()),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to update comment: ${response.statusCode}');
      }
    } catch (error) {
      print('Error updating comment: $error');
    }
    return false;
  }

  Future<bool> deleteComment(String id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));
      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to delete comment: ${response.statusCode}');
      }
    } catch (error) {
      print('Error deleting comment: $error');
    }
    return false;
  }

  Future<List<Comment>> isLiked(String userid, String productid) async {
    List<Comment> comments = [];
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/liked/$userid/$productid'));
      if (response.statusCode == 200) {
        final commentList = json.decode(response.body) as List<dynamic>;
        comments =
            commentList.map((comment) => Comment.fromJson(comment)).toList();
      } else {
        print('Failed to check if comment is liked: ${response.statusCode}');
      }
    } catch (error) {
      print('Error checking if comment is liked: $error');
    }
    return comments;
  }
}
