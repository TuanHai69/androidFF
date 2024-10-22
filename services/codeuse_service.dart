import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/codeuse.dart';

class CodeUseService {
  static const String baseUrl = 'http://192.168.56.1:3000/api/codeuse';

  Future<CodeUse?> fetchCodeUse(String id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$id'));

      if (response.statusCode == 200) {
        final codeUseMap = json.decode(response.body) as Map<String, dynamic>;
        return CodeUse.fromJson(codeUseMap);
      } else {
        print('Failed to load code use: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching code use: $error');
    }
    return null;
  }

  Future<List<CodeUse>> fetchAllCodeUses() async {
    List<CodeUse> codeUses = [];
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        final codeUseList = json.decode(response.body) as List<dynamic>;
        codeUses =
            codeUseList.map((codeUse) => CodeUse.fromJson(codeUse)).toList();
      } else {
        print('Failed to load code uses: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching code uses: $error');
    }
    return codeUses;
  }

  Future<List<CodeUse>> fetchCodeUsesByUser(String userid) async {
    List<CodeUse> codeUses = [];
    try {
      final response = await http.get(Uri.parse('$baseUrl/user/$userid'));
      if (response.statusCode == 200) {
        final codeUseList = json.decode(response.body) as List<dynamic>;
        codeUses =
            codeUseList.map((codeUse) => CodeUse.fromJson(codeUse)).toList();
      } else {
        print('Failed to load code uses by user: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching code uses by user: $error');
    }
    return codeUses;
  }

  Future<List<CodeUse>> fetchCodeUsesByCode(String codeid) async {
    List<CodeUse> codeUses = [];
    try {
      final response = await http.get(Uri.parse('$baseUrl/code/$codeid'));
      if (response.statusCode == 200) {
        final codeUseList = json.decode(response.body) as List<dynamic>;
        codeUses =
            codeUseList.map((codeUse) => CodeUse.fromJson(codeUse)).toList();
      } else {
        print('Failed to load code uses by code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching code uses by code: $error');
    }
    return codeUses;
  }

  Future<CodeUse?> addCodeUse(CodeUse codeUse) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(codeUse.toJson()),
      );
      if (response.statusCode == 200) {
        final newCodeUse = json.decode(response.body) as Map<String, dynamic>;
        return CodeUse.fromJson(newCodeUse);
      } else {
        print('Failed to add code use: ${response.statusCode}');
      }
    } catch (error) {
      print('Error adding code use: $error');
    }
    return null;
  }

  Future<bool> updateCodeUse(CodeUse codeUse) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/${codeUse.id}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(codeUse.toJson()),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to update code use: ${response.statusCode}');
      }
    } catch (error) {
      print('Error updating code use: $error');
    }
    return false;
  }

  Future<bool> deleteCodeUse(String id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));
      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to delete code use: ${response.statusCode}');
      }
    } catch (error) {
      print('Error deleting code use: $error');
    }
    return false;
  }
}
