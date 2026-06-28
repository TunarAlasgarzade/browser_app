import 'package:app_links/app_links.dart';
import 'package:browser_app/pages/home_page.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String? initialUrl;
  try {
    final appLinks = AppLinks();
    final uri = await appLinks.getInitialLink();
    initialUrl = uri?.toString();
  } catch (e) {
    initialUrl = null;
  }
  runApp(MyApp(initialUrl: initialUrl));
}

class MyApp extends StatelessWidget {
  final String? initialUrl;
  const MyApp({super.key, required this.initialUrl});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
      ),
      home: HomePage(initialUrl: initialUrl),
      debugShowCheckedModeBanner: false,
    );
  }
}