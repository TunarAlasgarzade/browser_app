import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BrowserMenu extends StatelessWidget {
  final WebViewController controller;
  const BrowserMenu({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (context) => [
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
      ],
      onSelected: (value) {
        if (value == 'back') {
          controller.goBack();
        } else if (value == 'forward') {
          controller.goForward();
        } else if (value == 'reload') {
          controller.reload();
        }
      },
    );
  }
}