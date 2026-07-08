import 'theme/dark_theme.dart';
import 'theme/light_theme.dart';
import 'theme/theme_controller.dart';
import 'package:app_links/app_links.dart';
import 'package:browser_app/pages/home_page.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await themeController.loadTheme();
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
  MyApp({super.key, required this.initialUrl});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: themeController,
      builder: (context, child) {
        return MaterialApp(
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: themeController.themeMode,
          debugShowCheckedModeBanner: false,
          home: HomePage(initialUrl: initialUrl),
        );
      },
    );
  }
}