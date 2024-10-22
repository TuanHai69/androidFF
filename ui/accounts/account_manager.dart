import 'package:flutter/foundation.dart';

import '../../models/account.dart';
import '../../services/account_service.dart';

class AccountManager with ChangeNotifier {
  Account? _account;
  List<Account> _accounts = [];

  final AccountService _accountService = AccountService();

  Future<Account?> fetchAccount(String id) async {
    print(id);
    _account = await _accountService.fetchAccount(id);
    print(_account);
    notifyListeners();
    return _account;
  }

  Future<void> fetchAllAccounts() async {
    _accounts = await _accountService.fetchAllAccounts();
    notifyListeners();
  }

  int get accountCount {
    return _accounts.length;
  }

  Future<Account?> addAccount(Account account) async {
    print(account.address);
    final newAccount = await _accountService.addAccount(account);
    if (newAccount != null) {
      _accounts.add(newAccount);
      notifyListeners();
    }
    return newAccount;
  }

  Account? get account {
    return _account;
  }

  String? get id {
    return _account?.id;
  }

  String? get name {
    return _account?.name;
  }

  List<Account> get accounts {
    return [..._accounts];
  }

  Future<Account?> updateAccount(Account account) async {
    final updated = await _accountService.updateAccount(account);
    if (updated) {
      final index = _accounts.indexWhere((acc) => acc.id == account.id);
      if (index != -1) {
        _accounts[index] = account;
        notifyListeners();
      }
    }
    return account;
  }

  // Future<bool> deleteAccount(String id) async {
  //   final success = await _accountService.deleteAccount(id);
  //   if (success) {
  //     _accounts.removeWhere((account) => account.id == id);
  //     notifyListeners();
  //   }
  //   return success;
  // }

  Future<Account?> login(String keyword) async {
    final account = await _accountService.login(keyword);
    if (account != null) {
      _account = account;
      notifyListeners();
    }
    return account;
  }
}
