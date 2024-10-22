import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/type.dart';

class TypeService {
  static const String baseUrl = 'http://192.168.56.1:3000/api/type';

  Future<Type?> fetchType(String id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$id'));

      if (response.statusCode == 200) {
        final typeMap = json.decode(response.body) as Map<String, dynamic>;
        return Type.fromJson(typeMap);
      } else {
        print('Failed to load type: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching type: $error');
    }
    return null;
  }

  Future<List<Type>> fetchAllTypes() async {
    List<Type> types = [];
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        final typeList = json.decode(response.body) as List<dynamic>;
        types = typeList.map((type) => Type.fromJson(type)).toList();
      } else {
        print('Failed to load types: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching types: $error');
    }
    return types;
  }

  Future<List<Type>> fetchTypesByUser(String userid) async {
    List<Type> types = [];
    try {
      final response = await http.get(Uri.parse('$baseUrl/user/$userid'));
      if (response.statusCode == 200) {
        final typeList = json.decode(response.body) as List<dynamic>;
        types = typeList.map((type) => Type.fromJson(type)).toList();
      } else {
        print('Failed to load types by user: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching types by user: $error');
    }
    return types;
  }

  Future<Type?> addType(Type type) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(type.toJson()),
      );
      if (response.statusCode == 200) {
        final newType = json.decode(response.body) as Map<String, dynamic>;
        return Type.fromJson(newType);
      } else {
        print('Failed to add type: ${response.statusCode}');
      }
    } catch (error) {
      print('Error adding type: $error');
    }
    return null;
  }

  Future<bool> updateType(Type type) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/${type.id}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(type.toJson()),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to update type: ${response.statusCode}');
      }
    } catch (error) {
      print('Error updating type: $error');
    }
    return false;
  }

  Future<bool> deleteType(String id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));
      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to delete type: ${response.statusCode}');
      }
    } catch (error) {
      print('Error deleting type: $error');
    }
    return false;
  }
}
