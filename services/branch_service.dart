import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/branch.dart';

class BranchService {
  static const String baseUrl = 'http://192.168.56.1:3000/api/branch';

  Future<Branch?> fetchBranch(String id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$id'));

      if (response.statusCode == 200) {
        final branchMap = json.decode(response.body) as Map<String, dynamic>;
        return Branch.fromJson(branchMap);
      } else {
        print('Failed to load branch: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching branch: $error');
    }
    return null;
  }

  Future<List<Branch>> fetchAllBranches() async {
    List<Branch> branches = [];
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        final branchList = json.decode(response.body) as List<dynamic>;
        branches = branchList.map((branch) => Branch.fromJson(branch)).toList();
      } else {
        print('Failed to load branches: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching branches: $error');
    }
    return branches;
  }

  Future<List<Branch>> fetchBranchesByUser(String userid) async {
    List<Branch> branches = [];
    try {
      final response = await http.get(Uri.parse('$baseUrl/user/$userid'));
      if (response.statusCode == 200) {
        final branchList = json.decode(response.body) as List<dynamic>;
        branches = branchList.map((branch) => Branch.fromJson(branch)).toList();
      } else {
        print('Failed to load branches by user: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching branches by user: $error');
    }
    return branches;
  }

  Future<Branch?> addBranch(Branch branch) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(branch.toJson()),
      );
      if (response.statusCode == 200) {
        final newBranch = json.decode(response.body) as Map<String, dynamic>;
        return Branch.fromJson(newBranch);
      } else {
        print('Failed to add branch: ${response.statusCode}');
      }
    } catch (error) {
      print('Error adding branch: $error');
    }
    return null;
  }

  Future<bool> updateBranch(Branch branch) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/${branch.id}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(branch.toJson()),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to update branch: ${response.statusCode}');
      }
    } catch (error) {
      print('Error updating branch: $error');
    }
    return false;
  }

  Future<bool> deleteBranch(String id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));
      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to delete branch: ${response.statusCode}');
      }
    } catch (error) {
      print('Error deleting branch: $error');
    }
    return false;
  }
}
