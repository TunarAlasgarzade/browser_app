import 'package:browser_app/theme/theme_controller.dart';
import 'package:browser_app/pages/history_page.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Column(
        children: [
          ListTile(
            title: Text('History'),
            leading: Icon(Icons.history),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => HistoryPage()));
            }
          ),
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: themeController.themeMode == ThemeMode.dark,
            onChanged: (value) {
              themeController.toggleDarkMode(value);
            },
          )
        ],
      ),
    );
  }
}