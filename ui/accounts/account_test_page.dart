import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/account.dart';
import 'account_manager.dart';

class AccountTestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AccountManager(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Account Test Page'),
        ),
        body: AccountTestWidget(),
      ),
    );
  }
}

class AccountTestWidget extends StatelessWidget {
  final TextEditingController _keywordController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final accountManager = Provider.of<AccountManager>(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _keywordController,
            decoration: InputDecoration(labelText: 'Keyword (email/username)'),
          ),
          ElevatedButton(
            onPressed: () async {
              final account =
                  await accountManager.login(_keywordController.text);
              if (account != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Logged in as ${account.name}')),
                );
              }
            },
            child: Text('Login'),
          ),
          TextField(
            controller: _idController,
            decoration: InputDecoration(labelText: 'Account ID'),
          ),
          ElevatedButton(
            onPressed: () async {
              final account =
                  await accountManager.fetchAccount(_idController.text);
              if (account != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Fetched account: ${account.name}')),
                );
              }
            },
            child: Text('Fetch Account'),
          ),
          ElevatedButton(
            onPressed: () async {
              await accountManager.fetchAllAccounts();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Fetched all accounts')),
              );
            },
            child: Text('Fetch All Accounts'),
          ),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(labelText: 'Name'),
          ),
          TextField(
            controller: _emailController,
            decoration: InputDecoration(labelText: 'Email'),
          ),
          ElevatedButton(
            onPressed: () async {
              final newAccount = Account(
                id: '',
                username: 'new_user',
                name: _nameController.text,
                picture: '',
                birthday: DateTime.now(),
                gender: 'Other',
                password: 'password',
                address: 'Address1111',
                phonenumber: '123456789',
                email: _emailController.text,
                role: 'User',
              );
              final account = await accountManager.addAccount(newAccount);
              if (account != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Added account: ${account.name}')),
                );
              }
            },
            child: Text('Add Account'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (accountManager.account != null) {
                final updatedAccount = accountManager.account!.copyWith(
                  name: _nameController.text,
                  email: _emailController.text,
                );
                final account =
                    await accountManager.updateAccount(updatedAccount);
                if (account != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Updated account: ${account.name}')),
                  );
                }
              }
            },
            child: Text('Update Account'),
          ),
          // ElevatedButton(
          //   onPressed: () async {
          //     if (accountManager.account != null) {
          //       final success = await accountManager
          //           .deleteAccount(accountManager.account!.id);
          //       if (success) {
          //         ScaffoldMessenger.of(context).showSnackBar(
          //           SnackBar(content: Text('Deleted account')),
          //         );
          //       }
          //     }
          //   },
          //   child: Text('Delete Account'),
          // ),
        ],
      ),
    );
  }
}
