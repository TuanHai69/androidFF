// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/ui/accounts/account_page.dart';
// import 'package:flutter_application_1/ui/articals/article_slide.dart';
// import 'package:provider/provider.dart';

// import '../articals/user_article_screen.dart';
// import '../auth/auth_manager.dart';
// import '../orders/orders_screen.dart';
// import '../products/user_products_screen.dart';

// class AppDrawer extends StatelessWidget {
//   const AppDrawer({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       child: Column(
//         children: <Widget>[
//           AppBar(
//             title: const Text('Hello Friend!'),
//             automaticallyImplyLeading: false,
//           ),
//           const Divider(),
//           ListTile(
//             leading: const Icon(Icons.shop),
//             title: const Text('Shop'),
//             onTap: () {
//               Navigator.of(context).pushReplacementNamed('/');
//             },
//           ),
//           const Divider(),
//           ListTile(
//             leading: const Icon(Icons.person),
//             title: const Text('Account'),
//             onTap: () {
//               Navigator.of(context).pushReplacementNamed(AccountPage.routeName);
//             },
//           ),
//           const Divider(),
//           ListTile(
//             leading: const Icon(Icons.payment),
//             title: const Text('Articles'),
//             onTap: () {
//               Navigator.of(context)
//                   .pushReplacementNamed(ArticleSlide.routeName);
//             },
//           ),
//           const Divider(),
//           ListTile(
//             leading: const Icon(Icons.article_outlined),
//             title: const Text('Edit article'),
//             onTap: () {
//               Navigator.of(context)
//                   .pushReplacementNamed(UserArticlesScreen.routeName);
//             },
//           ),
//           const Divider(),
//           ListTile(
//             leading: const Icon(Icons.payment),
//             title: const Text('Orders'),
//             onTap: () {
//               Navigator.of(context)
//                   .pushReplacementNamed(OrdersScreen.routeName);
//             },
//           ),
//           const Divider(),
//           ListTile(
//             leading: const Icon(Icons.edit),
//             title: const Text('Manage Products'),
//             onTap: () {
//               Navigator.of(context)
//                   .pushReplacementNamed(UserProductsScreen.routeName);
//             },
//           ),
//           const Divider(),
//           ListTile(
//             leading: const Icon(Icons.exit_to_app),
//             title: const Text('Logout'),
//             onTap: () {
//               Navigator.of(context)
//                 ..pop()
//                 ..pushReplacementNamed('/');
//               context.read<AuthManager>().logout();
//               // .pushReplacementNamed(UserProductsScreen.routeName);
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
