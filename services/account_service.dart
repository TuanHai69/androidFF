import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/account.dart';

class AccountService {
  static const String baseUrl = 'http://192.168.56.1:3000/api/accounts';

  Future<Account?> fetchAccount(String id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$id'));

      if (response.statusCode == 200) {
        final accountMap = json.decode(response.body) as Map<String, dynamic>;
        return Account.fromJson(accountMap);
      } else {
        print('Failed to load account: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching account: $error');
    }
    return null;
  }

  Future<List<Account>> fetchAllAccounts() async {
    List<Account> accounts = [];
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        final accountList = json.decode(response.body) as List<dynamic>;
        accounts =
            accountList.map((account) => Account.fromJson(account)).toList();
      } else {
        print('Failed to load accounts: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching accounts: $error');
    }
    return accounts;
  }

  Future<String> addAccount(Map<String, dynamic> accountData) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(accountData),
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body) as Map<String, dynamic>;
        return responseBody['message'] ?? 'Tài khoản đã được tạo thành công';
      } else if (response.statusCode == 400) {
        final errorResponse =
            json.decode(response.body) as Map<String, dynamic>;
        throw Exception(errorResponse['message']);
      } else {
        throw Exception('Thêm tài khoản thất bại: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('$error');
    }
  }

  Future<bool> updateAccount(Account account) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/${account.id}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(account.toJson()),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to update account: ${response.statusCode}');
      }
    } catch (error) {
      print('Error updating account: $error');
    }
    return false;
  }

  Future<bool> deleteAccount(String id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));
      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to delete account: ${response.statusCode}');
      }
    } catch (error) {
      print('Error deleting account: $error');
    }
    return false;
  }

  Future<Account?> login(String keyword) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': keyword}),
      );

      if (response.statusCode == 200) {
        final accountData = json.decode(response.body) as Map<String, dynamic>;
        return Account.fromJson(accountData);
      } else {
        print('Failed to login: ${response.statusCode}');
      }
    } catch (error) {
      print('Error logging in: $error');
    }
    return null;
  }
}
