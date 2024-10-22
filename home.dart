import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePageState extends ChangeNotifier {
  int _selectedIndex = 0;

  static final _pages = <Widget>[];

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
                  label: 'Đã đặt hàng',
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
