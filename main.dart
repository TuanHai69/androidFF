import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'ui/accounts/account_test_page.dart';
import 'ui/screens.dart';

Future<void> main() async {
// (1) Load the .env file
  await dotenv.load();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: Colors.indigo,
      secondary: Colors.deepOrange,
      background: Colors.white,
      surfaceTint: Colors.grey[200],
    );

    return MultiProvider(
      providers: [],
      child: Consumer(builder: (ctx, authManager, child) {
        return MaterialApp(
          routes: {},
          onGenerateRoute: (settings) {
            return null;
          },
        );
      }),
    );
  }
}
