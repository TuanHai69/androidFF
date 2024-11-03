import 'package:flutter/material.dart';
import '../../models/commentstore.dart';
import '../../services/commentstore_service.dart';
import '../../services/account_service.dart';

class CommentStoreManager with ChangeNotifier {
  CommentStore? _commentStore;
  List<CommentStore> _commentStores = [];

  final CommentStoreService _commentStoreService = CommentStoreService();
  final AccountService _accountService = AccountService();

  Future<CommentStore?> fetchCommentStore(String id) async {
    _commentStore = await _commentStoreService.fetchCommentStore(id);
    notifyListeners();
    return _commentStore;
  }

  Future<void> fetchAllCommentStores() async {
    _commentStores = await _commentStoreService.fetchAllCommentStores();
    notifyListeners();
  }

  Future<void> fetchCommentStoresByUser(String userid) async {
    _commentStores =
        await _commentStoreService.fetchCommentStoresByUser(userid);
    notifyListeners();
  }

  Future<void> fetchCommentStoresByStore(String storeid) async {
    _commentStores =
        await _commentStoreService.fetchCommentStoresByStore(storeid);
    for (var i = 0; i < _commentStores.length; i++) {
      final account =
          await _accountService.fetchAccount(_commentStores[i].userid);
      _commentStores[i] = _commentStores[i].copyWith(
        name: account?.name,
        picture: account?.picture,
      );
    }
    notifyListeners();
  }

  int get commentStoreCount {
    return _commentStores.length;
  }

  Future<String> addCommentStore(CommentStore commentStore) async {
    try {
      final newCommentStore =
          await _commentStoreService.addCommentStore(commentStore);
      if (newCommentStore != null) {
        _commentStores.add(newCommentStore);
        notifyListeners();
        return 'Comment added successfully';
      } else {
        return 'Failed to add comment';
      }
    } catch (error) {
      return 'Failed to add comment: $error';
    }
  }

  CommentStore? get commentStore {
    return _commentStore;
  }

  List<CommentStore> get commentStores {
    return [..._commentStores];
  }

  Future<bool> updateCommentStore(CommentStore commentStore) async {
    final updated = await _commentStoreService.updateCommentStore(commentStore);
    if (updated) {
      final index = _commentStores.indexWhere((c) => c.id == commentStore.id);
      if (index != -1) {
        _commentStores[index] = commentStore;
        notifyListeners();
      }
    }
    return updated;
  }

  Future<bool> deleteCommentStore(String id) async {
    final success = await _commentStoreService.deleteCommentStore(id);
    if (success) {
      _commentStores.removeWhere((commentStore) => commentStore.id == id);
      notifyListeners();
    }
    return success;
  }
}
