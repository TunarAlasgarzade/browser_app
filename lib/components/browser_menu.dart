import 'package:browser_app/pages/settings_page.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BrowserMenu extends StatelessWidget {
  final String currentUrl;
  final WebViewController controller;
  const BrowserMenu({
    super.key, 
    required this.controller, 
    required this.currentUrl
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      color: Theme.of(context).colorScheme.surface,
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'reload',
          child: Row(
            children: [
              Icon(Icons.refresh),
              SizedBox(width: 8),
              Text('Reload'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'back',
          child: Row(
            children: [
              Icon(Icons.arrow_back),
              SizedBox(width: 8),
              Text('Back'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'forward',
          child: Row(
            children: [
              Icon(Icons.arrow_forward),
              SizedBox(width: 8),
              Text('Forward'),
            ],
          ),
        ),
        if (currentUrl.isNotEmpty && currentUrl != "about:blank")
        PopupMenuItem(
          value: 'share',
          child: Row(
            children: [
              Icon(Icons.share_outlined),
              SizedBox(width: 8),
              Text('Share'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'settings',
          child: Row(
            children: [
              Icon(Icons.settings),
              SizedBox(width: 8),
              Text('Settings'),
            ],
          ),
        ),
      ],
      onSelected: (value) async {
        if (value == 'back') {
          controller.goBack();
        } else if (value == 'forward') {
          controller.goForward();
        } else if (value == 'reload') {
          controller.reload();
        } else if (value == 'share') {
          SharePlus.instance.share(ShareParams(text: await controller.currentUrl() ?? ''));
        } else if (value == 'settings') {Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage(),));}
      },
    );
  }
}