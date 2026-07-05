import 'package:browser_app/pages/history_page.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListTile(
        title: Text('History'),
        leading: Icon(Icons.history),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => HistoryPage()));
        }
      ),
    );
  }
}