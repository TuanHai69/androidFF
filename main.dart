import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';
import 'ui/accounts/account_manager.dart';
import 'ui/accounts/login.dart';
import 'ui/accounts/register.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AccountManager(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: FutureBuilder(
          future: _checkLoginState(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else {
              return snapshot.data == true
                  ? const HomePage()
                  : const LoginPage();
            }
          },
        ),
        routes: {
          '/home': (context) => const HomePage(),
          '/login': (context) => const LoginPage(),
          '/register': (context) => const RegisterPage(),
        },
      ),
    );
  }

  Future<bool> _checkLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('userId');
  }
}
