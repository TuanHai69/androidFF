import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/commentstore.dart';

class CommentStoreService {
  static const String baseUrl = 'http://192.168.56.1:3000/api/commentstore';

  Future<CommentStore?> fetchCommentStore(String id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$id'));

      if (response.statusCode == 200) {
        final commentStoreMap =
            json.decode(response.body) as Map<String, dynamic>;
        return CommentStore.fromJson(commentStoreMap);
      } else {
        print('Failed to load comment store: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching comment store: $error');
    }
    return null;
  }

  Future<List<CommentStore>> fetchAllCommentStores() async {
    List<CommentStore> commentStores = [];
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        final commentStoreList = json.decode(response.body) as List<dynamic>;
        commentStores = commentStoreList
            .map((commentStore) => CommentStore.fromJson(commentStore))
            .toList();
      } else {
        print('Failed to load comment stores: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching comment stores: $error');
    }
    return commentStores;
  }

  Future<List<CommentStore>> fetchCommentStoresByUser(String userid) async {
    List<CommentStore> commentStores = [];
    try {
      final response = await http.get(Uri.parse('$baseUrl/user/$userid'));
      if (response.statusCode == 200) {
        final commentStoreList = json.decode(response.body) as List<dynamic>;
        commentStores = commentStoreList
            .map((commentStore) => CommentStore.fromJson(commentStore))
            .toList();
      } else {
        print('Failed to load comment stores by user: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching comment stores by user: $error');
    }
    return commentStores;
  }

  Future<List<CommentStore>> fetchCommentStoresByStore(String storeid) async {
    List<CommentStore> commentStores = [];
    try {
      final response = await http.get(Uri.parse('$baseUrl/store/$storeid'));
      if (response.statusCode == 200) {
        final commentStoreList = json.decode(response.body) as List<dynamic>;
        commentStores = commentStoreList
            .map((commentStore) => CommentStore.fromJson(commentStore))
            .toList();
      } else {
        print('Failed to load comment stores by store: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching comment stores by store: $error');
    }
    return commentStores;
  }

  Future<CommentStore?> addCommentStore(CommentStore commentStore) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(commentStore.toJson()),
      );
      if (response.statusCode == 200) {
        final newCommentStore =
            json.decode(response.body) as Map<String, dynamic>;
        return CommentStore.fromJson(newCommentStore);
      } else {
        print('Failed to add comment store: ${response.statusCode}');
      }
    } catch (error) {
      print('Error adding comment store: $error');
    }
    return null;
  }

  Future<bool> updateCommentStore(CommentStore commentStore) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/${commentStore.id}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(commentStore.toJson()),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to update comment store: ${response.statusCode}');
      }
    } catch (error) {
      print('Error updating comment store: $error');
    }
    return false;
  }

  Future<bool> deleteCommentStore(String id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));
      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to delete comment store: ${response.statusCode}');
      }
    } catch (error) {
      print('Error deleting comment store: $error');
    }
    return false;
  }
}
