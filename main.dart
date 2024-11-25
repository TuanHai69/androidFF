import 'package:flutter/material.dart';
import 'package:flutter_application_1/ui/order/order_manager.dart';
import 'package:flutter_application_1/ui/products/comment_manager.dart';
import 'ui/stores/commentstore_manager.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';
import 'ui/accounts/account_manager.dart';
import 'ui/accounts/login.dart';
import 'ui/accounts/register.dart';
import 'ui/carts/cart_manager.dart';
import 'ui/products/product_manager.dart';
import 'ui/stores/store_manager.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AccountManager()),
        ChangeNotifierProvider(create: (context) => StoreManager()),
        ChangeNotifierProvider(create: (context) => ProductManager()),
        ChangeNotifierProvider(create: (context) => CartManager()),
        ChangeNotifierProvider(create: (context) => CommentStoreManager()),
        ChangeNotifierProvider(create: (context) => CommentManager()),
        ChangeNotifierProvider(create: (context) => OrderManager()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
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
