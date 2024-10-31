import 'package:flutter/material.dart';
import '../../models/store.dart';
import '../../services/store_service.dart';

class StoreManager with ChangeNotifier {
  Store? _store;
  List<Store> _stores = [];

  final StoreService _storeService = StoreService();

  Future<Store?> fetchStore(String id) async {
    print(id);
    _store = await _storeService.fetchStore(id);
    print(_store);
    notifyListeners();
    return _store;
  }

  Future<void> fetchAllStores() async {
    _stores = await _storeService.fetchAllStores();
    notifyListeners();
  }

  int get storeCount {
    return _stores.length;
  }

  Future<String> addStore(Map<String, dynamic> storeData) async {
    try {
      final message = await _storeService.addStore(storeData);
      notifyListeners();
      return message;
    } catch (error) {
      return 'Thêm cửa hàng thất bại: $error';
    }
  }

  Store? get store {
    return _store;
  }

  List<Store> get stores {
    return [..._stores];
  }

  Future<bool> updateStore(Store store) async {
    final updated = await _storeService.updateStore(store);
    if (updated) {
      final index = _stores.indexWhere((s) => s.id == store.id);
      if (index != -1) {
        _stores[index] = store;
        notifyListeners();
      }
    }
    return updated;
  }

  Future<bool> deleteStore(String id) async {
    final success = await _storeService.deleteStore(id);
    if (success) {
      _stores.removeWhere((store) => store.id == id);
      notifyListeners();
    }
    return success;
  }
}
