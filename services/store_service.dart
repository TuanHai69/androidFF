import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/store.dart';

class StoreService {
  static const String baseUrl = 'http://192.168.56.1:3000/api/store';

  Future<Store?> fetchStore(String id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$id'));

      if (response.statusCode == 200) {
        final storeMap = json.decode(response.body) as Map<String, dynamic>;
        return Store.fromJson(storeMap);
      } else {
        print('Failed to load store: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching store: $error');
    }
    return null;
  }

  Future<List<Store>> fetchAllStores() async {
    List<Store> stores = [];
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        final storeList = json.decode(response.body) as List<dynamic>;
        stores = storeList.map((store) => Store.fromJson(store)).toList();
      } else {
        print('Failed to load stores: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching stores: $error');
    }
    return stores;
  }

  Future<List<Store>> fetchStoresByUser(String userid) async {
    List<Store> stores = [];
    try {
      final response = await http.get(Uri.parse('$baseUrl/user/$userid'));
      if (response.statusCode == 200) {
        final storeList = json.decode(response.body) as List<dynamic>;
        stores = storeList.map((store) => Store.fromJson(store)).toList();
      } else {
        print('Failed to load stores by user: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching stores by user: $error');
    }
    return stores;
  }

  Future<List<Store>> fetchStoresByBranch(String branchid) async {
    List<Store> stores = [];
    try {
      final response = await http.get(Uri.parse('$baseUrl/branch/$branchid'));
      if (response.statusCode == 200) {
        final storeList = json.decode(response.body) as List<dynamic>;
        stores = storeList.map((store) => Store.fromJson(store)).toList();
      } else {
        print('Failed to load stores by branch: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching stores by branch: $error');
    }
    return stores;
  }

  Future<List<Store>> fetchStoresByState(String state) async {
    List<Store> stores = [];
    try {
      final response = await http.get(Uri.parse('$baseUrl/state/$state'));
      if (response.statusCode == 200) {
        final storeList = json.decode(response.body) as List<dynamic>;
        stores = storeList.map((store) => Store.fromJson(store)).toList();
      } else {
        print('Failed to load stores by state: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching stores by state: $error');
    }
    return stores;
  }

  Future<Store?> addStore(Store store) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(store.toJson()),
      );
      if (response.statusCode == 200) {
        final newStore = json.decode(response.body) as Map<String, dynamic>;
        return Store.fromJson(newStore);
      } else {
        print('Failed to add store: ${response.statusCode}');
      }
    } catch (error) {
      print('Error adding store: $error');
    }
    return null;
  }

  Future<bool> updateStore(Store store) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/${store.id}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(store.toJson()),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to update store: ${response.statusCode}');
      }
    } catch (error) {
      print('Error updating store: $error');
    }
    return false;
  }

  Future<bool> deleteStore(String id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));
      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to delete store: ${response.statusCode}');
      }
    } catch (error) {
      print('Error deleting store: $error');
    }
    return false;
  }
}
