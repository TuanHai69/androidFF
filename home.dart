import 'package:flutter/material.dart';
import 'package:flutter_application_1/ui/accounts/account_screen.dart';
import 'package:flutter_application_1/ui/carts/cart_screen.dart';
import 'package:provider/provider.dart';
import 'ui/stores/store_screen.dart';
import 'ui/products/product_screen.dart';

class HomePageState extends ChangeNotifier {
  int _selectedIndex = 0;

  static final _pages = <Widget>[
    const StoreScreen(),
    const ProductScreen(),
    const CartScreen(),
    const AccountScreen(),
  ];

  int get selectedIndex => _selectedIndex;
  List<Widget> get pages => _pages;

  void setIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomePageState(),
      child: Consumer<HomePageState>(
        builder: (context, homePageState, child) {
          return Scaffold(
            body: homePageState.pages[homePageState.selectedIndex],
            bottomNavigationBar: BottomNavigationBar(
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Trang Chủ',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.shop,
                  ),
                  label: 'Sản phẩm',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.task_sharp),
                  label: 'giỏ hàng',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Tài Khoản',
                ),
              ],
              currentIndex: homePageState.selectedIndex,
              selectedItemColor: Colors.pink,
              unselectedItemColor: Colors.grey,
              onTap: homePageState.setIndex,
            ),
          );
        },
      ),
    );
  }
}
