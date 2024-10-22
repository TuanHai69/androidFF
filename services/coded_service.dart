import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/coded.dart';

class CodedService {
  static const String baseUrl = 'http://192.168.56.1:3000/api/coded';

  Future<Coded?> fetchCoded(String id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$id'));

      if (response.statusCode == 200) {
        final codedMap = json.decode(response.body) as Map<String, dynamic>;
        return Coded.fromJson(codedMap);
      } else {
        print('Failed to load coded: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching coded: $error');
    }
    return null;
  }

  Future<List<Coded>> fetchAllCodeds() async {
    List<Coded> codeds = [];
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        final codedList = json.decode(response.body) as List<dynamic>;
        codeds = codedList.map((coded) => Coded.fromJson(coded)).toList();
      } else {
        print('Failed to load codeds: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching codeds: $error');
    }
    return codeds;
  }

  Future<List<Coded>> fetchCodedsByUser(String userid) async {
    List<Coded> codeds = [];
    try {
      final response = await http.get(Uri.parse('$baseUrl/user/$userid'));
      if (response.statusCode == 200) {
        final codedList = json.decode(response.body) as List<dynamic>;
        codeds = codedList.map((coded) => Coded.fromJson(coded)).toList();
      } else {
        print('Failed to load codeds by user: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching codeds by user: $error');
    }
    return codeds;
  }

  Future<List<Coded>> fetchCodedsByCode(String code) async {
    List<Coded> codeds = [];
    try {
      final response = await http.get(Uri.parse('$baseUrl/code/$code'));
      if (response.statusCode == 200) {
        final codedList = json.decode(response.body) as List<dynamic>;
        codeds = codedList.map((coded) => Coded.fromJson(coded)).toList();
      } else {
        print('Failed to load codeds by code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching codeds by code: $error');
    }
    return codeds;
  }

  Future<Coded?> addCoded(Coded coded) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(coded.toJson()),
      );
      if (response.statusCode == 200) {
        final newCoded = json.decode(response.body) as Map<String, dynamic>;
        return Coded.fromJson(newCoded);
      } else {
        print('Failed to add coded: ${response.statusCode}');
      }
    } catch (error) {
      print('Error adding coded: $error');
    }
    return null;
  }

  Future<bool> updateCoded(Coded coded) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/${coded.id}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(coded.toJson()),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to update coded: ${response.statusCode}');
      }
    } catch (error) {
      print('Error updating coded: $error');
    }
    return false;
  }

  Future<bool> deleteCoded(String id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));
      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to delete coded: ${response.statusCode}');
      }
    } catch (error) {
      print('Error deleting coded: $error');
    }
    return false;
  }
}
